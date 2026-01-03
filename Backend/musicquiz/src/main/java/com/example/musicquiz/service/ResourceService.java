package com.example.musicquiz.service;

import com.example.musicquiz.model.Resource;
import com.example.musicquiz.repository.ResourceRepository;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;

@Service
public class ResourceService {

    private final ResourceRepository repository;

    public ResourceService(ResourceRepository repository) {
        this.repository = repository;
    }

    public Resource uploadResource(Resource resource, String uploadedBy) {
        resource.setUploadedBy(uploadedBy);
        resource.setUploadDate(LocalDateTime.now());
        return repository.save(resource);
    }

    public List<Resource> getAllResources() {
        return repository.findAll();
    }

    public void deleteResource(Long id) {
        repository.deleteById(id);
    }
}
