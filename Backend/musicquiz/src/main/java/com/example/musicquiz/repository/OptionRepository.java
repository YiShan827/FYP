package com.example.musicquiz.repository;

import com.example.musicquiz.model.Option;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;
import java.util.Optional;

@Repository
public interface OptionRepository extends JpaRepository<Option, Long> {

    List<Option> findByQuestionId(Long questionId);
    List<Option> findByQuestionIdAndIsCorrect(Long questionId, Boolean isCorrect);
    Optional<Option> findByIdAndIsCorrect(Long id, Boolean isCorrect);
}