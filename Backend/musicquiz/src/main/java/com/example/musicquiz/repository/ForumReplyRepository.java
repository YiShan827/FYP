package com.example.musicquiz.repository;

import com.example.musicquiz.model.ForumReply;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface ForumReplyRepository extends JpaRepository<ForumReply, Long> {

    // Find replies by post, ordered by creation date (oldest first)
    List<ForumReply> findByPostIdOrderByCreatedAtAsc(Long postId);

    // Find replies by user
    List<ForumReply> findByUserIdOrderByCreatedAtDesc(Long userId);

    // Count replies for a post
    long countByPostId(Long postId);
}
