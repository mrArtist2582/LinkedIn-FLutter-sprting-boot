package Linkedin.com.example.demo.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import Linkedin.com.example.demo.Models.UserModel;

import java.util.Optional;

@Repository
public interface UserRepo extends JpaRepository<UserModel,Long> {
    Optional<UserModel> findByEmail(String email);

    Optional<UserModel> findByUsername(String username);
}