package com.example.musicquiz.dto;

import java.util.List;

public class CreateQuizRequest {
    private String title;
    private String description;
    private String topic;
    private String level;
    private Integer timeLimitMinutes;
    private List<CreateQuestionRequest> questions;

    public CreateQuizRequest() {}

    public CreateQuizRequest(String title, String description, String topic, String level,
                             Integer timeLimitMinutes, List<CreateQuestionRequest> questions) {
        this.title = title;
        this.description = description;
        this.topic = topic;
        this.level = level;
        this.timeLimitMinutes = timeLimitMinutes;
        this.questions = questions;
    }

    // Getters and Setters
    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getTopic() { return topic; }
    public void setTopic(String topic) { this.topic = topic; }

    public String getLevel() { return level; }
    public void setLevel(String level) { this.level = level; }

    public Integer getTimeLimitMinutes() { return timeLimitMinutes; }
    public void setTimeLimitMinutes(Integer timeLimitMinutes) { this.timeLimitMinutes = timeLimitMinutes; }

    public List<CreateQuestionRequest> getQuestions() { return questions; }
    public void setQuestions(List<CreateQuestionRequest> questions) { this.questions = questions; }
}