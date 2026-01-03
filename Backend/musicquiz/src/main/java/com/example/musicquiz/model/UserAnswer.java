package com.example.musicquiz.model;

import jakarta.persistence.*;

@Entity
@Table(name = "user_answers")
public class UserAnswer {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "attempt_id", nullable = false)
    private QuizAttempt attempt;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "question_id")
    private Question question;

    @Column(name = "selected_answer")
    private String selectedAnswer;

    @Column(name = "is_correct")
    private Boolean isCorrect;

    @Column(name = "points_earned")
    private Integer pointsEarned = 0;

    // For legacy single-question quizzes
    @Column(name = "legacy_quiz_id")
    private Long legacyQuizId;

    // Constructors
    public UserAnswer() {}

    public UserAnswer(QuizAttempt attempt, Question question, String selectedAnswer,
                      Boolean isCorrect, Integer pointsEarned) {
        this.attempt = attempt;
        this.question = question;
        this.selectedAnswer = selectedAnswer;
        this.isCorrect = isCorrect;
        this.pointsEarned = pointsEarned;
    }

    // Constructor for legacy quizzes
    public UserAnswer(QuizAttempt attempt, String selectedAnswer, Boolean isCorrect,
                      Integer pointsEarned, Long legacyQuizId) {
        this.attempt = attempt;
        this.selectedAnswer = selectedAnswer;
        this.isCorrect = isCorrect;
        this.pointsEarned = pointsEarned;
        this.legacyQuizId = legacyQuizId;
    }

    // Getters and Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public QuizAttempt getAttempt() { return attempt; }
    public void setAttempt(QuizAttempt attempt) { this.attempt = attempt; }

    public Question getQuestion() { return question; }
    public void setQuestion(Question question) { this.question = question; }

    public String getSelectedAnswer() { return selectedAnswer; }
    public void setSelectedAnswer(String selectedAnswer) { this.selectedAnswer = selectedAnswer; }

    public Boolean getIsCorrect() { return isCorrect; }
    public void setIsCorrect(Boolean isCorrect) { this.isCorrect = isCorrect; }

    public Integer getPointsEarned() { return pointsEarned; }
    public void setPointsEarned(Integer pointsEarned) { this.pointsEarned = pointsEarned; }

    public Long getLegacyQuizId() { return legacyQuizId; }
    public void setLegacyQuizId(Long legacyQuizId) { this.legacyQuizId = legacyQuizId; }
}