package com.example.musicquiz.dto;

public class AnswerReviewDto {
    private Long questionId;
    private String questionText;
    private String userAnswer;
    private String correctAnswer;
    private boolean isCorrect;
    private Integer pointsEarned;
    private Integer pointsPossible;

    public AnswerReviewDto() {}

    public AnswerReviewDto(Long questionId, String questionText, String userAnswer,
                           String correctAnswer, boolean isCorrect, Integer pointsEarned, Integer pointsPossible) {
        this.questionId = questionId;
        this.questionText = questionText;
        this.userAnswer = userAnswer;
        this.correctAnswer = correctAnswer;
        this.isCorrect = isCorrect;
        this.pointsEarned = pointsEarned;
        this.pointsPossible = pointsPossible;
    }

    // Getters and Setters
    public Long getQuestionId() { return questionId; }
    public void setQuestionId(Long questionId) { this.questionId = questionId; }

    public String getQuestionText() { return questionText; }
    public void setQuestionText(String questionText) { this.questionText = questionText; }

    public String getUserAnswer() { return userAnswer; }
    public void setUserAnswer(String userAnswer) { this.userAnswer = userAnswer; }

    public String getCorrectAnswer() { return correctAnswer; }
    public void setCorrectAnswer(String correctAnswer) { this.correctAnswer = correctAnswer; }

    public boolean isCorrect() { return isCorrect; }
    public void setCorrect(boolean correct) { isCorrect = correct; }

    public Integer getPointsEarned() { return pointsEarned; }
    public void setPointsEarned(Integer pointsEarned) { this.pointsEarned = pointsEarned; }

    public Integer getPointsPossible() { return pointsPossible; }
    public void setPointsPossible(Integer pointsPossible) { this.pointsPossible = pointsPossible; }
}
