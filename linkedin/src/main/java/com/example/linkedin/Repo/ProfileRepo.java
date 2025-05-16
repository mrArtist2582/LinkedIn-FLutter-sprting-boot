package com.example.linkedin.Repo;


import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.example.linkedin.Models.ProfileModel;
import com.example.linkedin.Models.UserModel;

import java.util.Optional;

@Repository
public interface ProfileRepo extends JpaRepository<ProfileModel,Long> {

    Optional<ProfileModel> findByUser(UserModel userModel);
}