package com.example.musicquiz.service;

import com.example.musicquiz.model.User;
import com.example.musicquiz.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import com.example.musicquiz.model.Role;

import java.util.Optional;

@Service
public class UserService {

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;

    @Autowired
    public UserService(UserRepository userRepository, PasswordEncoder passwordEncoder) {
        this.userRepository = userRepository;
        this.passwordEncoder = passwordEncoder;
    }

    public Optional<User> findByEmail(String email) {
        return userRepository.findByEmail(email);
    }

    public User registerUser(User user) {
        if (user.getFullName() == null || user.getFullName().isBlank()) {
            throw new IllegalArgumentException("Full name is required");
        }
        user.setPassword(passwordEncoder.encode(user.getPassword()));
        if (user.getRole() == null) {
            user.setRole(Role.USER);
        }
        return userRepository.save(user);
    }

//    public boolean resetPassword(String email, String newPassword) {
//        Optional<User> optionalUser = userRepository.findByEmail(email);
//        if (optionalUser.isPresent()) {
//            User user = optionalUser.get();
//            user.setPassword(passwordEncoder.encode(newPassword));
//            userRepository.save(user);
//            return true;
//        }
//        return false;
//    }

    public boolean checkUserExistsByEmail(String email) {
        return userRepository.findByEmail(email).isPresent();
    }

    public boolean resetPassword(String email, String newPassword) {
        Optional<User> userOpt = userRepository.findByEmail(email);
        if (userOpt.isEmpty()) return false;

        User user = userOpt.get();
        user.setPassword(passwordEncoder.encode(newPassword));
        userRepository.save(user);
        return true;
    }



}