package Linkedin.com.example.demo.repository;


import org.springframework.data.jpa.repository.JpaRepository;

import Linkedin.com.example.demo.Models.PostModel;

public interface PostRepo extends JpaRepository<PostModel,Long> {
}