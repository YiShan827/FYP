package com.example.musicquiz.repository;

import com.example.musicquiz.model.ForumPost;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface ForumPostRepository extends JpaRepository<ForumPost, Long> {

    // Find posts by category, ordered by creation date (newest first)
    List<ForumPost> findByCategoryIdOrderByCreatedAtDesc(Long categoryId);

    // Find posts by user
    List<ForumPost> findByUserIdOrderByCreatedAtDesc(Long userId);

    // Search posts by title or content
    @Query("SELECT p FROM ForumPost p WHERE " +
            "LOWER(p.title) LIKE LOWER(CONCAT('%', :query, '%')) OR " +
            "LOWER(p.content) LIKE LOWER(CONCAT('%', :query, '%')) " +
            "ORDER BY p.createdAt DESC")
    List<ForumPost> searchPosts(@Param("query") String query);

    // Get posts with reply count
    @Query("SELECT p, COUNT(r) as replyCount " +
            "FROM ForumPost p LEFT JOIN ForumReply r ON p.id = r.postId " +
            "WHERE p.categoryId = :categoryId " +
            "GROUP BY p.id " +
            "ORDER BY p.createdAt DESC")
    List<Object[]> findPostsWithReplyCount(@Param("categoryId") Long categoryId);

    // Count posts in category
    long countByCategoryId(Long categoryId);
}
