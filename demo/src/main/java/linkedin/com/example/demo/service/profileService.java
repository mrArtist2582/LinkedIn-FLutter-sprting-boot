package linkedin.com.example.demo.service;



import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import linkedin.com.example.demo.models.profileModel;
import linkedin.com.example.demo.models.userModel;
import linkedin.com.example.demo.repo.profileRepo;

@Service
public class profileService {

    @Autowired
    private profileRepo repo;


    public profileModel postingdata(profileModel profileModel) {
        profileModel porf=repo.save(profileModel);
        return  porf;
    }

    public profileModel gettingdata(userModel userModel) {
      return repo.findByUser(userModel).orElse(null);
    }

    public profileModel updatedata(userModel userModel, profileModel profileModel) {
    profileModel existuser=repo.findByUser(userModel).orElseThrow(()->new RuntimeException("profile not found"));
        System.out.println("updating here");
        existuser.setHeadline(profileModel.getHeadline());
        existuser.setSkills(profileModel.getSkills());
        existuser.setEducation(profileModel.getEducation());
        existuser.setCountry(profileModel.getCountry());
        existuser.setCity(profileModel.getCity());
        existuser.setAbout(profileModel.getAbout());

        return repo.save(existuser);
    }

    public void delete(userModel userModel) {
        profileModel profile = repo.findByUser(userModel)
                .orElseThrow(() -> new RuntimeException("Profile not found"));
        repo.delete(profile);
    }
}