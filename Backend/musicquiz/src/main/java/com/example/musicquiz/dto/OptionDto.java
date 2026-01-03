package com.example.musicquiz.dto;

public class OptionDto {
    private Long id;
    private String text;

    public OptionDto() {}

    public OptionDto(Long id, String text) {
        this.id = id;
        this.text = text;
    }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getText() { return text; }
    public void setText(String text) { this.text = text; }
}