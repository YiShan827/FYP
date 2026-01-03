//package com.example.musicquiz.security;
//
//import io.jsonwebtoken.Claims;
//import io.jsonwebtoken.Jwts;
//import io.jsonwebtoken.SignatureAlgorithm;
//import io.jsonwebtoken.security.Keys;
//import org.springframework.stereotype.Component;
//
//import java.security.Key;
//import java.util.Collections;
//import java.util.Date;
//import java.util.HashMap;
//import java.util.Map;
//import java.util.function.Function;
//
//@Component
//public class JwtUtil {
//
//    private final String SECRET_KEY = "mySecretKeyForJWTTokenThatIsLongEnoughForHS256Algorithm";
//    private final Key key = Keys.hmacShaKeyFor(SECRET_KEY.getBytes());
//
//    public String extractUsername(String token) {
//        return extractAllClaims(token).getSubject();
//    }
//
//    public Date extractExpiration(String token) {
//        return extractAllClaims(token).getExpiration();
//    }
//
//    public <T> T extractClaim(String token, Function<Claims, T> claimsResolver) {
//        final Claims claims = extractAllClaims(token);
//        return claimsResolver.apply(claims);
//    }
//
//    private Claims extractAllClaims(String token) {
//        try {
//            return Jwts.parserBuilder()
//                    .setSigningKey(key)
//                    .build()
//                    .parseClaimsJws(token)
//                    .getBody();
//        } catch (Exception e) {
//            throw new RuntimeException("Invalid JWT token", e);
//        }
//    }
//
//    private Boolean isTokenExpired(String token) {
//        return extractExpiration(token).before(new Date());
//    }
//
//    public Boolean validateToken(String token, String email) {
//        try {
//            final String username = extractUsername(token);
//            return (username.equals(email) && !isTokenExpired(token));
//        } catch (Exception e) {
//            return false;
//        }
//    }
//
//    // 🔒 Simple version (no role included)
//    public String generateToken(String email, String role) {
//        Map<String, Object> claims = new HashMap<>();
//        claims.put("role", role);
//        claims.put("authorities", Collections.singletonList("ROLE_" + role));
//        return generateToken(claims, email);
//    }
//
//    // 🔒 Full version: include role or other claims
//    public String generateToken(Map<String, Object> claims, String email) {
//        return Jwts.builder()
//                .setClaims(claims)
//                .setSubject(email)
//                .setIssuedAt(new Date(System.currentTimeMillis()))
//                .setExpiration(new Date(System.currentTimeMillis() + 86400000)) // 24 hours
//                .signWith(key, SignatureAlgorithm.HS256)
//                .compact();
//    }
//}


package com.example.musicquiz.security;

import com.example.musicquiz.repository.UserRepository;
import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import io.jsonwebtoken.security.Keys;
import org.springframework.stereotype.Component;

import java.security.Key;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.function.Function;

@Component
public class JwtUtil {

    private final String SECRET_KEY = "mySecretKeyForJWTTokenThatIsLongEnoughForHS256Algorithm";
    private final Key key = Keys.hmacShaKeyFor(SECRET_KEY.getBytes());

    public String extractUsername(String token) {
        return extractAllClaims(token).getSubject();
    }

    public Date extractExpiration(String token) {
        return extractAllClaims(token).getExpiration();
    }

    public <T> T extractClaim(String token, Function<Claims, T> claimsResolver) {
        final Claims claims = extractAllClaims(token);
        return claimsResolver.apply(claims);
    }

    private Claims extractAllClaims(String token) {
        try {
            return Jwts.parserBuilder()
                    .setSigningKey(key)
                    .build()
                    .parseClaimsJws(token)
                    .getBody();
        } catch (Exception e) {
            throw new RuntimeException("Invalid JWT token", e);
        }


    }

    private Boolean isTokenExpired(String token) {
        return extractExpiration(token).before(new Date());
    }

    public Boolean validateToken(String token, String email) {
        try {
            final String username = extractUsername(token);
            return (username.equals(email) && !isTokenExpired(token));
        } catch (Exception e) {
            return false;
        }
    }

    // Simple version (role included)
    public String generateToken(String email, String role) {
        Map<String, Object> claims = new HashMap<>();
        claims.put("role", role);
        return generateToken(claims, email);
    }

    // Full version: include claims
    public String generateToken(Map<String, Object> claims, String email) {
        return Jwts.builder()
                .setClaims(claims)
                .setSubject(email)
                .setIssuedAt(new Date(System.currentTimeMillis()))
                .setExpiration(new Date(System.currentTimeMillis() + 86400000)) // 24 hours
                .signWith(key, SignatureAlgorithm.HS256)
                .compact();
    }

    public Long getUserIdFromUsername(String username, UserRepository userRepository) {
        return userRepository.findByUsername(username)
                .map(user -> user.getId())
                .orElse(null);
    }
}
