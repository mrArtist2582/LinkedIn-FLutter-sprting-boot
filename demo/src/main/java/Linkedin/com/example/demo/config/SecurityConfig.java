package Linkedin.com.example.demo.config;


// import org.springframework.beans.factory.annotation.Autowired;
// import org.springframework.context.annotation.Bean;
// import org.springframework.context.annotation.Configuration;
// import org.springframework.security.authentication.AuthenticationManager;
// import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
// import org.springframework.security.config.annotation.web.builders.HttpSecurity;
// import org.springframework.security.config.http.SessionCreationPolicy;
// import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
// import org.springframework.security.crypto.password.PasswordEncoder;
// import org.springframework.security.web.SecurityFilterChain;
// import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;

// import Linkedin.com.example.demo.security.CustomUserDetailsService;
// import Linkedin.com.example.demo.security.JwtAuthenticationFilter;

// @Configuration
// public class SecurityConfig {
//     @Autowired
//     private CustomUserDetailsService userDetailsService;
//     @Autowired
//     private JwtAuthenticationFilter jwtAuthenticationFilter;

//     @Bean
//     public PasswordEncoder passwordEncoder() {
//         return new BCryptPasswordEncoder();
//     }

//     @Bean
//     public AuthenticationManager authenticationManager(HttpSecurity http) throws Exception {
//         AuthenticationManagerBuilder builder =
//             http.getSharedObject(AuthenticationManagerBuilder.class);
//         builder.userDetailsService(userDetailsService)
//                .passwordEncoder(passwordEncoder());
//         return builder.build();
//     }

//     @Bean
//     public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
//         http.csrf().disable()
//             .sessionManagement().sessionCreationPolicy(SessionCreationPolicy.STATELESS)
//             .and()
//             .authorizeHttpRequests((requests) ->
//                 requests.requestMatchers("/api/auth/**").permitAll()
//                         .anyRequest().authenticated()
//             )
//             .addFilterBefore(jwtAuthenticationFilter, UsernamePasswordAuthenticationFilter.class);
//         return http.build();
//     }
// }


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.AuthenticationProvider;
import org.springframework.security.authentication.CachingUserDetailsService;
import org.springframework.security.authentication.dao.DaoAuthenticationProvider;
import org.springframework.security.config.annotation.authentication.configuration.AuthenticationConfiguration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.CorsConfigurationSource;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;

import java.util.Arrays;

@Configuration
@EnableWebSecurity
public class SecurityConfig {
     @Autowired
    private final  Linkedin.com.example.demo.security.JwtFilter jwtFilter;
    private final CachingUserDetailsService userDetailsService;

    public SecurityConfig(Linkedin.com.example.demo.security.JwtFilter jwtFilter, CachingUserDetailsService userDetailsService) {
        this.jwtFilter = jwtFilter;
        this.userDetailsService = userDetailsService;
    }

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        return http.csrf(cs -> cs.disable())
                .cors(cors->cors.configurationSource(corsConfigurationSource()))
                .authorizeHttpRequests(auth -> auth

                        .requestMatchers("/auth/").permitAll()  // Allow unauthenticated access to /auth endpoints// Only allow users to access /user endpoints
                        .anyRequest().authenticated()  // Protect other endpoints
                )
                .sessionManagement(sess -> sess.sessionCreationPolicy(SessionCreationPolicy.STATELESS))  // Stateless sessions for JWT
                .addFilterBefore(jwtFilter, UsernamePasswordAuthenticationFilter.class)  // Add JWT filter
                .build();
    }
    @Bean
    public AuthenticationManager authenticationManager(AuthenticationConfiguration config) throws Exception {
        return config.getAuthenticationManager();
    }
    @Bean
    public AuthenticationProvider authenticationProvider() {
        DaoAuthenticationProvider provider = new DaoAuthenticationProvider();
        provider.setPasswordEncoder(passwordEncoder());
       
        return provider;
    }
    @Bean
    CorsConfigurationSource corsConfigurationSource() {
        CorsConfiguration configuration = new CorsConfiguration();
        configuration.setAllowedOrigins(Arrays.asList("*"));
        configuration.setAllowedMethods(Arrays.asList("*"));
        configuration.setAllowedHeaders(Arrays.asList("*"));
        UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
        source.registerCorsConfiguration("/", configuration);
        return source;
}
}