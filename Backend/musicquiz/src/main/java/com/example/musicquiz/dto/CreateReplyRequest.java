package com.example.musicquiz.dto;

public class CreateReplyRequest {
    private Long postId;
    private String content;

    // Default constructor
    public CreateReplyRequest() {}

    // Constructor
    public CreateReplyRequest(Long postId, String content) {
        this.postId = postId;
        this.content = content;
    }

    // Getters and Setters
    public Long getPostId() { return postId; }
    public void setPostId(Long postId) { this.postId = postId; }

    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }

    // Manual validation methods
    public boolean isValid() {
        return postId != null &&
                content != null && !content.trim().isEmpty() && content.length() <= 1000;
    }

    public String getValidationError() {
        if (postId == null) return "Post ID is required";
        if (content == null || content.trim().isEmpty()) return "Content is required";
        if (content.length() > 1000) return "Content must be less than 1000 characters";
        return null;
    }
}
