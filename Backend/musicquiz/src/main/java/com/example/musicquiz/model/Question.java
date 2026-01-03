package com.example.musicquiz.model;

import jakarta.persistence.*;
import java.util.List;

@Entity
@Table(name = "questions")
public class Question {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "quiz_id", nullable = false)
    private Quiz quiz;

    @Column(name = "question_text", columnDefinition = "TEXT", nullable = false)
    private String questionText;

    @Enumerated(EnumType.STRING)
    @Column(name = "question_type")
    private QuestionType questionType = QuestionType.MULTIPLE_CHOICE;

    @Column(name = "audio_url", length = 500)
    private String audioUrl;

    @Column(name = "correct_answer", nullable = false)
    private String correctAnswer;

    private Integer points = 1;

    @OneToMany(mappedBy = "question", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<Option> options;

    public enum QuestionType {
        MULTIPLE_CHOICE, TRUE_FALSE, AUDIO_IDENTIFICATION
    }

    // Constructors
    public Question() {}

    public Question(Quiz quiz, String questionText, String correctAnswer) {
        this.quiz = quiz;
        this.questionText = questionText;
        this.correctAnswer = correctAnswer;
    }

    public Question(Quiz quiz, String questionText, QuestionType questionType,
                    String correctAnswer, Integer points) {
        this.quiz = quiz;
        this.questionText = questionText;
        this.questionType = questionType;
        this.correctAnswer = correctAnswer;
        this.points = points;
    }

    // Getters and Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public Quiz getQuiz() { return quiz; }
    public void setQuiz(Quiz quiz) { this.quiz = quiz; }

    public String getQuestionText() { return questionText; }
    public void setQuestionText(String questionText) { this.questionText = questionText; }

    public QuestionType getQuestionType() { return questionType; }
    public void setQuestionType(QuestionType questionType) { this.questionType = questionType; }

    public String getAudioUrl() { return audioUrl; }
    public void setAudioUrl(String audioUrl) { this.audioUrl = audioUrl; }

    public String getCorrectAnswer() { return correctAnswer; }
    public void setCorrectAnswer(String correctAnswer) { this.correctAnswer = correctAnswer; }

    public Integer getPoints() { return points; }
    public void setPoints(Integer points) { this.points = points; }

    public List<Option> getOptions() { return options; }
    public void setOptions(List<Option> options) { this.options = options; }
}

