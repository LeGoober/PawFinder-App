package com.pawfinder.shared.utils;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.util.Base64;

public final class HashUtils {

    private static final String SALT_ALPHABET = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
    private static final int SALT_LENGTH = 16;
    private static final SecureRandom SECURE_RANDOM = new SecureRandom();

    private HashUtils() {
        throw new UnsupportedOperationException("Utility class cannot be instantiated");
    }

    /**
     * Hashes an input string using SHA-256 with a random salt.
     * The result is formatted as "salt:hash" where both are Base64-encoded.
     *
     * @param input the string to hash
     * @return the salt and hash concatenated with ":" separator
     */
    public static String hash(String input) {
        String salt = generateSalt();
        String hash = sha256(salt + input);
        return salt + ":" + hash;
    }

    /**
     * Generates a random alphanumeric salt string.
     *
     * @return a 16-character random salt
     */
    private static String generateSalt() {
        StringBuilder salt = new StringBuilder(SALT_LENGTH);
        for (int i = 0; i < SALT_LENGTH; i++) {
            salt.append(SALT_ALPHABET.charAt(SECURE_RANDOM.nextInt(SALT_ALPHABET.length())));
        }
        return salt.toString();
    }

    /**
     * Computes SHA-256 hash and returns it as a Base64-encoded string.
     *
     * @param input the string to hash
     * @return Base64-encoded SHA-256 hash
     */
    private static String sha256(String input) {
        try {
            MessageDigest digest = MessageDigest.getInstance("SHA-256");
            byte[] hashBytes = digest.digest(input.getBytes(StandardCharsets.UTF_8));
            return Base64.getEncoder().encodeToString(hashBytes);
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException("SHA-256 algorithm not available", e);
        }
    }
}
