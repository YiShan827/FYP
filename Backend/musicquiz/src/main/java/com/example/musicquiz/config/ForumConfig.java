package com.example.musicquiz.config;

import com.example.musicquiz.service.ForumService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class ForumConfig {

    @Autowired
    private ForumService forumService;

    /**
     * Initialize default forum categories on application startup
     */
    @Bean
    public CommandLineRunner initializeForumData() {
        return args -> {
            // Initialize default categories if none exist
            forumService.initializeDefaultCategories();
            System.out.println("Forum initialization completed");
        };
    }
}
