package com.example.musicquiz.dto;

import java.time.LocalDateTime;

public class ForumPostDTO {
    private Long id;
    private Long categoryId;
    private Long userId;
    private String userName;
    private String title;
    private String content;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    private long replyCount;

    // Default constructor
    public ForumPostDTO() {}

    // Constructor
    public ForumPostDTO(Long id, Long categoryId, Long userId, String userName,
                        String title, String content, LocalDateTime createdAt,
                        LocalDateTime updatedAt, long replyCount) {
        this.id = id;
        this.categoryId = categoryId;
        this.userId = userId;
        this.userName = userName;
        this.title = title;
        this.content = content;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
        this.replyCount = replyCount;
    }

    // Getters and Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public Long getCategoryId() { return categoryId; }
    public void setCategoryId(Long categoryId) { this.categoryId = categoryId; }

    public Long getUserId() { return userId; }
    public void setUserId(Long userId) { this.userId = userId; }

    public String getUserName() { return userName; }
    public void setUserName(String userName) { this.userName = userName; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    public LocalDateTime getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt; }

    public long getReplyCount() { return replyCount; }
    public void setReplyCount(long replyCount) { this.replyCount = replyCount; }
}