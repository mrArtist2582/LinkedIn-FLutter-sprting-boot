package Linkedin.com.example.demo.controller;


import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.bind.annotation.*;

import Linkedin.com.example.demo.JWTtoken.JwtUtil;
import Linkedin.com.example.demo.Models.UserModel;
import Linkedin.com.example.demo.repository.UserRepo;
import Linkedin.com.example.demo.services.CustomUserDetails;
import Linkedin.com.example.demo.services.CustomUserDetailsService;

import org.springframework.security.core.Authentication;


import java.util.Map;
import java.util.Optional;

@RestController
@RequestMapping("/auth")
@CrossOrigin(origins = "*")
public class Authcontroller {
    @Autowired
    private UserRepo repo;
    @Autowired
    private PasswordEncoder passwordEncoder;
    @Autowired
    private CustomUserDetailsService customUserDetailsService;
    @Autowired
    private JwtUtil jwtUtil;

    @PostMapping("/register")
    public String register(@RequestBody UserModel userModel){
        if (repo.findByEmail(userModel.getEmail()).isPresent()) {
            return "admin already exist";
        }
        userModel.setPassword(passwordEncoder.encode(userModel.getPassword()));

        repo.save(userModel);
        return "Admin registered successfully";

    }

    @PostMapping("/login")
    public ResponseEntity<?> login(@RequestBody UserModel userModel) {
        String result = customUserDetailsService.login(
                userModel.getEmail(),
                userModel.getPassword(),
                passwordEncoder
        );

//        if (!result.startsWith("login success")) {
//            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(result);
//        }
        if (result != null && result.startsWith("login success")) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(result);
        }

        String token = jwtUtil.generateToken(new CustomUserDetails(userModel));


        Optional<UserModel> user = repo.findByEmail(userModel.getEmail());

        if (user.isPresent()) {
            return ResponseEntity.ok(Map.of(
                    "token", "Bearer " + token,
                    "user", user.get()

            ));
        } else {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("User not found");
        }
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
        // Optionally do some logic here
        // You can get the token if needed:
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
        Optional<UserModel> existingUserOpt = repo.findByUsername(email);

        if (existingUserOpt.isEmpty()) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("User not found");
        }

        UserModel existingUser = existingUserOpt.get();
        existingUser.setUsername(updatedUser.getUsername());
        existingUser.setPassword(updatedUser.getPassword());

        repo.save(existingUser);

        return ResponseEntity.ok("User updated successfully");
    }

}