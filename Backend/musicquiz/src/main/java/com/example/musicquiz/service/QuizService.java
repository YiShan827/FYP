package com.example.musicquiz.service;

import com.example.musicquiz.dto.QuizSubmissionDto;
import com.example.musicquiz.model.*;
import com.example.musicquiz.repository.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.*;

@Service
public class QuizService {

    // Keep all your existing autowired repositories
    private final QuizRepository quizRepository;
    private final UserRepository userRepository;
    private final UserProgressRepository userProgressRepository;
    private final OptionRepository optionRepository;

    private final Map<Long, List<Long>> quickQuizSessions = new HashMap<>();

    @Autowired
    private QuestionRepository questionRepository;
    // Add just this one new repository
    @Autowired
    private QuizAttemptRepository quizAttemptRepository;

    @Autowired
    public QuizService(QuizRepository quizRepository,
                       UserRepository userRepository,
                       UserProgressRepository userProgressRepository,
                       OptionRepository optionRepository) {
        this.quizRepository = quizRepository;
        this.userRepository = userRepository;
        this.userProgressRepository = userProgressRepository;
        this.optionRepository = optionRepository;
    }

    // ===== KEEP ALL YOUR EXISTING METHODS EXACTLY AS THEY ARE =====

    public List<Quiz> getAllQuizzes() {
        return quizRepository.findAll();
    }

    public List<Quiz> getQuizzesByTopicAndLevel(String topic, String level) {
        return quizRepository.findByTopicAndLevel(topic, level);
    }

    public List<Quiz> getQuizzesByLevel(String level) {
        return quizRepository.findByLevel(level);
    }

    public Quiz addQuiz(Quiz quiz) {
        return quizRepository.save(quiz);
    }

    public int calculateScore(List<Long> questionIds, List<String> answers) {
        int score = 0;
        for (int i = 0; i < questionIds.size(); i++) {
            Optional<Quiz> quizOpt = quizRepository.findById(questionIds.get(i));
            if (quizOpt.isPresent() && quizOpt.get().getCorrectAnswer().equalsIgnoreCase(answers.get(i))) {
                score++;
            }
        }
        return score;
    }


    public void updateProgress(String email, String levelName, int score) {
        Optional<User> userOpt = userRepository.findByEmail(email);
        if (userOpt.isEmpty()) {
            throw new RuntimeException("User not found");
        }

        User user = userOpt.get();

        Optional<UserProgress> existing = userProgressRepository.findByUserAndLevelName(user, levelName);
        if (existing.isPresent()) {
            UserProgress progress = existing.get();
            progress.setScore(Math.max(progress.getScore(), score)); // Keep max score
            userProgressRepository.save(progress);
        } else {
            UserProgress progress = new UserProgress();
            progress.setUser(user);
            progress.setLevelName(levelName);
            progress.setScore(score);
            userProgressRepository.save(progress);
        }
    }

    public int submitQuiz(String email, QuizSubmissionDto request) {
        Optional<User> userOpt = userRepository.findByEmail(email);
        if (userOpt.isEmpty()) {
            throw new RuntimeException("User not found.");
        }

        User user = userOpt.get();
        String levelName = request.getLevelName();

        int score = 0;
        for (Long optionId : request.getSelectedOptionIds()) {
            Option option = optionRepository.findById(optionId)
                    .orElseThrow(() -> new RuntimeException("Option not found"));
            if (option.isCorrect()) {
                score++;
            }
        }

        UserProgress progress = userProgressRepository.findByUserAndLevelName(user, levelName)
                .orElseGet(() -> {
                    UserProgress newProgress = new UserProgress();
                    newProgress.setUser(user);
                    newProgress.setLevelName(levelName);
                    newProgress.setLevelCompleted(0);
                    newProgress.setScore(0);
                    return newProgress;
                });

        progress.setLevelCompleted(progress.getLevelCompleted() + 1);
        progress.setScore(progress.getScore() + score);

        userProgressRepository.save(progress);
        return score;
    }

    public List<Quiz> addAllQuizzes(List<Quiz> quizzes) {
        return quizRepository.saveAll(quizzes);
    }

    public void deleteQuiz(Long id) {
        if (!quizRepository.existsById(id)) {
            throw new RuntimeException("Quiz with ID " + id + " not found.");
        }
        quizRepository.deleteById(id);
    }

    // ===== ADD JUST THESE 4 NEW METHODS FOR ENHANCED QUIZ TAKING =====

    public Quiz getQuizById(Long quizId) {
        return quizRepository.findById(quizId)
                .orElseThrow(() -> new RuntimeException("Quiz not found with id: " + quizId));
    }

