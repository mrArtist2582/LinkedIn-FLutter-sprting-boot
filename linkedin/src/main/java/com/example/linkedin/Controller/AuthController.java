package com.example.linkedin.Controller;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.HttpStatusCode;
import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.bind.annotation.*;

import com.example.linkedin.JWTtoken.JwtUtil;
import com.example.linkedin.Models.UserModel;
import com.example.linkedin.Repo.UserRepo;
import com.example.linkedin.Service.CustomUserDetails;
import com.example.linkedin.Service.CustomUserDetailsService;

import org.springframework.security.core.Authentication;


import java.util.List;
import java.util.Map;
import java.util.Optional;

@RestController
@RequestMapping("/auth")
@CrossOrigin(origins = "*")
public class AuthController {
    @Autowired
    private UserRepo repo;
    @Autowired
    private PasswordEncoder passwordEncoder;
    @Autowired
    private CustomUserDetailsService customUserDetailsService;
    @Autowired
    private JwtUtil jwtUtil;

    @PostMapping("/register")
    public ResponseEntity<String> register(@RequestBody UserModel userModel){
        if (repo.findByEmail(userModel.getEmail()).isPresent()) {
            return new ResponseEntity<>("User already exist", HttpStatus.ALREADY_REPORTED);
        }
        userModel.setPassword(passwordEncoder.encode(userModel.getPassword()));

        repo.save(userModel);
        return new ResponseEntity<>("User Register Successfully", HttpStatus.OK);

    }

    @PostMapping("/login")
    public ResponseEntity<?> login(@RequestBody UserModel userModel) {
        // 1. Check if user exists by email
        Optional<UserModel> user = repo.findByEmail(userModel.getEmail());

        if (user.isEmpty()) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("User not found"); // Email गलत
        }

        // 2. Check if password matches
        if (!passwordEncoder.matches(userModel.getPassword(), user.get().getPassword())) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Invalid password"); // Password गलत
        }

        // 3. Generate token
        String token = jwtUtil.generateToken(new CustomUserDetails(user.get()));

        // 4. Return success response
        return ResponseEntity.ok(Map.of(
                "token", "Bearer " + token,
                "user", user.get(),
                "username",user.get().getUsername()
        ));
    }


    @GetMapping("/profile")
    public ResponseEntity<?> getCurrentUser(Authentication authentication) {
        if (authentication == null || !authentication.isAuthenticated()) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("User not authenticated");
        }
        String email = authentication.getName();
        System.out.println("Email from token: " + email);// Get email from authentication
        Optional<UserModel> user = repo.findByEmail(email);

        if (user.isPresent()) {
            return ResponseEntity.ok(user.get());
        } else {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("User not found");
        }
    }

    @PostMapping("/logout")
    public ResponseEntity<?> logoutAdmin(HttpServletRequest request, HttpServletResponse response) {
        
        String authHeader = request.getHeader("Authorization");

        // Just send response to frontend that token should be deleted
        return ResponseEntity.ok(Map.of(
                "message", "Logout successful. Remove token on frontend."
        ));
    }

    @PutMapping("user/update")
    public ResponseEntity<String> updateUser(@RequestBody UserModel updatedUser, Authentication authentication) {
        System.out.println("==== DEBUG LOG ====");
        System.out.println("Authentication: " + authentication);
        System.out.println("Email from auth.getName(): " + authentication.getName());
        System.out.println("===================");
        String email = authentication.getName();  // gets email from token
        Optional<UserModel> existingUserOpt = repo.findByEmail(email);

        if (existingUserOpt.isEmpty()) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("User not found");
        }

        UserModel existingUser = existingUserOpt.get();
        existingUser.setUsername(updatedUser.getUsername());
        existingUser.setPassword(updatedUser.getPassword());

        repo.save(existingUser);

        return ResponseEntity.ok("User updated successfully");
    }

    @GetMapping("/search")
    public ResponseEntity<List<UserModel>> searchUsers(@RequestParam String username) {
        List<UserModel> searchname=repo.findByUsernameContainingIgnoreCase(username);
        return ResponseEntity.ok(searchname);
    }

}