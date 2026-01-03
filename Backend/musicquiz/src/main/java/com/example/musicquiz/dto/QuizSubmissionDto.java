package com.example.musicquiz.dto;

import java.util.List;

public class QuizSubmissionDto {
    private List<UserAnswerDto> answers;
    private Integer timeTakenSeconds;

    // Legacy fields for backward compatibility
    private List<Long> selectedOptionIds;
    private String levelName;

    public QuizSubmissionDto() {}

    public QuizSubmissionDto(List<UserAnswerDto> answers, Integer timeTakenSeconds) {
        this.answers = answers;
        this.timeTakenSeconds = timeTakenSeconds;
    }

    // Legacy constructor
    public QuizSubmissionDto(List<Long> selectedOptionIds, String levelName) {
        this.selectedOptionIds = selectedOptionIds;
        this.levelName = levelName;
    }

    // Getters and Setters
    public List<UserAnswerDto> getAnswers() { return answers; }
    public void setAnswers(List<UserAnswerDto> answers) { this.answers = answers; }

    public Integer getTimeTakenSeconds() { return timeTakenSeconds; }
    public void setTimeTakenSeconds(Integer timeTakenSeconds) { this.timeTakenSeconds = timeTakenSeconds; }

    // Legacy getters and setters
    public List<Long> getSelectedOptionIds() { return selectedOptionIds; }
    public void setSelectedOptionIds(List<Long> selectedOptionIds) { this.selectedOptionIds = selectedOptionIds; }

    public String getLevelName() { return levelName; }
    public void setLevelName(String levelName) { this.levelName = levelName; }
}