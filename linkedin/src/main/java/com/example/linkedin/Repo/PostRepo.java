package com.example.linkedin.Repo;


import org.springframework.data.jpa.repository.JpaRepository;

import com.example.linkedin.Models.PostModel;
import com.example.linkedin.Models.UserModel;

import java.util.List;
import java.util.Objects;
import java.util.Optional;

public interface PostRepo extends JpaRepository<PostModel,Long> {

    Optional<PostModel> findById(Long id);

    List<PostModel> findByUser(UserModel currentUser);

    List<PostModel> findByTitleContainingIgnoreCaseOrContentContainingIgnoreCase(String keyword, String keyword1);

    List<PostModel> findByUserOrderByCreateAtDesc(UserModel user);

    // Or fetch all posts ordered by createdAt descending (if you want all users' posts)
    List<PostModel> findAllByOrderByCreateAtDesc();

    List<PostModel> findByUser_UsernameContainingIgnoreCase(String username);


}