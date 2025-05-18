package com.example.linkedin.Service;


import jakarta.transaction.Transactional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.linkedin.Models.PostModel;
import com.example.linkedin.Models.UserModel;
import com.example.linkedin.Repo.CommentRepo;
import com.example.linkedin.Repo.PostRepo;

import java.util.List;
import java.util.Optional;

@Service
public class PostService {
    @Autowired
    private PostRepo postRepo;

    @Autowired
    private CommentRepo commentRepo;

    public PostModel addpost(PostModel postModel, UserModel userModel) {
        PostModel savedPost = postRepo.save(postModel);
        return savedPost;
    }

//    public List<PostModel> getallpost(UserModel currentUser) {
//        List<PostModel> userPosts = postRepo.findByUser(currentUser);
//        return userPosts;
//    }

    // If you want to show all posts (not just the user's)
//    public List<PostModel> getAllPostsSorted() {
//        return postRepo.findAllByOrderByCreatedAtDesc();
//    }

    public List<PostModel> getallpost(UserModel currentUser) {
        return postRepo.findByUserOrderByCreateAtDesc(currentUser);
    }


    @Transactional // 🔥 This is necessary for delete operations!
    public boolean deletePostById(Long postId, UserModel currentUser) {
        Optional<PostModel> optionalPost = postRepo.findById(postId);

        if (optionalPost.isPresent()) {
            PostModel post = optionalPost.get();

            if (post.getUser().getId().equals(currentUser.getId())) {

                // Delete related comments (custom method)
                commentRepo.deleteByPostModel(post);  // this is what’s failing without a transaction

                // Delete post
                postRepo.delete(post);

                return true;
            }
        }

        return false;
    }


    public List<PostModel> searchPosts(String keyword) {
        return postRepo.findByTitleContainingIgnoreCaseOrContentContainingIgnoreCase(keyword, keyword);
    }

    public List<PostModel> getAllPostsSortedByDate() {
        return postRepo.findAllByOrderByCreateAtDesc();
    }
}