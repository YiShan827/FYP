package com.example.musicquiz.service;

import com.example.musicquiz.dto.UserProgressDTO;
import com.example.musicquiz.model.UserProgress;
import com.example.musicquiz.repository.UserProgressRepository;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@Service
public class UserProgressService {

    private final UserProgressRepository progressRepository;

    public UserProgressService(UserProgressRepository progressRepository) {
        this.progressRepository = progressRepository;
    }

    public List<UserProgressDTO> getAllUserProgress() {
        List<UserProgress> progressList = progressRepository.findAll();

        return progressList.stream()
                .map(p -> new UserProgressDTO(
                        p.getUser().getId(),
                        p.getUser().getEmail(),
                        p.getLevelName(),
                        p.getScore()
                ))
                .collect(Collectors.toList());
    }
    public UserProgressDTO getProgressByUserIdAndLevel(Long userId, String levelName) {
        UserProgress progress = progressRepository.findByUserIdAndLevelName(userId, levelName)
                .orElseThrow(() -> new RuntimeException("Progress not found for user id: " + userId + " and level: " + levelName));

        return new UserProgressDTO(
                progress.getUser().getId(),
                progress.getUser().getEmail(),
                progress.getLevelName(),
                progress.getScore()
        );
    }

    public UserProgress getProgressForUser(Long userId) {
        return progressRepository.findByUserId(userId)
                .orElseThrow(() -> new RuntimeException("Progress not found for user id: " + userId));
    }

    }



