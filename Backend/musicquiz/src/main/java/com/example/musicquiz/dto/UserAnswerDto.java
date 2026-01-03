package com.example.musicquiz.dto;

public class UserAnswerDto {
    private Long questionId;
    private String selectedAnswer;

    public UserAnswerDto() {}

    public UserAnswerDto(Long questionId, String selectedAnswer) {
        this.questionId = questionId;
        this.selectedAnswer = selectedAnswer;
    }

    public Long getQuestionId() { return questionId; }
    public void setQuestionId(Long questionId) { this.questionId = questionId; }

    public String getSelectedAnswer() { return selectedAnswer; }
    public void setSelectedAnswer(String selectedAnswer) { this.selectedAnswer = selectedAnswer; }
}

