package com.example.musicquiz.repository;

import com.example.musicquiz.model.Question;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface QuestionRepository extends JpaRepository<Question, Long> {

    List<Question> findByQuizId(Long quizId);

    @Query("SELECT q FROM Question q LEFT JOIN FETCH q.options WHERE q.quiz.id = :quizId ORDER BY q.id")
    List<Question> findByQuizIdWithOptions(@Param("quizId") Long quizId);

    @Query("SELECT COUNT(q) FROM Question q WHERE q.quiz.id = :quizId")
    Integer countByQuizId(@Param("quizId") Long quizId);

    @Query("SELECT SUM(q.points) FROM Question q WHERE q.quiz.id = :quizId")
    Integer getTotalPointsByQuizId(@Param("quizId") Long quizId);

    List<Question> findByQuestionType(Question.QuestionType questionType);

    @Query("SELECT q FROM Question q WHERE q.audioUrl IS NOT NULL AND q.audioUrl != ''")
    List<Question> findQuestionsWithAudio();

    @Query("SELECT q FROM Question q ORDER BY function('RAND')")
    List<Question> findRandomQuestions(org.springframework.data.domain.Pageable pageable);
}