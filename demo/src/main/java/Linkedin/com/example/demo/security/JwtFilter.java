package Linkedin.com.example.demo.security;

// import jakarta.servlet.FilterChain;
// import jakarta.servlet.ServletException;
// import jakarta.servlet.http.HttpServletRequest;
// import jakarta.servlet.http.HttpServletResponse;
// import org.springframework.beans.factory.annotation.Autowired;
// import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
// import org.springframework.security.core.context.SecurityContextHolder;
// import org.springframework.security.core.userdetails.UserDetails;
// import org.springframework.security.web.authentication.WebAuthenticationDetailsSource;
// import org.springframework.stereotype.Component;
// import org.springframework.web.filter.OncePerRequestFilter;

// import java.io.IOException;

// @Component
// public class JwtAuthenticationFilter extends OncePerRequestFilter {

//     @Autowired
//     private JwtTokenProvider jwtTokenProvider;

//     @Autowired
//     private CustomUserDetailsService userDetailsService;

//     protected void doFilterInternal(HttpServletRequest request,
//                                     HttpServletResponse response,
//                                     FilterChain filterChain) throws ServletException, IOException {

//         String authHeader = request.getHeader("Authorization");
//         String token = null;
//         JwtTokenProvider username = null;

//         if (authHeader != null && authHeader.startsWith("Bearer ")) {
//             token = authHeader.substring(7);
//             username = jwtTokenProvider}
//     // @Override
//     // protected void doFilterInternal(@SuppressWarnings("null") HttpServletRequest request,
//     //                                 @SuppressWarnings("null") HttpServletResponse response,
//     //                                 @SuppressWarnings("null") FilterChain filterChain)
//     //         throws ServletException, IOException {

//     //     String header = request.getHeader("Authorization");
//     //     String token = null;
//     //     String username = null;

//     //     if (header != null && header.startsWith("Bearer ")) {
//     //         token = header.substring(7);
//     //         username = jwtTokenProvider.getUsernameFromToken(token);
//     //     }

//     //     if (username != null && SecurityContextHolder.getContext().getAuthentication() == null) {
//     //         if (jwtTokenProvider.validateToken(token)) {
//     //             UserDetails userDetails = userDetailsService.loadUserByUsername(username);
//     //             UsernamePasswordAuthenticationToken authentication =
//     //                     new UsernamePasswordAuthenticationToken(
//     //                             userDetails, null, userDetails.getAuthorities());
//     //             authentication.setDetails(
//     //                     new WebAuthenticationDetailsSource().buildDetails(request));

//     //             SecurityContextHolder.getContext().setAuthentication(authentication);
//     //         }
//     //     }

//     //     filterChain.doFilter(request, response);
//     // }

//         }

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.web.authentication.WebAuthenticationDetailsSource;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;
import java.io.IOException;

@Component
public class JwtFilter extends OncePerRequestFilter {

    @Autowired
    private JwtUtil jwtUtil;

    @Autowired
    private CustomUserDetailsService userDetailsService;

    @Override
    protected void doFilterInternal(HttpServletRequest request,
                                    HttpServletResponse response,
                                    FilterChain filterChain) throws ServletException, IOException {

        String authHeader = request.getHeader("Authorization");
        String token = null;
        String username = null;

        if (authHeader != null && authHeader.startsWith("Bearer ")) {
            token = authHeader.substring(7);
            username = jwtUtil.extractUsername(token);

        }
        System.out.println(token);

        if (username != null && SecurityContextHolder.getContext().getAuthentication() == null) {
            UserDetails userDetails = userDetailsService.loadUserByUsername(username);

            if (jwtUtil.isTokenValid(token,userDetails)) {
                UsernamePasswordAuthenticationToken auth =
                        new UsernamePasswordAuthenticationToken(userDetails, null, userDetails.getAuthorities());
                auth.setDetails(new WebAuthenticationDetailsSource().buildDetails(request));

                SecurityContextHolder.getContext().setAuthentication(auth);
            }
        }
        System.out.println("fdokdfokdofk");
        filterChain.doFilter(request, response);
}
}