//package com.example.musicquiz.security;
//
//import jakarta.servlet.FilterChain;
//import jakarta.servlet.ServletException;
//import jakarta.servlet.http.HttpServletRequest;
//import jakarta.servlet.http.HttpServletResponse;
//import org.springframework.beans.factory.annotation.Autowired;
//import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
//import org.springframework.security.core.authority.SimpleGrantedAuthority;
//import org.springframework.security.core.context.SecurityContextHolder;
//import org.springframework.security.web.authentication.WebAuthenticationDetailsSource;
//import org.springframework.stereotype.Component;
//import org.springframework.web.filter.OncePerRequestFilter;
//
//import java.io.IOException;
//import java.util.Collections;
//import java.util.List;
//
//@Component
//public class JwtAuthFilter extends OncePerRequestFilter {
//
//    @Autowired
//    private JwtUtil jwtUtil;
//
//    @Override
//    protected void doFilterInternal(HttpServletRequest request,
//                                    HttpServletResponse response,
//                                    FilterChain filterChain) throws ServletException, IOException {
//
//        String path = request.getServletPath();
//        if (path.equals("/api/users/login") || path.equals("/api/users/register")) {
//            filterChain.doFilter(request, response);
//            return;
//        }
//
//        String authHeader = request.getHeader("Authorization");
//        String token = null;
//        String email = null;
//
//        if (authHeader != null && authHeader.startsWith("Bearer ")) {
//            token = authHeader.substring(7);
//            email = jwtUtil.extractUsername(token);
//        }
//
//        if (email != null && SecurityContextHolder.getContext().getAuthentication() == null) {
//            if (jwtUtil.validateToken(token, email)) {
//                // 🔐 Extract role from token
//                List<String> roles = jwtUtil.extractClaim(token, claims -> {
//                    Object raw = claims.get("authorities");
//                    if (raw instanceof List<?> list) {
//                        return list.stream().map(Object::toString).toList();
//                    }
//                    return List.of(); // empty list fallback
//                });
//
//                if (roles == null) {
//                    filterChain.doFilter(request, response); // skip auth setup
//                    return;
//                }
//
//                List<SimpleGrantedAuthority> authorities = roles.stream()
//                        .map(SimpleGrantedAuthority::new)
//                        .toList();
//
//                UsernamePasswordAuthenticationToken authToken =
//                        new UsernamePasswordAuthenticationToken(email, null, authorities);
//
//
//                authToken.setDetails(new WebAuthenticationDetailsSource().buildDetails(request));
//                SecurityContextHolder.getContext().setAuthentication(authToken);
//            }
//        }
//
//        filterChain.doFilter(request, response);
//    }
//}

package com.example.musicquiz.security;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.web.authentication.WebAuthenticationDetailsSource;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;
import java.util.Collections;

@Component
public class JwtAuthFilter extends OncePerRequestFilter {

    @Autowired
    private JwtUtil jwtUtil;

    @Override
    protected void doFilterInternal(HttpServletRequest request,
                                    HttpServletResponse response,
                                    FilterChain filterChain) throws ServletException, IOException {

        String path = request.getServletPath();
        String method = request.getMethod();

        System.out.println("🔍 JWT Filter - Processing: " + method + " " + path); // DEBUG

        // List of public endpoints that don't need JWT
        boolean isPublicEndpoint =
                path.startsWith("/api/users/") ||
                        path.equals("/api/forum/categories") ||
                        path.equals("/api/forum/search") ||
                        (path.startsWith("/api/forum/posts") && "GET".equals(method)) ||
                        path.matches("/api/forum/posts/\\d+") && "GET".equals(method);

        if (isPublicEndpoint) {
            System.out.println("🔍 Public endpoint - skipping JWT check"); // DEBUG
            filterChain.doFilter(request, response);
            return;
        }

        System.out.println("🔍 Protected endpoint - checking JWT"); // DEBUG

        String authHeader = request.getHeader("Authorization");
        if (authHeader == null || !authHeader.startsWith("Bearer ")) {
            System.out.println("🔍 No valid auth header found"); // DEBUG
            filterChain.doFilter(request, response);
            return;
        }

        String token = authHeader.substring(7);
        String email = jwtUtil.extractUsername(token);

        if (email != null && SecurityContextHolder.getContext().getAuthentication() == null) {
            if (jwtUtil.validateToken(token, email)) {
                String role = jwtUtil.extractClaim(token, claims -> claims.get("role").toString());
                SimpleGrantedAuthority authority = new SimpleGrantedAuthority("ROLE_" + role);

                UsernamePasswordAuthenticationToken authToken =
                        new UsernamePasswordAuthenticationToken(email, null, Collections.singletonList(authority));

                authToken.setDetails(new WebAuthenticationDetailsSource().buildDetails(request));
                SecurityContextHolder.getContext().setAuthentication(authToken);
                System.out.println("🔍 JWT authentication set for: " + email); // DEBUG
            }
        }

        filterChain.doFilter(request, response);
    }
}

