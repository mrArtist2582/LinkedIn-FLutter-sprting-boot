package Linkedin.com.example.demo.services;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import Linkedin.com.example.demo.dtos.AuthRequest;
import Linkedin.com.example.demo.dtos.AuthResponse;
import Linkedin.com.example.demo.entity.User;
import Linkedin.com.example.demo.exception.ResourceNotFoundException;
import Linkedin.com.example.demo.security.JwtUtil;

// public AuthResponse register(Linkedin.com.example.demo.dtos.RegisterRequest request) throws Exception {
    //     System.out.println("JWT Secret in use: " + jwtTokenProvider.getSecret());

    //     if (userRepository.existsByEmail(request.getEmail())) {
    //         throw new Exception("Email already registered");
    //     }

    //     User user = new User();
    //     user.setName(request.getName());
    //     user.setEmail(request.getEmail());
    //     user.setPassword(passwordEncoder.encode(request.getPassword()));

    //     User saved = userRepository.save(user);
    //     String token = jwtTokenProvider.generateToken(saved.getEmail());

    //     return new AuthResponse(token, saved.getName(), saved.getEmail(), saved.getId());
    // }

    
@Service
public class AuthService {

    @Autowired
    private Linkedin.com.example.demo.repository.UserRepository userRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Autowired
    private JwtUtil jwtUtil;

    @Autowired
    private AuthenticationManager authenticationManager;

    public AuthResponse login(AuthRequest request) {
        org.springframework.security.core.Authentication authentication = authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(request.getEmail(), request.getPassword()));

        User user = userRepository.findByEmail(request.getEmail())
                .orElseThrow(() -> new ResourceNotFoundException("User not found with email " + request.getEmail()));

        String token = jwtUtil.generateToken(new CustomUserDetail(user));
        return new AuthResponse(token, user.getName(), user.getEmail(), user.getId());
    }

    public AuthResponse register(User user) {
        if(userRepository.existsByEmail(user.getEmail())) {
            throw new ResourceNotFoundException("Email already registered");
        }

        user.setPassword(passwordEncoder.encode(user.getPassword()));
        User saved = userRepository.save(user);
        
        String token = jwtUtil.generateToken(new CustomUserDetail(saved));
        return new AuthResponse(token, saved.getName(), saved.getEmail(), saved.getId());
    }
}

