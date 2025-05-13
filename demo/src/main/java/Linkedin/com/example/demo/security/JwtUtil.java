package Linkedin.com.example.demo.security;

// import io.jsonwebtoken.*;
// import org.springframework.beans.factory.annotation.Value;
// import org.springframework.stereotype.Component;

// import java.util.Date;

// @Component
// public class JwtTokenProvider {

//     @Value("${jwt.secret}")
//     private String jwtSecret;

//     private final long JWT_EXPIRATION = 86400000; // 24 hours

//     // Generate JWT token with username as subject
//     public String generateToken(String username) {
//         Date now = new Date();
//         Date expiryDate = new Date(now.getTime() + JWT_EXPIRATION);

//         return Jwts.builder()
//                 .setSubject(username)
//                 .setIssuedAt(now)
//                 .setExpiration(expiryDate)
//                 .signWith(SignatureAlgorithm.HS512, jwtSecret)
//                 .compact();
//     }

//     // Extract username from JWT
//     public String getUsernameFromToken(String token) {
//         Claims claims = Jwts.parser()
//                 .setSigningKey(jwtSecret)
//                 .parseClaimsJws(token)
//                 .getBody();
//         return claims.getSubject();
//     }

//     // Validate the JWT
//     public boolean validateToken(String token) {
//         try {
//             Jwts.parser().setSigningKey(jwtSecret).parseClaimsJws(token);
//             return true;
//         } catch (SignatureException ex) {
//             System.out.println("Invalid JWT signature");
//         } catch (MalformedJwtException ex) {
//             System.out.println("Invalid JWT token");
//         } catch (ExpiredJwtException ex) {
//             System.out.println("Expired JWT token");
//         } catch (UnsupportedJwtException ex) {
//             System.out.println("Unsupported JWT token");
//         } catch (IllegalArgumentException ex) {
//             System.out.println("JWT claims string is empty.");
//         }
//         return false;
//     }

//     public String getSecret() {
      
//         throw new UnsupportedOperationException("Unimplemented method 'getSecret'");
//     }
// }
import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import io.jsonwebtoken.io.Decoders;
import io.jsonwebtoken.security.Keys;
import java.security.Key;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.function.Function;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Service;

@Service
public class JwtUtil {
    @Value("${security.jwt.secret-key}")
    private String secretKey;

    @Value("${security.jwt.expiration-time}")
    private long jwtExpiration;

    public String extractUsername(String token) {
        return extractClaim(token, Claims::getSubject);
    }

    public <T> T extractClaim(String token, Function<Claims, T> claimsResolver) {
        final Claims claims = extractAllClaims(token);
        return claimsResolver.apply(claims);
    }

    public String generateToken(UserDetails userDetails) {
        return generateToken(new HashMap<>(), userDetails);
    }

    public String generateToken(Map<String, Object> extraClaims, UserDetails userDetails) {
        return buildToken(extraClaims, userDetails, jwtExpiration);
    }

    public long getExpirationTime() {
        return jwtExpiration;
    }

    private String buildToken(
            Map<String, Object> extraClaims,
            UserDetails userDetails,
            long expiration
    ) {
        return Jwts
                .builder()
                .setClaims(extraClaims)
                .setSubject(userDetails.getUsername())
                .setIssuedAt(new Date(System.currentTimeMillis()))
                .setExpiration(new Date(System.currentTimeMillis() + expiration))
                .signWith(getSignInKey(), SignatureAlgorithm.HS256)
                .compact();
    }

    public boolean isTokenValid(String token, UserDetails userDetails) {
        final String username = extractUsername(token);
        return (username.equals(userDetails.getUsername())) && !isTokenExpired(token);
    }

    private boolean isTokenExpired(String token) {
        return extractExpiration(token).before(new Date());
    }

    private Date extractExpiration(String token) {
        return extractClaim(token, Claims::getExpiration);
    }

    private Claims extractAllClaims(String token) {
        return Jwts
                .parserBuilder()
                .setSigningKey(getSignInKey())
                .build()
                .parseClaimsJws(token)
                .getBody();
    }

    private Key getSignInKey() {
        byte[] keyBytes = Decoders.BASE64.decode(secretKey);
        return Keys.hmacShaKeyFor(keyBytes);
}
}