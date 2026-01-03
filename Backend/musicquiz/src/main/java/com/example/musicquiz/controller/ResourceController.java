package com.example.musicquiz.controller;

import com.example.musicquiz.model.Resource;
import com.example.musicquiz.repository.ResourceRepository;
import com.example.musicquiz.security.JwtUtil;
import com.example.musicquiz.service.ResourceService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@CrossOrigin(origins = "*")
@RestController
@RequestMapping("/api/resources")
public class ResourceController {

    private final ResourceService service;
    private final JwtUtil jwtUtil;
    private final ResourceRepository resourceRepository;

    public ResourceController(ResourceRepository resourceRepository, ResourceService service, JwtUtil jwtUtil) {
        this.resourceRepository = resourceRepository;
        this.service = service;
        this.jwtUtil = jwtUtil;
    }

    @PostMapping("/upload")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<?> uploadResource(@RequestBody Resource resource,
                                            @RequestHeader("Authorization") String authHeader) {
        // ✅ Manual validation
        if (resource.getTitle() == null || resource.getTitle().trim().isEmpty()) {
            return ResponseEntity.badRequest().body("Title is required.");
        }
        if (resource.getDescription() == null || resource.getDescription().trim().isEmpty()) {
            return ResponseEntity.badRequest().body("Description is required.");
        }
        if (resource.getUrl() == null || resource.getUrl().trim().isEmpty()) {
            return ResponseEntity.badRequest().body("URL is required.");
        }
        if (resource.getTopic() == null || resource.getTopic().trim().isEmpty()) {
            return ResponseEntity.badRequest().body("Topic is required.");
        }

        // ✅ Extract email from JWT token
        String token = authHeader.substring(7);
        String email = jwtUtil.extractUsername(token);

        // ✅ Save resource
        Resource saved = service.uploadResource(resource, email);
        return ResponseEntity.ok(saved);
    }

    @GetMapping("/resources")
    public ResponseEntity<List<Map<String, Object>>> getGroupedResources() {
        List<Resource> allResources = resourceRepository.findAll();

        // Group by topic safely (use "Unknown" for null topics)
        Map<String, List<Resource>> grouped = allResources.stream()
                .collect(Collectors.groupingBy(res -> {
                    String topic = res.getTopic();
                    return topic != null ? topic : "Unknown";
                }));

        // Convert to desired JSON format
        List<Map<String, Object>> response = new ArrayList<>();
        for (Map.Entry<String, List<Resource>> entry : grouped.entrySet()) {
            Map<String, Object> topicGroup = new HashMap<>();
            topicGroup.put("topic", entry.getKey());

            List<Map<String, Object>> resources = entry.getValue().stream().map(res -> {
                Map<String, Object> r = new HashMap<>();
                r.put("id", res.getId());
                r.put("title", res.getTitle());
                r.put("description", res.getDescription());
                r.put("url", res.getUrl());
                return r;
            }).collect(Collectors.toList());

            topicGroup.put("resources", resources);
            response.add(topicGroup);
        }

        return ResponseEntity.ok(response);
    }

    @DeleteMapping("/resources/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<?> deleteResource(@PathVariable Long id) {
        if (!resourceRepository.existsById(id)) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("Resource not found.");
        }

        resourceRepository.deleteById(id);
        return ResponseEntity.ok("Resource deleted successfully.");
    }
}
