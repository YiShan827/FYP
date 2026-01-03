package com.example.musicquiz.dto;

import java.util.List;

public class UserDashboardDto {
    private Long userId;
    private Integer completedQuizzes;
    private Integer totalQuizzes;
    private Double averageScore;
    private Integer totalAttempts;
    private List<UserProgressDTO> recentProgress;

    public UserDashboardDto() {}

    public UserDashboardDto(Long userId, Integer completedQuizzes, Integer totalQuizzes,
                            Double averageScore, Integer totalAttempts, List<UserProgressDTO> recentProgress) {
        this.userId = userId;
        this.completedQuizzes = completedQuizzes;
        this.totalQuizzes = totalQuizzes;
        this.averageScore = averageScore;
        this.totalAttempts = totalAttempts;
        this.recentProgress = recentProgress;
    }

    // Getters and Setters
    public Long getUserId() { return userId; }
    public void setUserId(Long userId) { this.userId = userId; }

    public Integer getCompletedQuizzes() { return completedQuizzes; }
    public void setCompletedQuizzes(Integer completedQuizzes) { this.completedQuizzes = completedQuizzes; }

    public Integer getTotalQuizzes() { return totalQuizzes; }
    public void setTotalQuizzes(Integer totalQuizzes) { this.totalQuizzes = totalQuizzes; }

    public Double getAverageScore() { return averageScore; }
    public void setAverageScore(Double averageScore) { this.averageScore = averageScore; }

    public Integer getTotalAttempts() { return totalAttempts; }
    public void setTotalAttempts(Integer totalAttempts) { this.totalAttempts = totalAttempts; }

    public List<UserProgressDTO> getRecentProgress() { return recentProgress; }
    public void setRecentProgress(List<UserProgressDTO> recentProgress) { this.recentProgress = recentProgress; }
}