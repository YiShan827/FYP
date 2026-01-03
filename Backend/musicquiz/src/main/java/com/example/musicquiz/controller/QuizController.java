package com.example.musicquiz.controller;

import com.example.musicquiz.dto.QuizSubmissionDto;
import com.example.musicquiz.model.Quiz;
import com.example.musicquiz.repository.QuizRepository;
import com.example.musicquiz.security.JwtUtil;
import com.example.musicquiz.service.QuizService;
import com.example.musicquiz.service.QuizSubmissionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.*;

@RestController
@RequestMapping("/api/quizzes")
@CrossOrigin(origins = "*")
public class QuizController {

    @Autowired
    private final QuizService quizService;
    private final QuizRepository quizRepository;
    private final JwtUtil jwtUtil;

    public QuizController(QuizRepository quizRepository,QuizService quizService, JwtUtil jwtUtil) {
        this.quizService = quizService;
        this.jwtUtil = jwtUtil;
        this.quizRepository = quizRepository;
    }



    @Autowired
    private QuizSubmissionService quizSubmissionService;

    // ===== KEEP ALL YOUR EXISTING ENDPOINTS EXACTLY AS THEY ARE =====

    @GetMapping
    public ResponseEntity<List<Quiz>> getAllQuizzes() {
        return ResponseEntity.ok(quizService.getAllQuizzes());
    }

    @GetMapping("/{level}")
    public ResponseEntity<List<Quiz>> getQuizzesByLevel(@PathVariable String level) {
        return ResponseEntity.ok(quizService.getQuizzesByLevel(level));
    }


    @GetMapping("/by-topic-and-level")
    public ResponseEntity<List<Quiz>> getQuizzesByTopicAndLevel(
            @RequestParam String topic,
            @RequestParam String level) {
        List<Quiz> quizzes = quizService.getQuizzesByTopicAndLevel(topic, level);
        return ResponseEntity.ok(quizzes);
    }

    @GetMapping("/topics-by-level")
    public ResponseEntity<List<String>> getTopicsByLevel(@RequestParam String level) {
        List<String> topics = quizRepository.findDistinctTopicsByLevel(level);
        return ResponseEntity.ok(topics);
    }

    @PostMapping
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<?> addQuiz(@RequestBody Quiz quiz) {
        // Keep your EXACT existing validation logic
        if (quiz.getQuestion() == null || quiz.getQuestion().trim().isEmpty()) {
            return ResponseEntity.badRequest().body("Question must not be empty.");
        }
        if (quiz.getOptionA() == null || quiz.getOptionA().trim().isEmpty()) {
            return ResponseEntity.badRequest().body("Option A must not be empty.");
        }
        if (quiz.getOptionB() == null || quiz.getOptionB().trim().isEmpty()) {
            return ResponseEntity.badRequest().body("Option B must not be empty.");
        }
        if (quiz.getOptionC() == null || quiz.getOptionC().trim().isEmpty()) {
            return ResponseEntity.badRequest().body("Option C must not be empty.");
        }
        if (quiz.getOptionD() == null || quiz.getOptionD().trim().isEmpty()) {
            return ResponseEntity.badRequest().body("Option D must not be empty.");
        }
        if (quiz.getCorrectAnswer() == null || quiz.getCorrectAnswer().trim().isEmpty()) {
            return ResponseEntity.badRequest().body("Correct answer must not be empty.");
        }
        if (quiz.getLevel() == null || quiz.getLevel().trim().isEmpty()) {
            return ResponseEntity.badRequest().body("Level must not be empty.");
        }
        String correctAnswer = quiz.getCorrectAnswer().trim().toUpperCase();
        if (!Arrays.asList("A", "B", "C", "D").contains(correctAnswer)) {
            return ResponseEntity.badRequest().body("Correct answer must be A, B, C, or D.");
        }
        return ResponseEntity.ok(quizService.addQuiz(quiz));
    }

    @PostMapping("/bulk")
    public ResponseEntity<Object> addMultipleQuizzes(@RequestBody List<Quiz> quizzes) {
        // Validation loop
        for (Quiz quiz : quizzes) {
            String correctAnswer = quiz.getCorrectAnswer().trim().toUpperCase();
            if (!Arrays.asList("A", "B", "C", "D").contains(correctAnswer)) {
                return ResponseEntity.badRequest().body("All correct answers must be A, B, C, or D.");
            }
        }
        return ResponseEntity.ok(quizService.addAllQuizzes(quizzes));
    }

