package com.example.musicquiz.model;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "user_progress")
public class UserProgress {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    private User user;

    // Keep ALL your existing fields
    private String levelName;
    private Integer score;
    private Integer levelCompleted;

    // Add just these few fields for better tracking
    @Column(name = "best_score")
    private Integer bestScore = 0;

    @Column(name = "attempts_count")
    private Integer attemptsCount = 0;

    @Column(name = "last_attempt_date")
    private LocalDateTime lastAttemptDate;

    // Keep ALL your existing constructors
    public UserProgress() {}

    public UserProgress(User user, String levelName, int score) {
        this.user = user;
        this.levelName = levelName;
        this.score = score;
        this.levelCompleted = 0;
    }

    public UserProgress(User user, String levelName, int score, int levelCompleted) {
        this.user = user;
        this.levelName = levelName;
        this.score = score;
        this.levelCompleted = levelCompleted;
    }

    // Keep ALL your existing getters and setters
    public Long getId() { return id; }

    public User getUser() { return user; }
    public void setUser(User user) { this.user = user; }

    public String getLevelName() { return levelName; }
    public void setLevelName(String levelName) { this.levelName = levelName; }

    public Integer getScore() { return score; }
    public void setScore(Integer score) { this.score = score; }

    public Integer getLevelCompleted() { return levelCompleted; }
    public void setLevelCompleted(Integer levelCompleted) { this.levelCompleted = levelCompleted; }

    // Add getters/setters for new fields only
    public Integer getBestScore() { return bestScore; }
    public void setBestScore(Integer bestScore) { this.bestScore = bestScore; }

    public Integer getAttemptsCount() { return attemptsCount; }
    public void setAttemptsCount(Integer attemptsCount) { this.attemptsCount = attemptsCount; }

    public LocalDateTime getLastAttemptDate() { return lastAttemptDate; }
    public void setLastAttemptDate(LocalDateTime lastAttemptDate) { this.lastAttemptDate = lastAttemptDate; }
}