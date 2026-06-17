package com.pawfinder.auth.controller;

import com.pawfinder.auth.dto.*;
import com.pawfinder.auth.service.AuthService;
import com.pawfinder.auth.service.SmsVerificationService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.util.UUID;

@RestController
@RequestMapping("/api/v1/auth")
@RequiredArgsConstructor
@Tag(name = "Authentication", description = "Registration, login, and token management")
public class AuthController {

    private final AuthService authService;
    private final SmsVerificationService smsVerificationService;

    // ── Phone auth ─────────────────────────────────────────────

    @PostMapping("/register")
    @Operation(summary = "Register with phone number", description = "Creates user with phone and sends SMS verification code")
    public ResponseEntity<UserDTO> register(@Valid @RequestBody RegisterRequest request) {
        String displayName = "User-" + request.getPhoneNumber().substring(
                Math.max(0, request.getPhoneNumber().length() - 4));
        UserDTO userDTO = authService.register(request.getPhoneNumber(), displayName);
        smsVerificationService.sendVerificationCode(request.getPhoneNumber());
        return ResponseEntity.status(HttpStatus.CREATED).body(userDTO);
    }

    @PostMapping("/verify")
    @Operation(summary = "Verify phone and login", description = "Verifies SMS code and returns JWT tokens")
    public ResponseEntity<TokenResponse> verify(@Valid @RequestBody VerifyRequest request) {
        String phoneHash = AuthService.hashPhone(request.getPhoneNumber());

        boolean verified = smsVerificationService.verifyCode(request.getPhoneNumber(), request.getVerificationCode());
        if (!verified) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
        }

        TokenResponse tokenResponse = authService.verifyAndLogin(phoneHash, request.getVerificationCode());
        return ResponseEntity.ok(tokenResponse);
    }

    // ── Email + Password auth ──────────────────────────────────

    @PostMapping("/email/register")
    @Operation(summary = "Register with email and password", description = "Creates user with email/password. No verification required — user is verified on creation.")
    public ResponseEntity<TokenResponse> registerWithEmail(@Valid @RequestBody EmailRegisterRequest request) {
        authService.registerWithEmail(request.getEmail(), request.getPassword(), request.getDisplayName());
        // Auto-login after registration
        TokenResponse tokenResponse = authService.loginWithEmail(request.getEmail(), request.getPassword());
        return ResponseEntity.status(HttpStatus.CREATED).body(tokenResponse);
    }

    @PostMapping("/email/login")
    @Operation(summary = "Login with email and password", description = "Authenticates user with email/password and returns JWT tokens")
    public ResponseEntity<TokenResponse> loginWithEmail(@Valid @RequestBody EmailLoginRequest request) {
        TokenResponse tokenResponse = authService.loginWithEmail(request.getEmail(), request.getPassword());
        return ResponseEntity.ok(tokenResponse);
    }

    // ── Provider auth (Google, etc.) ───────────────────────────

    @PostMapping("/login")
    @Operation(summary = "Login via auth provider (Google, etc.)", description = "Login with auth provider and auth ID. Creates user if not found.")
    public ResponseEntity<TokenResponse> login(@Valid @RequestBody LoginRequest request) {
        TokenResponse tokenResponse = authService.login(request.getAuthProvider(), request.getAuthId());
        return ResponseEntity.ok(tokenResponse);
    }

    // ── Token / Profile ────────────────────────────────────────

    @PostMapping("/refresh")
    @Operation(summary = "Refresh access token", description = "Provides a new access token using a valid refresh token")
    public ResponseEntity<TokenResponse> refresh(@RequestHeader("Authorization") String authHeader) {
        if (authHeader == null || !authHeader.startsWith("Bearer ")) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
        }

        String refreshToken = authHeader.substring(7);
        TokenResponse tokenResponse = authService.refreshToken(refreshToken);
        return ResponseEntity.ok(tokenResponse);
    }

    @GetMapping("/me")
    @Operation(summary = "Get current user profile", description = "Returns the authenticated user's profile")
    public ResponseEntity<UserDTO> getCurrentUser(Authentication authentication) {
        UUID userId = (UUID) authentication.getPrincipal();
        UserDTO userDTO = authService.getCurrentUser(userId);
        return ResponseEntity.ok(userDTO);
    }
}
