package com.example.linkedin.Models;

import jakarta.persistence.*;

import java.time.LocalDateTime;

@Entity
@Table(name = "Comments")
public class CommentsModel {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private  Long id;

    private String text;

    @ManyToOne
    private UserModel userModel;

    @ManyToOne
    @JoinColumn(name = "post_id",referencedColumnName = "id")
    private PostModel postModel;

    private LocalDateTime createdAt;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getText() {
        return text;
    }

    public void setText(String text) {
        this.text = text;
    }

    public UserModel getUserModel() {
        return userModel;
    }

    public void setUserModel(UserModel userModel) {
        this.userModel = userModel;
    }

    public PostModel getPostModel() {
        return postModel;
    }

    public void setPostModel(PostModel postModel) {
        this.postModel = postModel;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }
}