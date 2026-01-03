package com.example.musicquiz.controller;

import com.example.musicquiz.dto.UserProgressDTO;
import com.example.musicquiz.model.User;
import com.example.musicquiz.model.UserProgress;
import com.example.musicquiz.service.UserProgressService;
import com.example.musicquiz.repository.UserProgressRepository;
import com.example.musicquiz.repository.UserRepository;
import com.example.musicquiz.security.JwtUtil;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;
import java.util.Optional;

@RestController
@RequestMapping("/api/progress")
@CrossOrigin(origins = "*")
public class UserProgressController {

    private final UserRepository userRepository;
    private final UserProgressRepository progressRepository;
    private final JwtUtil jwtUtil;
    private final UserProgressService userProgressService; // ✅ Fixed here

    public UserProgressController(UserRepository userRepository,
                                  UserProgressRepository progressRepository,
                                  JwtUtil jwtUtil,
                                  UserProgressService userProgressService) {
        this.userRepository = userRepository;
        this.progressRepository = progressRepository;
        this.jwtUtil = jwtUtil;
        this.userProgressService = userProgressService;
    }

    @GetMapping
    public ResponseEntity<?> getProgress(@RequestHeader("Authorization") String authHeader,
                                         @RequestParam String levelName) {
        String token = authHeader.substring(7);
        String email = jwtUtil.extractUsername(token);

        Optional<User> userOpt = userRepository.findByEmail(email);
        if (userOpt.isEmpty()) return ResponseEntity.badRequest().body("User not found");

        User user = userOpt.get();
        return ResponseEntity.ok(progressRepository.findByUserAndLevelName(user, levelName));
    }

    @GetMapping("/admin/user-progress") // ✅ FIXED route to match base `/api/progress`
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<List<UserProgressDTO>> getAllUserProgress() {
        return ResponseEntity.ok(userProgressService.getAllUserProgress());
    }

    @GetMapping("/progress")
    public ResponseEntity<?> getUserProgress(@RequestHeader("Authorization") String authHeader) {
        String token = authHeader.replace("Bearer ", "");
        String email = jwtUtil.extractUsername(token);

        Optional<User> user = userRepository.findByEmail(email);
        if (user.isEmpty()) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("User not found");
        }

        UserProgress progress = userProgressService.getProgressForUser(user.get().getId());

        return ResponseEntity.ok(Map.of(
                "score", progress.getScore(),
                "level", progress.getLevelName()
        ));
    }
}


