package Linkedin.com.example.demo.services;

import java.util.Collection;
import java.util.List;

import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

import Linkedin.com.example.demo.entity.User;

public class CustomUserDetail implements UserDetails {
    private String email;
    private String password;
    private boolean isActive;
    private List<GrantedAuthority> authorities;

    public CustomUserDetail(String email, String password, boolean isActive, List<GrantedAuthority> authorities) {
        this.email = email;
        this.password = password;
        this.isActive = isActive;
        this.authorities = authorities;
    }

    public CustomUserDetail(User user) {
        //TODO Auto-generated constructor stub
    }

    @Override
    public Collection<? extends GrantedAuthority> getAuthorities() {
        return authorities;
    }

    @Override
    public String getPassword() {
        return password;
    }

    @Override
    public String getUsername() {
        return email;
    }

    @Override
    public boolean isAccountNonExpired() {
        return true;
    }

    @Override
    public boolean isAccountNonLocked() {
        return true;
    }

    @Override
    public boolean isCredentialsNonExpired() {
        return true;
    }

    @Override
    public boolean isEnabled() {
        return isActive;
    }
    
}
