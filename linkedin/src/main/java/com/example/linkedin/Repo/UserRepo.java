package com.example.linkedin.Repo;


import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.example.linkedin.Models.UserModel;

import java.util.List;
import java.util.Optional;

@Repository
public interface UserRepo extends JpaRepository<UserModel,Long> {
    Optional<UserModel> findByEmail(String email);

    Optional<UserModel> findByUsername(String username);

    List<UserModel> findByUsernameContainingIgnoreCase(String username);
}