package com.example.linkedin.Service;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.linkedin.Repo.CommentRepo;

@Service
public class CommentsService {
    @SuppressWarnings("unused")
    @Autowired
    private CommentRepo repo;

//    public List<CommentsModel> getCommentsByPostId(Long postId) {
//        return repo.findByPostModel_Id(postId);
//    }
}