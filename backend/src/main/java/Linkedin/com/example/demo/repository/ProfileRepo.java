package Linkedin.com.example.demo.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import Linkedin.com.example.demo.Models.ProfileModel;
import Linkedin.com.example.demo.Models.UserModel;

import java.util.Optional;

@Repository
public interface ProfileRepo extends JpaRepository<ProfileModel,Long> {

    Optional<ProfileModel> findByUser(UserModel userModel);
}