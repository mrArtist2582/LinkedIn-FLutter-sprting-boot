package Linkedin.com.example.demo.controller;



import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import Linkedin.com.example.demo.Models.ProfileModel;
import Linkedin.com.example.demo.Models.UserModel;
import Linkedin.com.example.demo.repository.ProfileRepo;
import Linkedin.com.example.demo.services.ProfileService;

import java.util.HashMap;
import java.util.Map;
import java.util.Optional;

@RestController
@RequestMapping("/profile")
@CrossOrigin(origins = "*")
public class ProfileController {
    @Autowired
    private ProfileService service;
    @Autowired
    private ProfileRepo repo;

    @PostMapping("/post")
    public ResponseEntity<ProfileModel> postdata(@RequestBody ProfileModel profileModel, @AuthenticationPrincipal UserModel userModel) {
        Optional<ProfileModel> existing = repo.findByUser(userModel);
        if (existing.isPresent()) {
            return new ResponseEntity<>(HttpStatus.CONFLICT); // already has a profile
        }

        profileModel.setUser(userModel); // Set the user from the JWT-authenticated user
        ProfileModel saved = service.postingdata(profileModel);
        return new ResponseEntity<>(saved, HttpStatus.CREATED);
    }

    @GetMapping("/get")
    public ResponseEntity<ProfileModel> getprofile(@AuthenticationPrincipal UserModel userModel) {
        ProfileModel profile = service.gettingdata(userModel);
        return profile != null ? ResponseEntity.ok(profile) : ResponseEntity.notFound().build();
    }

    @PutMapping("/update")
    public ResponseEntity<Map<String,ProfileModel>> updatedata(@AuthenticationPrincipal UserModel userModel, @RequestBody ProfileModel profileModel){
       ProfileModel prof=service.updatedata(userModel,profileModel);
        Map<String, ProfileModel> response = new HashMap<>();
        response.put("updated successfully", prof);

        return new ResponseEntity<>(response,HttpStatus.OK);
    }

    @DeleteMapping("/delete")
    public ResponseEntity<Map<String, String>> deletedata(@AuthenticationPrincipal UserModel userModel) {
        service.delete(userModel); // delete ho gaya
        Map<String, String> response = new HashMap<>();
        response.put("message", "Profile deleted successfully");
        return new ResponseEntity<>(response, HttpStatus.OK);
    }
}