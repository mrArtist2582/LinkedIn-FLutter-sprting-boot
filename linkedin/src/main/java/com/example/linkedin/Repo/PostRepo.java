package com.example.linkedin.Repo;


import org.springframework.data.jpa.repository.JpaRepository;

import com.example.linkedin.Models.PostModel;
import com.example.linkedin.Models.UserModel;
import java.util.List;

public interface PostRepo extends JpaRepository<PostModel,Long> {

   //    Optional<PostModel> findById(Long id);

    List<PostModel> findByUser(UserModel currentUser);

    List<PostModel> findByTitleContainingIgnoreCaseOrContentContainingIgnoreCase(String keyword, String keyword1);
}