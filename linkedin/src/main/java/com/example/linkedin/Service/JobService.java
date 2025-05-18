package com.example.linkedin.Service;



import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.linkedin.Models.JobModels;
import com.example.linkedin.Repo.JobRepo;

import java.util.List;

@Service
public class JobService {
    @Autowired
    private JobRepo jobRepo;


    public List<JobModels> getalljob() {
        List<JobModels> jobModels=jobRepo.findAll();
        return jobModels;
    }


    public JobModels postdata(JobModels jobModels) {
        return jobRepo.save(jobModels);
    }
}