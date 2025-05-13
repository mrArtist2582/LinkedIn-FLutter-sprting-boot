package Linkedin.com.example.demo.services;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import Linkedin.com.example.demo.Models.ProfileModel;
import Linkedin.com.example.demo.Models.UserModel;
import Linkedin.com.example.demo.repository.ProfileRepo;

@Service
public class ProfileService {

    @Autowired
    private ProfileRepo repo;


    public ProfileModel postingdata(ProfileModel profileModel) {
        ProfileModel porf=repo.save(profileModel);
        return  porf;
    }

    public ProfileModel gettingdata(UserModel userModel) {
      return repo.findByUser(userModel).orElse(null);
    }

    public ProfileModel updatedata(UserModel userModel, ProfileModel profileModel) {
    ProfileModel existuser=repo.findByUser(userModel).orElseThrow(()->new RuntimeException("profile not found"));
        System.out.println("updating here");
        existuser.setHeadline(profileModel.getHeadline());
        existuser.setSkills(profileModel.getSkills());
        existuser.setEducation(profileModel.getEducation());
        existuser.setCountry(profileModel.getCountry());
        existuser.setCity(profileModel.getCity());
        existuser.setAbout(profileModel.getAbout());

        return repo.save(existuser);
    }

    public void delete(UserModel userModel) {
        ProfileModel profile = repo.findByUser(userModel)
                .orElseThrow(() -> new RuntimeException("Profile not found"));
        repo.delete(profile);
    }
}