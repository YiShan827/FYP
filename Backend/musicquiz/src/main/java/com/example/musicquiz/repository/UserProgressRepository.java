package com.example.musicquiz.repository;

import com.example.musicquiz.model.User;
import com.example.musicquiz.model.UserProgress;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface UserProgressRepository extends JpaRepository<UserProgress, Long> {
    Optional<UserProgress> findByUserAndLevelName(User user, String levelName);
    Optional<UserProgress> findByUserIdAndLevelName(Long userId, String levelName);
    Optional<UserProgress> findByUserId(Long userId);
}