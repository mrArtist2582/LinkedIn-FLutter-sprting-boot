package com.example.linkedin.Controller;



import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import com.example.linkedin.Models.CommentsModel;
import com.example.linkedin.Models.PostModel;
import com.example.linkedin.Models.UserModel;
import com.example.linkedin.Repo.CommentRepo;
import com.example.linkedin.Repo.PostRepo;
import com.example.linkedin.Service.CustomUserDetails;

import java.time.LocalDateTime;

@RestController
public class CommentController {
    @Autowired
    private CommentRepo commentRepo;
    @Autowired
    private PostRepo postRepo;

    @PostMapping("/post/{postId}/comments")
    public ResponseEntity<?> addComment(
            @PathVariable Long postId,
            @RequestBody CommentsModel commentsModel,
            @AuthenticationPrincipal CustomUserDetails userDetails) {

        // Get real logged-in user from JWT
        UserModel userModel = userDetails.getUser();

        // Find the post
        PostModel postModel = postRepo.findById(postId)
                .orElseThrow(() -> new RuntimeException("Post not found"));

        // Create new comment
        CommentsModel comment = new CommentsModel();
        comment.setText(commentsModel.getText());
        comment.setPostModel(postModel);
        comment.setUserModel(userModel); // Set current user
        comment.setCreatedAt(LocalDateTime.now()); // If not using @CreationTimestamp

        commentRepo.save(comment);

        return ResponseEntity.ok("Comment added successfully");
    }

}