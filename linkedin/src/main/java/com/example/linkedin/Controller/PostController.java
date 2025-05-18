package com.example.linkedin.Controller;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

import com.example.linkedin.Models.JobModels;
import com.example.linkedin.Models.PostModel;
import com.example.linkedin.Models.UserModel;
import com.example.linkedin.Repo.JobRepo;
import com.example.linkedin.Repo.PostRepo;
import com.example.linkedin.Service.CommentsService;
import com.example.linkedin.Service.CustomUserDetails;
import com.example.linkedin.Service.PostService;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/jobpost")
public class PostController {

    @Autowired
    private PostService postService;
    @Autowired
    private PostRepo postRepo;
    @Autowired
    private JobRepo jobRepo;

    @Autowired
    private CommentsService commentsService;

    @PostMapping("/post")
    public ResponseEntity<?> addPost(@RequestBody PostModel postModel,
                                     @AuthenticationPrincipal CustomUserDetails userDetails) {

        UserModel user = userDetails.getUser(); // ✅ real user object

        postModel.setUser(user);
        PostModel savedPost = postService.addpost(postModel, user);
        return ResponseEntity.ok(savedPost);
    }

    @GetMapping("/get")
    public ResponseEntity<List<PostModel>> getUserPosts(@AuthenticationPrincipal CustomUserDetails userDetails) {
        UserModel currentUser = userDetails.getUser();
     List<PostModel> userPosts =postService.getallpost(currentUser);
     if (userPosts==null || userPosts.isEmpty()){
         return ResponseEntity.notFound().build();
     }
        return ResponseEntity.ok(userPosts);
    }

    @GetMapping("/all")
    public ResponseEntity<List<PostModel>> getAllPosts() {
        List<PostModel> allPosts = postService.getAllPostsSortedByDate();
        return ResponseEntity.ok(allPosts);
    }

    @PutMapping("/update/{postId}")
    public ResponseEntity<?> updatePost(
            @PathVariable Long postId,
            @RequestBody PostModel updatedPost,
            @AuthenticationPrincipal CustomUserDetails userDetails) {

        UserModel currentUser = userDetails.getUser();

        // Fetch the existing post
        PostModel existingPost = postRepo.findById(postId)
                .orElseThrow(() -> new RuntimeException("Post not found"));

        // Check if the current user is the owner of the post
        if (!existingPost.getUser().getId().equals(currentUser.getId())) {
            return ResponseEntity.status(403).body("You are not authorized to update this post");
        }

        // Update the content (and other fields if needed)
        existingPost.setContent(updatedPost.getContent());
        existingPost.setUrl(updatedPost.getUrl());

        // Save updated post
        PostModel savedPost = postRepo.save(existingPost);

        return ResponseEntity.ok(savedPost);
    }

    @DeleteMapping("/delete/{postId}")
    public ResponseEntity<?> deletePost(@PathVariable Long postId, @AuthenticationPrincipal CustomUserDetails userDetails) {
        UserModel currentUser = userDetails.getUser();

        boolean deleted = postService.deletePostById(postId, currentUser);
        if (deleted) {
            return ResponseEntity.ok("Post deleted successfully");
        } else {
            return ResponseEntity.status(403).body("You are not authorized to delete this post or post not found");
        }
    }

//    @GetMapping("/search")
//    public ResponseEntity<List<PostModel>> searchPosts(@RequestParam String keyword) {
//        return ResponseEntity.ok(postService.searchPosts(keyword));
//    }

    @GetMapping("/search")
    public Map<String, Object> searchPostsAndJobs(@RequestParam String keyword) {
        List<PostModel> postResults;
        if (keyword.startsWith("@")) {
            String username = keyword.substring(1);
            postResults = postRepo.findByUser_UsernameContainingIgnoreCase(username);
        } else {
            postResults = postRepo.findByTitleContainingIgnoreCaseOrContentContainingIgnoreCase(keyword, keyword);
        }

        List<JobModels> jobResults = jobRepo.findByTitleContainingIgnoreCaseOrDescriptionContainingIgnoreCase(keyword, keyword);

        Map<String, Object> response = new HashMap<>();
        response.put("posts", postResults);
        response.put("jobs", jobResults);
        return response;
    }


}