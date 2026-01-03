package com.example.musicquiz.dto;

import java.time.LocalDateTime;

public class ForumCategoryDTO {
    private Long id;
    private String name;
    private String description;
    private LocalDateTime createdAt;
    private long postCount;

    // Default constructor
    public ForumCategoryDTO() {}

    // Constructor
    public ForumCategoryDTO(Long id, String name, String description, LocalDateTime createdAt, long postCount) {
        this.id = id;
        this.name = name;
        this.description = description;
        this.createdAt = createdAt;
        this.postCount = postCount;
    }

    // Getters and Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    public long getPostCount() { return postCount; }
    public void setPostCount(long postCount) { this.postCount = postCount; }
}