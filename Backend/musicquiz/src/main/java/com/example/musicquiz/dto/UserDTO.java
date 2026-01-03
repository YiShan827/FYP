package com.example.musicquiz.dto;

public class UserDTO {
    private Long id;
    private String email;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    private String role;

    public UserDTO(Long id, String email, String role) {
        this.id = id;
        this.email = email;
        this.role = role;
    }
}
