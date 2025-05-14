package linkedin.com.example.demo.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import linkedin.com.example.demo.models.profileModel;
import linkedin.com.example.demo.models.userModel;
import linkedin.com.example.demo.repo.profileRepo;
import linkedin.com.example.demo.service.profileService;

import java.util.HashMap;
import java.util.Map;
import java.util.Optional;

@RestController
@RequestMapping("/profile")
@CrossOrigin(origins = "*")
public class profileController {
    @Autowired
    private profileService service;
    @Autowired
    private profileRepo repo;

    @PostMapping("/post")
    public ResponseEntity<profileModel> postdata(@RequestBody profileModel profileModel, @AuthenticationPrincipal userModel userModel) {
        Optional<profileModel> existing = repo.findByUser(userModel);
        if (existing.isPresent()) {
            return new ResponseEntity<>(HttpStatus.CONFLICT); // already has a profile
        }

        profileModel.setUser(userModel); // Set the user from the JWT-authenticated user
        profileModel saved = service.postingdata(profileModel);
        return new ResponseEntity<>(saved, HttpStatus.CREATED);
    }

    @GetMapping("/get")
    public ResponseEntity<profileModel> getprofile(@AuthenticationPrincipal userModel userModel) {
        profileModel profile = service.gettingdata(userModel);
        return profile != null ? ResponseEntity.ok(profile) : ResponseEntity.notFound().build();
    }

    @PutMapping("/update")
    public ResponseEntity<Map<String,profileModel>> updatedata(@AuthenticationPrincipal userModel userModel, @RequestBody profileModel profileModel){
       profileModel prof=service.updatedata(userModel,profileModel);
        Map<String, profileModel> response = new HashMap<>();
        response.put("updated successfully", prof);

        return new ResponseEntity<>(response,HttpStatus.OK);
    }

    @DeleteMapping("/delete")
    public ResponseEntity<Map<String, String>> deletedata(@AuthenticationPrincipal userModel userModel) {
        service.delete(userModel); // delete ho gaya
        Map<String, String> response = new HashMap<>();
        response.put("message", "Profile deleted successfully");
        return new ResponseEntity<>(response, HttpStatus.OK);
    }
}