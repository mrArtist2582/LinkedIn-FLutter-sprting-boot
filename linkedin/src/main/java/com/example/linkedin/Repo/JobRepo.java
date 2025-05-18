package com.example.linkedin.Repo;



import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.example.linkedin.Models.JobModels;

import java.util.List;

@Repository
public interface JobRepo extends JpaRepository<JobModels,Long> {
    List<JobModels> findByTitleContainingIgnoreCaseOrDescriptionContainingIgnoreCase(String keyword, String keyword1);
}