    public Long startQuizSession(Long userId, Long quizId) {
        // Simple implementation - just validate that quiz exists
        Quiz quiz = getQuizById(quizId);
        return quizId; // Return quizId as session identifier
    }

    public Map<String, Object> submitQuizWithScore(Long userId, Long quizId, String userAnswer) {
        Quiz quiz = getQuizById(quizId);

        // Simple scoring - check if answer is correct
        boolean isCorrect = quiz.getCorrectAnswer().equalsIgnoreCase(userAnswer.trim());
        int score = isCorrect ? 1 : 0;

        // Save the attempt
        QuizAttempt attempt = new QuizAttempt(userId, quizId, score, userAnswer);
        quizAttemptRepository.save(attempt);

        // Update user progress for this level
        updateSimpleProgress(userId, quiz.getLevel(), score);

        // Return results
        Map<String, Object> result = new HashMap<>();
        result.put("score", score);
        result.put("isCorrect", isCorrect);
        result.put("correctAnswer", quiz.getCorrectAnswer());
        result.put("userAnswer", userAnswer);
        result.put("explanation", isCorrect ? "Correct!" : "Incorrect. The correct answer is: " + quiz.getCorrectAnswer());

        return result;
    }

    public Map<String, Object> getUserStats(Long userId) {
        Integer totalAttempts = quizAttemptRepository.countTotalAttemptsByUserId(userId);
        Integer correctAnswers = quizAttemptRepository.countCorrectAnswersByUserId(userId);

        Map<String, Object> stats = new HashMap<>();
        stats.put("totalAttempts", totalAttempts != null ? totalAttempts : 0);
        stats.put("correctAnswers", correctAnswers != null ? correctAnswers : 0);
        stats.put("accuracy", totalAttempts != null && totalAttempts > 0 ?
                (double) correctAnswers / totalAttempts * 100 : 0.0);

        return stats;
    }

    // Helper method for updating progress
    private void updateSimpleProgress(Long userId, String level, int score) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found"));

        UserProgress progress = userProgressRepository.findByUserAndLevelName(user, level)
                .orElse(new UserProgress(user, level, 0));

        // Update progress
        progress.setScore(progress.getScore() + score);
        progress.setAttemptsCount(progress.getAttemptsCount() + 1);
        progress.setLastAttemptDate(LocalDateTime.now());

        if (score > progress.getBestScore()) {
            progress.setBestScore(score);
        }

        userProgressRepository.save(progress);
    }

    // Helper method to get user ID from email
    public Long getUserIdFromEmail(String email) {
        return userRepository.findByEmail(email)
                .map(User::getId)
                .orElseThrow(() -> new RuntimeException("User not found with email: " + email));
    }

    public List<Quiz> getRandomQuizzes(int count) {
        List<Quiz> allQuizzes = quizRepository.findAll();

        // Shuffle the list
        Collections.shuffle(allQuizzes);

        // Limit to 'count' number of quizzes
        if (count > allQuizzes.size()) {
            count = allQuizzes.size(); // avoid index out of bounds
        }

        return allQuizzes.subList(0, count);
    }

    public List<Question> getRandomQuestions(int count) {
        return questionRepository.findRandomQuestions(PageRequest.of(0, count));
    }

    public List<Quiz> getRandomQuizzesForSession(Long userId, int count) {
        List<Quiz> allQuizzes = quizRepository.findAll();
        List<Long> usedIds = quickQuizSessions.getOrDefault(userId, new ArrayList<>());

        List<Quiz> available = allQuizzes.stream()
                .filter(q -> !usedIds.contains(q.getId()))
                .toList();

        if (available.isEmpty()) {
            // Reset session
            quickQuizSessions.remove(userId);
            // Restart with all quizzes
            available = new ArrayList<>(allQuizzes);
        }

        Collections.shuffle(available);
        List<Quiz> selected = available.stream()
                .limit(count)
                .toList();

        usedIds.addAll(selected.stream().map(Quiz::getId).toList());
        quickQuizSessions.put(userId, usedIds);

        return selected;
    }

    public void endQuickQuizSession(Long userId) {
        quickQuizSessions.remove(userId);
    }

    public List<Quiz> getBiteSizedQuizzes(String level) {
        List<Quiz> allQuizzes = quizRepository.findByLevel(level);

        if (allQuizzes.isEmpty()) {
            return Collections.emptyList();
        }

        List<Quiz> biteSized = new ArrayList<>();
        Random random = new Random();

        for (int i = 0; i < 5; i++) {
            Quiz randomQuiz = allQuizzes.get(random.nextInt(allQuizzes.size()));
            biteSized.add(randomQuiz);
        }

        return biteSized;
    }

}