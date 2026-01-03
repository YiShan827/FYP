package com.example.musicquiz.dto;

import java.time.LocalDateTime;
import java.math.BigDecimal;

public class UserProgressDTO {
    private Long quizId;
    private String quizTitle;
    private String quizDescription;
    private String topic;
    private String level;
    private Integer bestScore;
    private BigDecimal bestPercentage;
    private Integer attemptsCount;
    private LocalDateTime lastAttemptDate;
    private Boolean isCompleted;

    // Legacy fields for backward compatibility
    private String username;
    private int completedQuizzes;

    public UserProgressDTO() {}

    public UserProgressDTO(Long quizId, String quizTitle, String quizDescription, String topic, String level,
                           Integer bestScore, BigDecimal bestPercentage, Integer attemptsCount,
                           LocalDateTime lastAttemptDate, Boolean isCompleted) {
        this.quizId = quizId;
        this.quizTitle = quizTitle;
        this.quizDescription = quizDescription;
        this.topic = topic;
        this.level = level;
        this.bestScore = bestScore;
        this.bestPercentage = bestPercentage;
        this.attemptsCount = attemptsCount;
        this.lastAttemptDate = lastAttemptDate;
        this.isCompleted = isCompleted;
    }

    // Legacy constructor
    public UserProgressDTO(Long id, String email, String levelName, int score) {
        this.username = email;
        this.level = levelName;
        this.completedQuizzes = score;
    }

    // Getters and Setters
    public Long getQuizId() { return quizId; }
    public void setQuizId(Long quizId) { this.quizId = quizId; }

    public String getQuizTitle() { return quizTitle; }
    public void setQuizTitle(String quizTitle) { this.quizTitle = quizTitle; }

    public String getQuizDescription() { return quizDescription; }
    public void setQuizDescription(String quizDescription) { this.quizDescription = quizDescription; }

    public String getTopic() { return topic; }
    public void setTopic(String topic) { this.topic = topic; }

    public String getLevel() { return level; }
    public void setLevel(String level) { this.level = level; }

    public Integer getBestScore() { return bestScore; }
    public void setBestScore(Integer bestScore) { this.bestScore = bestScore; }

    public BigDecimal getBestPercentage() { return bestPercentage; }
    public void setBestPercentage(BigDecimal bestPercentage) { this.bestPercentage = bestPercentage; }

    public Integer getAttemptsCount() { return attemptsCount; }
    public void setAttemptsCount(Integer attemptsCount) { this.attemptsCount = attemptsCount; }

    public LocalDateTime getLastAttemptDate() { return lastAttemptDate; }
    public void setLastAttemptDate(LocalDateTime lastAttemptDate) { this.lastAttemptDate = lastAttemptDate; }

    public Boolean getIsCompleted() { return isCompleted; }
    public void setIsCompleted(Boolean isCompleted) { this.isCompleted = isCompleted; }

    // Legacy getters and setters
    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    public int getCompletedQuizzes() { return completedQuizzes; }
    public void setCompletedQuizzes(int completedQuizzes) { this.completedQuizzes = completedQuizzes; }
}