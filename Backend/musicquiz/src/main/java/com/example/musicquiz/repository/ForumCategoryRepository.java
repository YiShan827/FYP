package com.example.musicquiz.repository;

import com.example.musicquiz.model.ForumCategory;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface ForumCategoryRepository extends JpaRepository<ForumCategory, Long> {

    // Find all categories ordered by name
    List<ForumCategory> findAllByOrderByName();

    // Custom query to get categories with post count
    @Query("SELECT c, COUNT(p) as postCount " +
            "FROM ForumCategory c LEFT JOIN ForumPost p ON c.id = p.categoryId " +
            "GROUP BY c.id " +
            "ORDER BY c.name")
    List<Object[]> findCategoriesWithPostCount();
}
