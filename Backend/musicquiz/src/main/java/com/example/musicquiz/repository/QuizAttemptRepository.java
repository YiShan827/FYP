package com.example.musicquiz.repository;

import com.example.musicquiz.model.QuizAttempt;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface QuizAttemptRepository extends JpaRepository<QuizAttempt, Long> {

    List<QuizAttempt> findByUserIdOrderByCompletedAtDesc(Long userId);

    List<QuizAttempt> findByUserIdAndQuizId(Long userId, Long quizId);

    @Query("SELECT COUNT(qa) FROM QuizAttempt qa WHERE qa.userId = :userId AND qa.score = 1")
    Integer countCorrectAnswersByUserId(@Param("userId") Long userId);

    @Query("SELECT COUNT(qa) FROM QuizAttempt qa WHERE qa.userId = :userId")
    Integer countTotalAttemptsByUserId(@Param("userId") Long userId);
}