    @PostMapping("/submit")
    public ResponseEntity<?> submitQuiz(@RequestBody QuizSubmissionDto request,
                                        @RequestHeader("Authorization") String authHeader) {
        String token = authHeader.substring(7);
        String email = jwtUtil.extractUsername(token);

        int score = quizSubmissionService.submitQuiz(email, request);
        return ResponseEntity.ok(Collections.singletonMap("score", score));
    }

    @DeleteMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<?> deleteQuiz(@PathVariable Long id) {
        quizService.deleteQuiz(id);
        return ResponseEntity.ok().build();
    }

    // ===== ADD JUST THESE 3 NEW ENDPOINTS FOR ENHANCED QUIZ TAKING =====

    @PostMapping("/{quizId}/start")
    public ResponseEntity<Map<String, Object>> startQuiz(
            @PathVariable Long quizId,
            @RequestHeader("Authorization") String authHeader) {

        String token = authHeader.substring(7);
        String email = jwtUtil.extractUsername(token);
        Long userId = quizService.getUserIdFromEmail(email);

        Quiz quiz = quizService.getQuizById(quizId);
        Long sessionId = quizService.startQuizSession(userId, quizId);

        Map<String, Object> response = new HashMap<>();
        response.put("sessionId", sessionId);
        response.put("quizId", quiz.getId());
        response.put("question", quiz.getQuestion());
        response.put("options", Map.of(
                "A", quiz.getOptionA(),
                "B", quiz.getOptionB(),
                "C", quiz.getOptionC(),
                "D", quiz.getOptionD()
        ));
        response.put("topic", quiz.getTopic());
        response.put("level", quiz.getLevel());

        return ResponseEntity.ok(response);
    }

    @PostMapping("/{quizId}/submit-answer")
    public ResponseEntity<Map<String, Object>> submitAnswer(
            @PathVariable Long quizId,
            @RequestBody Map<String, String> request,
            @RequestHeader("Authorization") String authHeader) {

        //  Extract user info from token
        String token = authHeader.substring(7);
        String email = jwtUtil.extractUsername(token);
        Long userId = quizService.getUserIdFromEmail(email);

        //  Get submitted answer
        String userAnswer = request.get("answer");

        //  Get result of submission (correct/incorrect, score, etc.)
        Map<String, Object> result = quizService.submitQuizWithScore(userId, quizId, userAnswer);

        //  Fetch the quiz itself so we can include the full explanation/feedback
        Quiz quiz = quizService.getQuizById(quizId);
        if (quiz != null && quiz.getFeedback() != null) {
            result.put("explanation", quiz.getFeedback()); // Add detailed explanation
        }

        return ResponseEntity.ok(result);
    }

    @GetMapping("/quick-quiz")
    public ResponseEntity<List<Quiz>> getQuickQuiz(
            @RequestParam(defaultValue = "5") int count,
            @RequestHeader("Authorization") String authHeader) {

        String token = authHeader.substring(7);
        String email = jwtUtil.extractUsername(token);
        Long userId = quizService.getUserIdFromEmail(email);

        List<Quiz> quickQuizzes = quizService.getRandomQuizzesForSession(userId, count);
        return ResponseEntity.ok(quickQuizzes);
    }

    @PostMapping("/quick-quiz/end")
    public ResponseEntity<Void> endQuickQuiz(
            @RequestHeader("Authorization") String authHeader) {
        String token = authHeader.substring(7);
        String email = jwtUtil.extractUsername(token);
        Long userId = quizService.getUserIdFromEmail(email);

        quizService.endQuickQuizSession(userId);
        return ResponseEntity.ok().build();
    }

    @GetMapping("/my-stats")
    public ResponseEntity<Map<String, Object>> getUserStats(
            @RequestHeader("Authorization") String authHeader) {

        String token = authHeader.substring(7);
        String email = jwtUtil.extractUsername(token);
        Long userId = quizService.getUserIdFromEmail(email);

        Map<String, Object> stats = quizService.getUserStats(userId);

        return ResponseEntity.ok(stats);
    }

    @GetMapping("/bite/{level}")
    public ResponseEntity<List<Quiz>> getBiteSizedQuizzes(@PathVariable String level) {
        return ResponseEntity.ok(quizService.getBiteSizedQuizzes(level));
    }
}