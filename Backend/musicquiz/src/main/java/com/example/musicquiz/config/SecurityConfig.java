package com.example.musicquiz.config;

import com.example.musicquiz.security.JwtAuthFilter;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpMethod;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.config.annotation.authentication.configuration.AuthenticationConfiguration;
import org.springframework.security.config.annotation.method.configuration.EnableGlobalMethodSecurity;
import org.springframework.security.config.annotation.method.configuration.EnableMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;

@EnableMethodSecurity(prePostEnabled = true)
@Configuration
public class SecurityConfig {

    private final JwtAuthFilter jwtFilter;

    public SecurityConfig(JwtAuthFilter jwtFilter) {
        this.jwtFilter = jwtFilter;
    }

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
                .csrf(csrf -> csrf.disable())
                .cors(cors -> {})
                .authorizeHttpRequests(auth -> auth


                        // Public endpoints FIRST
                        .requestMatchers("/api/users/**").permitAll()
                        .requestMatchers(HttpMethod.GET, "/api/forum/categories").permitAll()
                        .requestMatchers(HttpMethod.GET, "/api/forum/categories/**").permitAll()
                        .requestMatchers(HttpMethod.GET, "/api/forum/posts").permitAll()
                        .requestMatchers(HttpMethod.GET, "/api/forum/posts/**").permitAll()
                        .requestMatchers(HttpMethod.GET, "/api/forum/search").permitAll()

                        // Protected forum endpoints
                        .requestMatchers(HttpMethod.POST, "/api/forum/posts").hasAnyRole("USER", "ADMIN")
                        .requestMatchers(HttpMethod.POST, "/api/forum/replies").hasAnyRole("USER", "ADMIN")
                        .requestMatchers("/api/forum/admin/**").hasRole("ADMIN")

                        // Quiz endpoints
                        .requestMatchers(HttpMethod.POST, "/api/quizzes/*/start").hasAnyRole("USER", "ADMIN")
                        .requestMatchers(HttpMethod.POST, "/api/quizzes/*/submit-answer").hasAnyRole("USER", "ADMIN")
                        .requestMatchers(HttpMethod.GET, "/api/quizzes/my-stats").hasAnyRole("USER", "ADMIN")
                        .requestMatchers(HttpMethod.POST, "/api/quizzes").hasRole("ADMIN")
                        .requestMatchers(HttpMethod.POST, "/api/quizzes/bulk").hasRole("ADMIN")
                        .requestMatchers("/api/progress/admin/**").hasRole("ADMIN")
                        .requestMatchers(HttpMethod.DELETE, "/api/quizzes/**").hasRole("ADMIN")
                        .requestMatchers("/api/resources/**").authenticated()
                        .requestMatchers(HttpMethod.GET, "/api/resources/resources").hasAnyRole("USER", "ADMIN")
                        .requestMatchers("/api/progress/progress").hasRole("USER")

                        .anyRequest().authenticated()
                )
                .sessionManagement(session -> session.sessionCreationPolicy(SessionCreationPolicy.STATELESS))
                .addFilterBefore(jwtFilter, UsernamePasswordAuthenticationFilter.class);

        return http.build();
    }

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }

    @Bean
    public AuthenticationManager authenticationManager(AuthenticationConfiguration config) throws Exception {
        return config.getAuthenticationManager();
    }
}