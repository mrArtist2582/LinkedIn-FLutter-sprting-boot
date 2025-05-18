package com.example.linkedin.Repo;

import jakarta.transaction.Transactional;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.example.linkedin.Models.CommentsModel;
import com.example.linkedin.Models.PostModel;

import java.util.List;

@Repository
public interface CommentRepo extends JpaRepository<CommentsModel, Long> {
    List<CommentsModel> findByPostModel(PostModel postModel);

    List<CommentsModel> findByPostModel_Id(Long postId);

    @Transactional
    void deleteByPostModel(PostModel postModel);
}