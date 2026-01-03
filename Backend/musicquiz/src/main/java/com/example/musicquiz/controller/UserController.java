package com.example.musicquiz.controller;

import com.example.musicquiz.dto.*;
import com.example.musicquiz.model.User;
import com.example.musicquiz.service.UserService;
import com.example.musicquiz.security.JwtUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.bind.annotation.*;
import com.example.musicquiz.repository.UserRepository;

//import javax.validation.Valid;
import java.util.*;
import java.util.regex.Pattern;

@RestController
@RequestMapping("/api/users")
@CrossOrigin(origins = "*") // In production, specify actual origins
public class UserController {

    @Autowired
    private final UserService userService;
    private final PasswordEncoder passwordEncoder;
    private final JwtUtil jwtUtil;
    private final UserRepository userRepository;
    // Email validation pattern
    private static final Pattern EMAIL_PATTERN =
            Pattern.compile("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$");

    @Autowired
    public UserController(UserRepository userRepository, UserService userService, PasswordEncoder passwordEncoder, JwtUtil jwtUtil) {
        this.userService = userService;
        this.passwordEncoder = passwordEncoder;
        this.jwtUtil = jwtUtil;
        this.userRepository = userRepository;
    }

    @PostMapping("/register")
    public ResponseEntity<?> registerUser(@RequestBody User user) {
        try {
            // Validate full name
            if (user.getFullName() == null || user.getFullName().isBlank()) {
                return ResponseEntity.badRequest().body(createErrorResponse("Full name is required"));
            }

            // Validate email and password
            ValidationResult validation = validateRegistrationInput(user);
            if (!validation.isValid()) {
                return ResponseEntity.badRequest().body(createErrorResponse(validation.getError()));
            }

            // Check if email already exists
            if (userService.findByEmail(user.getEmail().toLowerCase()).isPresent()) {
                return ResponseEntity.badRequest().body(createErrorResponse("User with this email already exists"));
            }

            // Normalize email
            user.setEmail(user.getEmail().toLowerCase().trim());

            // Register user
            User savedUser = userService.registerUser(user);

            // Generate token
            Map<String, Object> claims = new HashMap<>();
            claims.put("role", savedUser.getRole().name());

            String token = jwtUtil.generateToken(claims, savedUser.getEmail());

            // Response body
            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("message", "User registered successfully");
            response.put("token", token);
            response.put("user", Map.of(
                    "id", savedUser.getId(),
                    "email", savedUser.getEmail(),
                    "fullName", savedUser.getFullName()
            ));

            return ResponseEntity.ok(response);

        } catch (Exception e) {
            System.err.println("Registration error: " + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(createErrorResponse("Registration failed. Please try again."));
        }
    }



    @PostMapping("/login")
    public ResponseEntity<?> login(@RequestBody LoginRequest loginRequest) {
        try {
            // Input validation
            ValidationResult validation = validateLoginInput(loginRequest);
            if (!validation.isValid()) {
                return ResponseEntity.badRequest().body(createErrorResponse(validation.getError()));
            }

            // Normalize email
            String email = loginRequest.getEmail().toLowerCase().trim();

            Optional<User> foundUser = userService.findByEmail(email);

            if (foundUser.isPresent()) {
                if (passwordEncoder.matches(loginRequest.getPassword(), foundUser.get().getPassword())) {
                    Map<String, Object> claims = new HashMap<>();
                    claims.put("role", foundUser.get().getRole().name());
                    String token = jwtUtil.generateToken(claims, foundUser.get().getEmail());

                    // Return success response
                    Map<String, Object> response = new HashMap<>();
                    response.put("success", true);
                    response.put("message", "Login successful");
                    response.put("token", token);
                    response.put("user", Map.of("id", foundUser.get().getId(), "email", foundUser.get().getEmail(),"name", foundUser.get().getFullName()));

                    return ResponseEntity.ok(response);
                }
            }

            // Generic error message for security (don't reveal if email exists)
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                    .body(createErrorResponse("Invalid email or password"));

        } catch (Exception e) {
            // Log error (use proper logging framework in production)
            System.err.println("Login error: " + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(createErrorResponse("Login failed. Please try again."));
        }
    }

//    @PostMapping("/forgot-password")
//    public ResponseEntity<?> resetPassword(@RequestBody ForgotPasswordRequest request) {
//        String email = request.getEmail();
//        String newPassword = request.getNewPassword();
//
//        // Basic manual email validation
//        if (email == null || !email.matches("^[\\w.-]+@[\\w.-]+\\.\\w+$")) {
//            return ResponseEntity.badRequest().body(createErrorResponse("Invalid email format"));
//        }
//
//        if (newPassword == null || newPassword.length() < 6) {
//            return ResponseEntity.badRequest().body("Password must be at least 6 characters");
//        }
//
//        // Proceed with your reset logic
//        boolean result = userService.resetPassword(email, newPassword);
//        if (result) {
//            return ResponseEntity.ok("Password reset successful");
//        } else {
//            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("Email not found");
//        }
//    }

    @PostMapping("/request-password-reset")
    public ResponseEntity<?> requestPasswordReset(@RequestBody EmailRequest request) {
        String email = request.getEmail();

        if (email == null || !email.matches("^[\\w.-]+@[\\w.-]+\\.\\w+$")) {
            return ResponseEntity.badRequest().body(createErrorResponse("Invalid email format"));
        }

        boolean userExists = userService.checkUserExistsByEmail(email);
        if (userExists) {
            return ResponseEntity.ok("Email verified. Proceed to reset.");
        } else {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("Email not found");
        }
    }

    @PostMapping("/reset-password")
    public ResponseEntity<?> resetPassword(@RequestBody ForgotPasswordRequest request) {
        String email = request.getEmail();
        String newPassword = request.getNewPassword();

        if (email == null || !email.matches("^[\\w.-]+@[\\w.-]+\\.\\w+$")) {
            return ResponseEntity.badRequest().body(createErrorResponse("Invalid email format"));
        }
        if (newPassword == null || newPassword.length() < 6) {
            return ResponseEntity.badRequest().body(createErrorResponse("Password must be at least 6 characters"));
        }

        if (!newPassword.matches(".*[A-Z].*")) {
            return ResponseEntity.badRequest().body(createErrorResponse("Password must contain at least one uppercase letter"));
        }

        if (!newPassword.matches(".*[!@#$%^&*(),.?\":{}|<>].*")) {
            return ResponseEntity.badRequest().body(createErrorResponse("Password must contain at least one special character"));
        }
        boolean result = userService.resetPassword(email, newPassword);
        if (result) {
            return ResponseEntity.ok("Password reset successful");
        } else {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("Email not found");
        }

    }


    @GetMapping("/dashboard")
    public ResponseEntity<?> dashboard() {
        return ResponseEntity.ok(Map.of(
                "success", true,
                "message", "Welcome to your dashboard! This is a protected route."
        ));
    }

    // Helper methods for validation
    private ValidationResult validateRegistrationInput(User user) {
        if (user.getEmail() == null || user.getEmail().trim().isEmpty()) {
            return new ValidationResult(false, "Email is required");
        }

        if (!EMAIL_PATTERN.matcher(user.getEmail().trim()).matches()) {
            return new ValidationResult(false, "Please enter a valid email address");
        }

        if (user.getPassword() == null || user.getPassword().isEmpty()) {
            return new ValidationResult(false, "Password is required");
        }

        if (user.getPassword().length() < 6) {
            return new ValidationResult(false, "Password must be at least 6 characters long");
        }

        if (user.getPassword().length() > 100) {
            return new ValidationResult(false, "Password must be less than 100 characters");
        }

        return new ValidationResult(true, null);
    }

    private ValidationResult validateLoginInput(LoginRequest loginRequest) {
        if (loginRequest.getEmail() == null || loginRequest.getEmail().trim().isEmpty()) {
            return new ValidationResult(false, "Email is required");
        }

        if (!EMAIL_PATTERN.matcher(loginRequest.getEmail().trim()).matches()) {
            return new ValidationResult(false, "Please enter a valid email address");
        }

        if (loginRequest.getPassword() == null || loginRequest.getPassword().isEmpty()) {
            return new ValidationResult(false, "Password is required");
        }

        return new ValidationResult(true, null);
    }

    private Map<String, Object> createErrorResponse(String message) {
        Map<String, Object> response = new HashMap<>();
        response.put("success", false);
        response.put("error", message);
        return response;
    }

    // Inner class for validation results
    private static class ValidationResult {
        private final boolean valid;
        private final String error;

        public ValidationResult(boolean valid, String error) {
            this.valid = valid;
            this.error = error;
        }

        public boolean isValid() {
            return valid;
        }

        public String getError() {
            return error;
        }
    }

    @GetMapping("/users")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<List<UserDTO>> getAllUsers() {
        List<UserDTO> users = userRepository.findAll()
                .stream()
                .map(user -> new UserDTO(user.getId(), user.getEmail(), user.getRole().name()))
                .toList();

        return ResponseEntity.ok(users);
    }


}
