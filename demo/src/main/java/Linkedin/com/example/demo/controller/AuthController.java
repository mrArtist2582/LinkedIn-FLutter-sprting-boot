package Linkedin.com.example.demo.controller;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import Linkedin.com.example.demo.dtos.AuthRequest;
import Linkedin.com.example.demo.dtos.AuthResponse;
import Linkedin.com.example.demo.entity.User;
import Linkedin.com.example.demo.services.AuthService;

@RestController
@RequestMapping("/api/auth")
public class AuthController {
    @Autowired
    private AuthService authService;

    @PostMapping("/register")
    public ResponseEntity<AuthResponse> register(@RequestBody User user) {
        AuthResponse response = authService.register(user);
        return ResponseEntity.ok(response) ;
    }

    @PostMapping("/login")
    public ResponseEntity<AuthResponse> login(@RequestBody AuthRequest request) {
        AuthResponse response = authService.login(request);
        return ResponseEntity.ok(response);
    }
}
