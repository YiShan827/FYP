package com.example.musicquiz.dto;

public class CreatePostRequest {
    private Long categoryId;
    private String title;
    private String content;

    // Default constructor
    public CreatePostRequest() {}

    // Constructor
    public CreatePostRequest(Long categoryId, String title, String content) {
        this.categoryId = categoryId;
        this.title = title;
        this.content = content;
    }

    // Getters and Setters
    public Long getCategoryId() { return categoryId; }
    public void setCategoryId(Long categoryId) { this.categoryId = categoryId; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }

    // Manual validation methods
    public boolean isValid() {
        return categoryId != null &&
                title != null && !title.trim().isEmpty() && title.length() <= 200 &&
                content != null && !content.trim().isEmpty() && content.length() <= 5000;
    }

    public String getValidationError() {
        if (categoryId == null) return "Category ID is required";
        if (title == null || title.trim().isEmpty()) return "Title is required";
        if (title.length() > 200) return "Title must be less than 200 characters";
        if (content == null || content.trim().isEmpty()) return "Content is required";
        if (content.length() > 5000) return "Content must be less than 5000 characters";
        return null;
    }
}
