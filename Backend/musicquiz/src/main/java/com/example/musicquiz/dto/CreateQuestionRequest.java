package com.example.musicquiz.dto;

import com.example.musicquiz.model.Question;
import java.util.List;

public class CreateQuestionRequest {
    private String questionText;
    private String correctAnswer;
    private Integer points;
    private String audioUrl;
    private Question.QuestionType questionType;
    private List<String> options;

    public CreateQuestionRequest() {}

    public CreateQuestionRequest(String questionText, String correctAnswer, Integer points,
                                 String audioUrl, Question.QuestionType questionType, List<String> options) {
        this.questionText = questionText;
        this.correctAnswer = correctAnswer;
        this.points = points;
        this.audioUrl = audioUrl;
        this.questionType = questionType;
        this.options = options;
    }

    // Getters and Setters
    public String getQuestionText() { return questionText; }
    public void setQuestionText(String questionText) { this.questionText = questionText; }

    public String getCorrectAnswer() { return correctAnswer; }
    public void setCorrectAnswer(String correctAnswer) { this.correctAnswer = correctAnswer; }

    public Integer getPoints() { return points; }
    public void setPoints(Integer points) { this.points = points; }

    public String getAudioUrl() { return audioUrl; }
    public void setAudioUrl(String audioUrl) { this.audioUrl = audioUrl; }

    public Question.QuestionType getQuestionType() { return questionType; }
    public void setQuestionType(Question.QuestionType questionType) { this.questionType = questionType; }

    public List<String> getOptions() { return options; }
    public void setOptions(List<String> options) { this.options = options; }
}