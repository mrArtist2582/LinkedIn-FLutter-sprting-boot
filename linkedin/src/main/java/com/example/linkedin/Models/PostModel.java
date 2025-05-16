package com.example.linkedin.Models;


import jakarta.persistence.*;
import org.hibernate.annotations.Comment;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "postTable")
public class PostModel {

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "user_id",referencedColumnName = "id")
    private UserModel user;

    private String title;

    private String content;

    private String url;

//    @OneToMany(mappedBy = "post", cascade = CascadeType.ALL, orphanRemoval = true)
//    private List<CommentsModel> comments = new ArrayList<>();

    @CreationTimestamp
    private LocalDateTime createAt;

    @UpdateTimestamp
    private LocalDateTime updateAt;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public UserModel getUser() {
        return user;
    }

    public void setUser(UserModel user) {
        this.user = user;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public LocalDateTime getCreateAt() {
        return createAt;
    }

    public void setCreateAt(LocalDateTime createAt) {
        this.createAt = createAt;
    }

    public LocalDateTime getUpdateAt() {
        return updateAt;
    }

    public void setUpdateAt(LocalDateTime updateAt) {
        this.updateAt = updateAt;
    }

    public String getUrl() {
        return url;
    }

    public void setUrl(String url) {
        this.url = url;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }
}