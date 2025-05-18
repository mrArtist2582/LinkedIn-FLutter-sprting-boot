package com.example.linkedin.Controller;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import com.example.linkedin.Models.JobModels;
import com.example.linkedin.Service.JobService;

import java.util.List;

@RestController
@CrossOrigin("*")
@RequestMapping("/job")
public class JobController {
     @Autowired
    private JobService jobService;

     @GetMapping("/get")
     public ResponseEntity<List<JobModels>> getalljob(){
         List<JobModels> jobModels=jobService.getalljob();
         return new ResponseEntity<>(jobModels, HttpStatus.OK);
     }

    @PostMapping("/post")
    public ResponseEntity<JobModels> postdata(@RequestBody JobModels jobModels){
        JobModels job1=jobService.postdata(jobModels);
        return new ResponseEntity<>(job1, HttpStatus.OK);
    }

}