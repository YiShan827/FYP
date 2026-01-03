package com.example.musicquiz.repository;

import com.example.musicquiz.model.UserAnswer;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface UserAnswerRepository extends JpaRepository<UserAnswer, Long> {

    List<UserAnswer> findByAttemptId(Long attemptId);

    @Query("SELECT ua FROM UserAnswer ua LEFT JOIN FETCH ua.question WHERE ua.attempt.id = :attemptId ORDER BY ua.question.id")
    List<UserAnswer> findByAttemptIdWithQuestion(@Param("attemptId") Long attemptId);

    @Query("SELECT COUNT(ua) FROM UserAnswer ua WHERE ua.attempt.id = :attemptId AND ua.isCorrect = true")
    Integer countCorrectAnswersByAttemptId(@Param("attemptId") Long attemptId);

    @Query("SELECT COUNT(ua) FROM UserAnswer ua WHERE ua.attempt.id = :attemptId AND ua.isCorrect = false")
    Integer countIncorrectAnswersByAttemptId(@Param("attemptId") Long attemptId);

    @Query("SELECT SUM(ua.pointsEarned) FROM UserAnswer ua WHERE ua.attempt.id = :attemptId")
    Integer getTotalPointsEarnedByAttemptId(@Param("attemptId") Long attemptId);

    List<UserAnswer> findByQuestionId(Long questionId);

    @Query("SELECT ua FROM UserAnswer ua WHERE ua.question.id = :questionId AND ua.isCorrect = true")
    List<UserAnswer> findCorrectAnswersByQuestionId(@Param("questionId") Long questionId);

    @Query("SELECT COUNT(ua) FROM UserAnswer ua WHERE ua.question.id = :questionId")
    Integer countAnswersByQuestionId(@Param("questionId") Long questionId);

    @Query("SELECT COUNT(ua) FROM UserAnswer ua WHERE ua.question.id = :questionId AND ua.isCorrect = true")
    Integer countCorrectAnswersByQuestionId(@Param("questionId") Long questionId);
}