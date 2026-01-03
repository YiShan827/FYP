package com.example.musicquiz.service;

import com.example.musicquiz.dto.QuizSubmissionDto;
import com.example.musicquiz.model.*;
import com.example.musicquiz.repository.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Optional;

@Service
public class QuizSubmissionService {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private QuizRepository quizRepository;

    @Autowired
    private OptionRepository optionRepository;

    @Autowired
    private UserProgressRepository userProgressRepository;

    public int submitQuiz(String email, QuizSubmissionDto request) {
        Optional<User> userOpt = userRepository.findByEmail(email);
        if (userOpt.isEmpty()) {
            throw new RuntimeException("User not found.");
        }

        User user = userOpt.get();
        String levelName = request.getLevelName(); // ✅ FIXED: Declare and extract levelName

        int score = 0;
        for (Long optionId : request.getSelectedOptionIds()) {
            Option option = optionRepository.findById(optionId)
                    .orElseThrow(() -> new RuntimeException("Option not found"));
            if (option.isCorrect()) {
                score++;
            }
        }

        UserProgress progress = userProgressRepository.findByUserAndLevelName(user, levelName)
                .orElse(new UserProgress(user, levelName, 0));

        progress.setScore(progress.getScore() + score);
        userProgressRepository.save(progress);
        return score;
    }
}
