package com.example.musicquiz.dto;

import com.example.musicquiz.model.Question;
import java.util.List;

public class QuestionDto {
    private Long id;
    private String questionText;
    private Question.QuestionType questionType;
    private String audioUrl;
    private Integer points;
    private List<OptionDto> options;

    public QuestionDto() {}

    public QuestionDto(Long id, String questionText, Question.QuestionType questionType,
                       String audioUrl, Integer points, List<OptionDto> options) {
        this.id = id;
        this.questionText = questionText;
        this.questionType = questionType;
        this.audioUrl = audioUrl;
        this.points = points;
        this.options = options;
    }

    // Getters and Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getQuestionText() { return questionText; }
    public void setQuestionText(String questionText) { this.questionText = questionText; }

    public Question.QuestionType getQuestionType() { return questionType; }
    public void setQuestionType(Question.QuestionType questionType) { this.questionType = questionType; }

    public String getAudioUrl() { return audioUrl; }
    public void setAudioUrl(String audioUrl) { this.audioUrl = audioUrl; }

    public Integer getPoints() { return points; }
    public void setPoints(Integer points) { this.points = points; }

    public List<OptionDto> getOptions() { return options; }
    public void setOptions(List<OptionDto> options) { this.options = options; }
}