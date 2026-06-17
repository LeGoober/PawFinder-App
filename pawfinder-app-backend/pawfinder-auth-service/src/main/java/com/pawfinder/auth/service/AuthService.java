package com.pawfinder.auth.service;

import com.pawfinder.auth.config.JwtConfig;
import com.pawfinder.auth.dto.TokenResponse;
import com.pawfinder.auth.dto.UserDTO;
import com.pawfinder.auth.repository.UserRepository;
import com.pawfinder.shared.domain.User;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.time.LocalDateTime;
import java.util.HexFormat;
import java.util.UUID;

@Service
@RequiredArgsConstructor
@Slf4j
public class AuthService {

    private final UserRepository userRepository;
    private final JwtService jwtService;
    private final JwtConfig jwtConfig;
    private final PasswordEncoder passwordEncoder;

    // ── Phone auth (existing) ──────────────────────────────────

    @Transactional
    public UserDTO register(String phoneNumber, String displayName) {
        String phoneHash = hashPhone(phoneNumber);

        User user = User.builder()
                .authProvider("phone")
                .authId(UUID.randomUUID().toString())
                .phoneHash(phoneHash)
                .displayName(displayName)
                .verified(false)
                .rescuerBadgeLevel(0)
                .build();

        user = userRepository.save(user);
        log.info("Registered new user (phone): {}", user.getAuthId());

        return toDTO(user);
    }

    @Transactional
    public TokenResponse verifyAndLogin(String phoneHash, String code) {
        User user = userRepository.findByPhoneHash(phoneHash)
                .orElseThrow(() -> new RuntimeException("User not found with given phone hash"));

        user.setVerified(true);
        user.setLastActive(LocalDateTime.now());
        userRepository.save(user);

        return generateTokenResponse(user);
    }

    // ── Email + Password auth (new) ────────────────────────────

    @Transactional
    public UserDTO registerWithEmail(String email, String password, String displayName) {
        if (userRepository.existsByEmail(email)) {
            throw new RuntimeException("An account with this email already exists");
        }

        User user = User.builder()
                .authProvider("email")
                .authId(UUID.randomUUID().toString())
                .email(email.toLowerCase().trim())
                .passwordHash(passwordEncoder.encode(password))
                .displayName(displayName != null && !displayName.isBlank()
                        ? displayName
                        : email.split("@")[0])
                .verified(true) // Email-based: verified on creation
                .rescuerBadgeLevel(0)
                .build();

        user = userRepository.save(user);
        log.info("Registered new user (email): {}", email);

        return toDTO(user);
    }

    @Transactional
    public TokenResponse loginWithEmail(String email, String password) {
        User user = userRepository.findByEmail(email.toLowerCase().trim())
                .orElseThrow(() -> new RuntimeException("Invalid email or password"));

        if (!passwordEncoder.matches(password, user.getPasswordHash())) {
            throw new RuntimeException("Invalid email or password");
        }

        user.setLastActive(LocalDateTime.now());
        userRepository.save(user);

        log.info("User logged in (email): {}", email);
        return generateTokenResponse(user);
    }

    // ── Provider auth (Google, etc.) ───────────────────────────

    @Transactional
    public TokenResponse login(String authProvider, String authId) {
        User user = userRepository.findByAuthId(authId)
                .orElseGet(() -> {
                    User newUser = User.builder()
                            .authProvider(authProvider)
                            .authId(authId)
                            .displayName("User-" + authId.substring(0, Math.min(authId.length(), 8)))
                            .verified(true)
                            .rescuerBadgeLevel(0)
                            .build();
                    log.info("Created new user via {} login: {}", authProvider, authId);
                    return userRepository.save(newUser);
                });

        user.setLastActive(LocalDateTime.now());
        userRepository.save(user);

        return generateTokenResponse(user);
    }

    // ── Token / Profile ────────────────────────────────────────

    public TokenResponse refreshToken(String refreshToken) {
        if (!jwtService.validateToken(refreshToken)) {
            throw new RuntimeException("Invalid or expired refresh token");
        }

        UUID userId = jwtService.extractUserId(refreshToken);
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found"));

        return generateTokenResponse(user);
    }

    public UserDTO getCurrentUser(UUID userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found"));
        return toDTO(user);
    }

    // ── Internal ───────────────────────────────────────────────

    private TokenResponse generateTokenResponse(User user) {
        String accessToken = jwtService.generateAccessToken(user.getId());
        String refreshToken = jwtService.generateRefreshToken(user.getId());
        return TokenResponse.of(accessToken, refreshToken, jwtConfig.getAccessTokenExpiration());
    }

    private UserDTO toDTO(User user) {
        return UserDTO.builder()
                .id(user.getId())
                .authProvider(user.getAuthProvider())
                .displayName(user.getDisplayName())
                .email(user.getEmail())
                .verified(user.isVerified())
                .rescuerBadgeLevel(user.getRescuerBadgeLevel())
                .createdAt(user.getCreatedAt())
                .lastActive(user.getLastActive())
                .build();
    }

    public static String hashPhone(String phoneNumber) {
        try {
            MessageDigest digest = MessageDigest.getInstance("SHA-256");
            byte[] hash = digest.digest(phoneNumber.getBytes(StandardCharsets.UTF_8));
            return HexFormat.of().formatHex(hash);
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException("SHA-256 not available", e);
        }
    }
}
