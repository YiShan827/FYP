package com.example.musicquiz.controller;

import com.example.musicquiz.model.Announcement;
import com.example.musicquiz.repository.AnnouncementRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/announcements")
@CrossOrigin("*")
public class AnnouncementController {
    @Autowired
    private final AnnouncementRepository repo;

    public AnnouncementController(AnnouncementRepository repo) {
        this.repo = repo;
    }

    @PostMapping
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<?> createAnnouncement(@RequestBody Announcement ann) {
        // ✅ Manual validation
        if (ann.getTitle() == null || ann.getTitle().trim().isEmpty()) {
            return ResponseEntity.badRequest().body("Title is required.");
        }
        if (ann.getMessage() == null || ann.getMessage().trim().isEmpty()) {
            return ResponseEntity.badRequest().body("Message is required.");
        }

        return ResponseEntity.ok(repo.save(ann));
    }

    @GetMapping
    public ResponseEntity<List<Announcement>> getAll() {
        return ResponseEntity.ok(repo.findAllByOrderByCreatedAtDesc());
    }

    @DeleteMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<?> deleteAnnouncement(@PathVariable Long id) {
        if (!repo.existsById(id)) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("Announcement not found");
        }

        repo.deleteById(id);
        return ResponseEntity.ok("Announcement deleted successfully");
    }
}
