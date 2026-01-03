// service/ForumService.java
package com.example.musicquiz.service;

import com.example.musicquiz.dto.*;
import com.example.musicquiz.model.*;
import com.example.musicquiz.repository.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;
import java.util.Map;
import java.util.HashMap;

@Service
@Transactional
public class ForumService {

    @Autowired
    private ForumCategoryRepository categoryRepository;

    @Autowired
    private ForumPostRepository postRepository;

    @Autowired
    private ForumReplyRepository replyRepository;

    @Autowired
    private UserRepository userRepository; // Assuming you have this

    // =============== CATEGORY OPERATIONS ===============

    public List<ForumCategoryDTO> getAllCategories() {
        List<Object[]> results = categoryRepository.findCategoriesWithPostCount();
        return results.stream()
                .map(result -> {
                    ForumCategory category = (ForumCategory) result[0];
                    Long postCount = (Long) result[1];
                    return new ForumCategoryDTO(
                            category.getId(),
                            category.getName(),
                            category.getDescription(),
                            category.getCreatedAt(),
                            postCount != null ? postCount : 0
                    );
                })
                .collect(Collectors.toList());
    }

    public Optional<ForumCategory> getCategoryById(Long id) {
        return categoryRepository.findById(id);
    }

    // =============== POST OPERATIONS ===============

    public List<ForumPostDTO> getPostsByCategory(Long categoryId) {
        List<Object[]> results = postRepository.findPostsWithReplyCount(categoryId);
        return results.stream()
                .map(result -> {
                    ForumPost post = (ForumPost) result[0];
                    Long replyCount = (Long) result[1];

                    // Get user name
                    String userName = getUserName(post.getUserId());

                    return new ForumPostDTO(
                            post.getId(),
                            post.getCategoryId(),
                            post.getUserId(),
                            userName,
                            post.getTitle(),
                            post.getContent(),
                            post.getCreatedAt(),
                            post.getUpdatedAt(),
                            replyCount != null ? replyCount : 0
                    );
                })
                .collect(Collectors.toList());
    }

    public Optional<ForumPostDTO> getPostById(Long id) {
        Optional<ForumPost> postOpt = postRepository.findById(id);
        if (postOpt.isPresent()) {
            ForumPost post = postOpt.get();
            String userName = getUserName(post.getUserId());
            long replyCount = replyRepository.countByPostId(post.getId());

            return Optional.of(new ForumPostDTO(
                    post.getId(),
                    post.getCategoryId(),
                    post.getUserId(),
                    userName,
                    post.getTitle(),
                    post.getContent(),
                    post.getCreatedAt(),
                    post.getUpdatedAt(),
                    replyCount
            ));
        }
        return Optional.empty();
    }

    public ForumPostDTO createPost(CreatePostRequest request, Long userId) {
        // Validate category exists
        if (!categoryRepository.existsById(request.getCategoryId())) {
            throw new RuntimeException("Category not found");
        }

        ForumPost post = new ForumPost(
                request.getCategoryId(),
                userId,
                request.getTitle(),
                request.getContent()
        );

        ForumPost savedPost = postRepository.save(post);
        String userName = getUserName(userId);

        return new ForumPostDTO(
                savedPost.getId(),
                savedPost.getCategoryId(),
                savedPost.getUserId(),
                userName,
                savedPost.getTitle(),
                savedPost.getContent(),
                savedPost.getCreatedAt(),
                savedPost.getUpdatedAt(),
                0 // New post has 0 replies
        );
    }

    public List<ForumPostDTO> searchPosts(String query) {
        List<ForumPost> posts = postRepository.searchPosts(query);
        return posts.stream()
                .map(post -> {
                    String userName = getUserName(post.getUserId());
                    long replyCount = replyRepository.countByPostId(post.getId());

                    return new ForumPostDTO(
                            post.getId(),
                            post.getCategoryId(),
                            post.getUserId(),
                            userName,
                            post.getTitle(),
                            post.getContent(),
                            post.getCreatedAt(),
                            post.getUpdatedAt(),
                            replyCount
                    );
                })
                .collect(Collectors.toList());
    }

    // =============== REPLY OPERATIONS ===============

    public List<ForumReplyDTO> getRepliesByPost(Long postId) {
        List<ForumReply> replies = replyRepository.findByPostIdOrderByCreatedAtAsc(postId);
        return replies.stream()
                .map(reply -> {
                    String userName = getUserName(reply.getUserId());
                    return new ForumReplyDTO(
                            reply.getId(),
                            reply.getPostId(),
                            reply.getUserId(),
                            userName,
                            reply.getContent(),
                            reply.getCreatedAt(),
                            reply.getUpdatedAt()
                    );
                })
                .collect(Collectors.toList());
    }

    public ForumReplyDTO createReply(CreateReplyRequest request, Long userId) {
        // Validate post exists
        if (!postRepository.existsById(request.getPostId())) {
            throw new RuntimeException("Post not found");
        }

        ForumReply reply = new ForumReply(
                request.getPostId(),
                userId,
                request.getContent()
        );

        ForumReply savedReply = replyRepository.save(reply);
        String userName = getUserName(userId);

        return new ForumReplyDTO(
                savedReply.getId(),
                savedReply.getPostId(),
                savedReply.getUserId(),
                userName,
                savedReply.getContent(),
                savedReply.getCreatedAt(),
                savedReply.getUpdatedAt()
        );
    }

    // =============== COMBINED OPERATIONS ===============

    public Map<String, Object> getPostWithReplies(Long postId) {
        Map<String, Object> result = new HashMap<>();

        Optional<ForumPostDTO> postOpt = getPostById(postId);
        if (postOpt.isEmpty()) {
            throw new RuntimeException("Post not found");
        }

        List<ForumReplyDTO> replies = getRepliesByPost(postId);

        result.put("post", postOpt.get());
        result.put("replies", replies);

        return result;
    }

    // =============== HELPER METHODS ===============

    private String getUserName(Long userId) {
        // This assumes you have a User entity with username field
        // Adjust based on your actual User entity structure
        return userRepository.findById(userId)
                .map(user -> user.getFullName())
                .orElse("Unknown User");
    }

    // =============== ADMIN/SETUP OPERATIONS ===============

    public void initializeDefaultCategories() {
        if (categoryRepository.count() == 0) {
            ForumCategory quizDiscussions = new ForumCategory(
                    "Quiz Discussions",
                    "Discuss quiz concepts and music theory"
            );
            ForumCategory generalChat = new ForumCategory(
                    "General Chat",
                    "General music composition discussions"
            );

            categoryRepository.save(quizDiscussions);
            categoryRepository.save(generalChat);
        }
    }
}