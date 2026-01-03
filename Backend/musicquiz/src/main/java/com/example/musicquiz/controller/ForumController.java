// controller/ForumController.java
package com.example.musicquiz.controller;

import com.example.musicquiz.dto.*;
import com.example.musicquiz.model.ForumCategory;
import com.example.musicquiz.model.User;
import com.example.musicquiz.service.ForumService;
import com.example.musicquiz.security.JwtUtil; // Assuming you have JWT utility
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import com.example.musicquiz.repository.UserRepository;

import jakarta.servlet.http.HttpServletRequest;
import java.util.List;
import java.util.Map;
import java.util.Optional;

@RestController
@RequestMapping("/api/forum")
@CrossOrigin(origins = "*") // Configure based on your needs
public class ForumController {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private ForumService forumService;

    @Autowired
    private JwtUtil jwtUtil; // Assuming you have JWT utility

    // =============== CATEGORY ENDPOINTS ===============

    @GetMapping("/categories")
    public ResponseEntity<List<ForumCategoryDTO>> getAllCategories() {
        try {
            List<ForumCategoryDTO> categories = forumService.getAllCategories();
            return ResponseEntity.ok(categories);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }

    @GetMapping("/categories/{id}")
    public ResponseEntity<ForumCategoryDTO> getCategoryById(@PathVariable Long id) {
        try {
            Optional<ForumCategory> category = forumService.getCategoryById(id);
            if (category.isPresent()) {
                ForumCategory cat = category.get();
                ForumCategoryDTO dto = new ForumCategoryDTO(
                        cat.getId(), cat.getName(), cat.getDescription(),
                        cat.getCreatedAt(), 0 // You can get post count if needed
                );
                return ResponseEntity.ok(dto);
            }
            return ResponseEntity.notFound().build();
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }

    // =============== POST ENDPOINTS ===============

    @GetMapping("/posts")
    public ResponseEntity<List<ForumPostDTO>> getPostsByCategory(
            @RequestParam Long categoryId) {
        try {
            List<ForumPostDTO> posts = forumService.getPostsByCategory(categoryId);
            return ResponseEntity.ok(posts);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }

    @GetMapping("/posts/{id}")
    public ResponseEntity<Map<String, Object>> getPostWithReplies(@PathVariable Long id) {
        try {
            Map<String, Object> result = forumService.getPostWithReplies(id);
            return ResponseEntity.ok(result);
        } catch (RuntimeException e) {
            return ResponseEntity.notFound().build();
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }

    private Long extractUserIdFromToken(HttpServletRequest request) {
        try {
            String authHeader = request.getHeader("Authorization");
            System.out.println("🔍 Auth Header: " + authHeader); // DEBUG

            if (authHeader != null && authHeader.startsWith("Bearer ")) {
                String token = authHeader.substring(7);

                // Extract email from token (your JWT uses email as subject)
                String email = jwtUtil.extractUsername(token); // This actually gets email
                System.out.println("🔍 Extracted Email: " + email); // DEBUG

                if (email != null) {
                    // Option 1: Find user by email instead of username
                    Optional<User> userOpt = userRepository.findByEmail(email);
                    System.out.println("🔍 User found by email: " + userOpt.isPresent()); // DEBUG

                    if (userOpt.isPresent()) {
                        Long userId = userOpt.get().getId();
                        System.out.println("🔍 User ID: " + userId); // DEBUG
                        return userId;
                    }
                }
            }
            return null;
        } catch (Exception e) {
            System.out.println("🚨 Error in extractUserIdFromToken: " + e.getMessage()); // DEBUG
            e.printStackTrace();
            return null;
        }
    }

    @PostMapping("/posts")
    public ResponseEntity<?> createPost(
            @RequestBody CreatePostRequest request,
            HttpServletRequest httpRequest) {
        try {
            // Manual validation
            if (!request.isValid()) {
                return ResponseEntity.badRequest()
                        .body(Map.of("error", request.getValidationError()));
            }

            // Extract user ID from JWT token
            Long userId = extractUserIdFromToken(httpRequest);
            if (userId == null) {
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                        .body(Map.of("error", "Invalid or missing authentication token"));
            }

            ForumPostDTO createdPost = forumService.createPost(request, userId);
            return ResponseEntity.status(HttpStatus.CREATED).body(createdPost);
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest()
                    .body(Map.of("error", e.getMessage()));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(Map.of("error", "Internal server error"));
        }
    }

    @GetMapping("/search")
    public ResponseEntity<List<ForumPostDTO>> searchPosts(@RequestParam String q) {
        try {
            if (q == null || q.trim().isEmpty()) {
                return ResponseEntity.badRequest().build();
            }

            List<ForumPostDTO> posts = forumService.searchPosts(q.trim());
            return ResponseEntity.ok(posts);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }

    // =============== REPLY ENDPOINTS ===============

    @GetMapping("/posts/{postId}/replies")
    public ResponseEntity<List<ForumReplyDTO>> getRepliesByPost(@PathVariable Long postId) {
        try {
            List<ForumReplyDTO> replies = forumService.getRepliesByPost(postId);
            return ResponseEntity.ok(replies);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }

    @PostMapping("/replies")
    public ResponseEntity<?> createReply(
            @RequestBody CreateReplyRequest request,
            HttpServletRequest httpRequest) {
        try {
            // Manual validation
            if (!request.isValid()) {
                return ResponseEntity.badRequest()
                        .body(Map.of("error", request.getValidationError()));
            }

            // Extract user ID from JWT token
            Long userId = extractUserIdFromToken(httpRequest);
            if (userId == null) {
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                        .body(Map.of("error", "Invalid or missing authentication token"));
            }

            ForumReplyDTO createdReply = forumService.createReply(request, userId);
            return ResponseEntity.status(HttpStatus.CREATED).body(createdReply);
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest()
                    .body(Map.of("error", e.getMessage()));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(Map.of("error", "Internal server error"));
        }
    }

    // =============== UTILITY METHODS ===============

    private String extractUsernameFromToken(HttpServletRequest request) {
        try {
            String authHeader = request.getHeader("Authorization");
            if (authHeader != null && authHeader.startsWith("Bearer ")) {
                String token = authHeader.substring(7);
                return jwtUtil.extractUsername(token);
            }
            return null;
        } catch (Exception e) {
            return null;
        }
    }

    // =============== ADMIN/SETUP ENDPOINTS (Optional) ===============

    @PostMapping("/admin/initialize")
    public ResponseEntity<String> initializeDefaultCategories() {
        try {
            forumService.initializeDefaultCategories();
            return ResponseEntity.ok("Default categories initialized successfully");
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("Failed to initialize categories");
        }
    }

    // =============== ERROR HANDLING ===============

    @ExceptionHandler(RuntimeException.class)
    public ResponseEntity<Map<String, String>> handleRuntimeException(RuntimeException e) {
        return ResponseEntity.badRequest()
                .body(Map.of("error", e.getMessage()));
    }

    @ExceptionHandler(Exception.class)
    public ResponseEntity<Map<String, String>> handleException(Exception e) {
        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                .body(Map.of("error", "Internal server error"));
    }

    @GetMapping("/debug-auth")
    public ResponseEntity<?> debugAuth(HttpServletRequest request) {
        String authHeader = request.getHeader("Authorization");
        return ResponseEntity.ok("Auth header: " + authHeader);
    }
}