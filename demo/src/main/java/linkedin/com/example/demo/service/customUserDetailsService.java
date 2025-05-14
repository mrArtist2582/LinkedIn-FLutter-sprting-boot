package linkedin.com.example.demo.service;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import linkedin.com.example.demo.models.userModel;
import linkedin.com.example.demo.repo.userRepo;

@Service
public class customUserDetailsService implements UserDetailsService {
    @Autowired
    private userRepo userRepo;
    @Override
    public UserDetails loadUserByUsername(String email) throws UsernameNotFoundException {
        userModel user = userRepo.findByEmail(email)
                .orElseThrow(() -> new UsernameNotFoundException("User not found"));
        return new customUserDetails(user);
    }



    public String login(String email, String password, PasswordEncoder passwordEncoder) {
        userModel userModel = userRepo.findByEmail(email).orElse(null);

        if(userModel==null){
            return "Email not Match";
        }

        if (!passwordEncoder.matches(password, userModel.getPassword())) {
            return "Invalid password";
        }

        return  null;
    }
}
