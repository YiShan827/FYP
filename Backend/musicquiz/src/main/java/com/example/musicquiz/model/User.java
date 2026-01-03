package com.example.musicquiz.model;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonProperty;
import jakarta.persistence.*;
import org.hibernate.annotations.CreationTimestamp;
import com.example.musicquiz.model.Role;
import java.time.LocalDateTime;

@Entity
@Table(name = "`user`")
public class User {

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private Role role;

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    @Column(name = "full_name", nullable = false)
    private String fullName;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String email;

    // Use JsonProperty for input and JsonIgnore for output
    @JsonProperty(access = JsonProperty.Access.WRITE_ONLY)
    private String password;

    // Constructors
    public User() {}

    public User(String email, String password) {
        this.email = email;
        this.password = password;
    }

    // Getters & Setters
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

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    @Override
    public String toString() {
        return "User{" +
                "id=" + id +
                ", email='" + email + '\'' +
                ", password='[PROTECTED]'" +
                '}';
    }
    @Column(unique = true)
    private String username;


    @CreationTimestamp
    private LocalDateTime createdAt;

    public Role getRole() {
        return role;
    }

    public void setRole(Role role) {
        this.role = role;
    }
}