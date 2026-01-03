package com.example.musicquiz.dto;

import java.time.LocalDateTime;
import java.math.BigDecimal;
import java.util.List;

public class QuizResultDto {
    private Long attemptId;
    private String quizTitle;
    private Integer score;
    private Integer totalPossibleScore;
    private BigDecimal percentageScore;
    private Integer timeTakenSeconds;
    private LocalDateTime completedAt;
    private List<AnswerReviewDto> answerReviews;
    private boolean isNewBestScore;

    public QuizResultDto() {}

    public QuizResultDto(Long attemptId, String quizTitle, Integer score, Integer totalPossibleScore,
                         BigDecimal percentageScore, Integer timeTakenSeconds, LocalDateTime completedAt,
                         List<AnswerReviewDto> answerReviews, boolean isNewBestScore) {
        this.attemptId = attemptId;
        this.quizTitle = quizTitle;
        this.score = score;
        this.totalPossibleScore = totalPossibleScore;
        this.percentageScore = percentageScore;
        this.timeTakenSeconds = timeTakenSeconds;
        this.completedAt = completedAt;
        this.answerReviews = answerReviews;
        this.isNewBestScore = isNewBestScore;
    }

    // Getters and Setters
    public Long getAttemptId() { return attemptId; }
    public void setAttemptId(Long attemptId) { this.attemptId = attemptId; }

    public String getQuizTitle() { return quizTitle; }
    public void setQuizTitle(String quizTitle) { this.quizTitle = quizTitle; }

    public Integer getScore() { return score; }
    public void setScore(Integer score) { this.score = score; }

    public Integer getTotalPossibleScore() { return totalPossibleScore; }
    public void setTotalPossibleScore(Integer totalPossibleScore) { this.totalPossibleScore = totalPossibleScore; }

    public BigDecimal getPercentageScore() { return percentageScore; }
    public void setPercentageScore(BigDecimal percentageScore) { this.percentageScore = percentageScore; }

    public Integer getTimeTakenSeconds() { return timeTakenSeconds; }
    public void setTimeTakenSeconds(Integer timeTakenSeconds) { this.timeTakenSeconds = timeTakenSeconds; }

    public LocalDateTime getCompletedAt() { return completedAt; }
    public void setCompletedAt(LocalDateTime completedAt) { this.completedAt = completedAt; }

    public List<AnswerReviewDto> getAnswerReviews() { return answerReviews; }
    public void setAnswerReviews(List<AnswerReviewDto> answerReviews) { this.answerReviews = answerReviews; }

    public boolean isNewBestScore() { return isNewBestScore; }
    public void setNewBestScore(boolean newBestScore) { isNewBestScore = newBestScore; }
}