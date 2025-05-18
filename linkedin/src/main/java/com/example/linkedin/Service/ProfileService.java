package com.example.linkedin.Service;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.linkedin.Models.ProfileModel;
import com.example.linkedin.Models.UserModel;
import com.example.linkedin.Repo.ProfileRepo;

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
    ProfileModel existuser=repo.findByUser(userModel).orElse(null);
    if(existuser==null ){
        ProfileModel porf=repo.save(profileModel);
        return porf;
    }
        System.out.println("updating here");
        existuser.setHeadline(profileModel.getHeadline());
        existuser.setSkills(profileModel.getSkills());
        existuser.setEducation(profileModel.getEducation());
        existuser.setCountry(profileModel.getCountry());
        existuser.setCity(profileModel.getCity());
        existuser.setAbout(profileModel.getAbout());
        existuser.setLink(profileModel.getLink());
        existuser.setLinktext(profileModel.getLinktext());
        existuser.setExperience(profileModel.getExperience());
        existuser.setIndustry(profileModel.getIndustry());
        existuser.setPronoums(profileModel.getPronoums());
        return repo.save(existuser);
    }

    public void delete(UserModel userModel) {
        ProfileModel profile = repo.findByUser(userModel)
                .orElseThrow(() -> new RuntimeException("Profile not found"));
        repo.delete(profile);
    }
}