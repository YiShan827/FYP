package com.example.musicquiz.repository;

import com.example.musicquiz.model.Quiz;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface QuizRepository extends JpaRepository<Quiz, Long> {
    List<Quiz> findByTopicAndLevel(String topic, String level);
    List<Quiz> findByLevel(String level);

    @Query("SELECT DISTINCT q.topic FROM Quiz q WHERE q.level = :level")
    List<String> findDistinctTopicsByLevel(@Param("level") String level);
}