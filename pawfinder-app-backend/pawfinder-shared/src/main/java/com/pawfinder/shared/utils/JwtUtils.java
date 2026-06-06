package com.pawfinder.shared.utils;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.security.Keys;

import javax.crypto.SecretKey;
import java.util.Date;
import java.util.UUID;

public final class JwtUtils {

    private JwtUtils() {
        throw new UnsupportedOperationException("Utility class cannot be instantiated");
    }

    /**
     * Generates a JWT token for a given user.
     *
     * @param userId      the user's UUID
     * @param secret      the signing secret (must be at least 256 bits for HS256)
     * @param expirationMs token expiration time in milliseconds
     * @return the signed JWT token string
     */
    public static String generateToken(UUID userId, String secret, long expirationMs) {
        SecretKey key = Keys.hmacShaKeyFor(secret.getBytes());
        Date now = new Date();
        Date expiration = new Date(now.getTime() + expirationMs);

        return Jwts.builder()
                .subject(userId.toString())
                .issuedAt(now)
                .expiration(expiration)
                .signWith(key)
                .compact();
    }

    /**
     * Validates a JWT token by parsing and verifying its signature.
     *
     * @param token  the JWT token string
     * @param secret the signing secret used to verify the signature
     * @return true if the token is valid, false otherwise
     */
    public static boolean validateToken(String token, String secret) {
        try {
            SecretKey key = Keys.hmacShaKeyFor(secret.getBytes());
            Jwts.parser()
                    .verifyWith(key)
                    .build()
                    .parseSignedClaims(token);
            return true;
        } catch (Exception e) {
            return false;
        }
    }

    /**
     * Extracts the user ID (subject) from a JWT token.
     *
     * @param token  the JWT token string
     * @param secret the signing secret used to verify the signature
     * @return the UUID of the user extracted from the token subject
     * @throws RuntimeException if the token is invalid or expired
     */
    public static UUID extractUserId(String token, String secret) {
        SecretKey key = Keys.hmacShaKeyFor(secret.getBytes());
        Claims claims = Jwts.parser()
                .verifyWith(key)
                .build()
                .parseSignedClaims(token)
                .getPayload();
        return UUID.fromString(claims.getSubject());
    }
}
