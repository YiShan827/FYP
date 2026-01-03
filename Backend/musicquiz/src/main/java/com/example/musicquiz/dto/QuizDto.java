//package com.example.musicquiz.dto;
//
//import com.example.musicquiz.model.Quiz;
//import java.time.LocalDateTime;
//import java.util.List;
//
//public class QuizDto {
//    private Long id;
//    private String title;
//    private String description;
//    private String topic;
//    private String level;
//    private Integer totalQuestions;
//    private Integer timeLimitMinutes;
//    private LocalDateTime createdAt;
//    private Quiz.QuizType quizType;
//    private List<QuestionDto> questions;
//
//    public QuizDto() {}
//
//    public QuizDto(Long id, String title, String description, String topic, String level,
//                   Integer totalQuestions, Integer timeLimitMinutes, LocalDateTime createdAt,
//                   Quiz.QuizType quizType) {
//        this.id = id;
//        this.title = title;
//        this.description = description;
//        this.topic = topic;
//        this.level = level;
//        this.totalQuestions = totalQuestions;
//        this.timeLimitMinutes = timeLimitMinutes;
//        this.createdAt = createdAt;
//        this.quizType = quizType;
//    }
//
//    // Getters and Setters
//    public Long getId() { return id; }
//    public void setId(Long id) { this.id = id; }
//
//    public String getTitle() { return title; }
//    public void setTitle(String title) { this.title = title; }
//
//    public String getDescription() { return description; }
//    public void setDescription(String description) { this.description = description; }
//
//    public String getTopic() { return topic; }
//    public void setTopic(String topic) { this.topic = topic; }
//
//    public String getLevel() { return level; }
//    public void setLevel(String level) { this.level = level; }
//
//    public Integer getTotalQuestions() { return totalQuestions; }
//    public void setTotalQuestions(Integer totalQuestions) { this.totalQuestions = totalQuestions; }
//
//    public Integer getTimeLimitMinutes() { return timeLimitMinutes; }
//    public void setTimeLimitMinutes(Integer timeLimitMinutes) { this.timeLimitMinutes = timeLimitMinutes; }
//
//    public LocalDateTime getCreatedAt() { return createdAt; }
//    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
//
//    public Quiz.QuizType getQuizType() { return quizType; }
//    public void setQuizType(Quiz.QuizType quizType) { this.quizType = quizType; }
//
//    public List<QuestionDto> getQuestions() { return questions; }
//    public void setQuestions(List<QuestionDto> questions) { this.questions = questions; }
//}