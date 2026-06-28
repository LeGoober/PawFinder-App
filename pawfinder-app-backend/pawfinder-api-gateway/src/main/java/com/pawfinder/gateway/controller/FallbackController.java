package com.pawfinder.gateway.controller;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Circuit-breaker fallback controller for downstream microservice failures.
 * <p>
 * Only serves {@code /fallback/**} paths — triggered exclusively by
 * Spring Cloud Gateway's {@code circuitBreaker} filter when a downstream
 * service is unreachable or timing out.
 * <p>
 * IMPORTANT: This controller must NEVER map to {@code /api/v1/**} paths.
 * Doing so causes Spring MVC ({@code @Order(0)}) to intercept requests
 * before Gateway routes ({@code @Order(1)}), returning empty responses
 * that crash the Flutter frontend with null type errors.
 */
@RestController
@RequestMapping("/fallback")
public class FallbackController {

    @GetMapping("/auth")
    public ResponseEntity<Map<String, Object>> authFallback() {
        return ResponseEntity.status(503).body(Map.of(
                "error", "service_unavailable",
                "message", "Auth service is temporarily unavailable. Please try again in a moment."
        ));
    }

    @GetMapping("/alert")
    public ResponseEntity<Map<String, Object>> alertFallback() {
        return ResponseEntity.status(503).body(Map.of(
                "error", "service_unavailable",
                "message", "Alert service is temporarily unavailable."
        ));
    }

    @GetMapping("/sighting")
    public ResponseEntity<Map<String, Object>> sightingFallback() {
        return ResponseEntity.status(503).body(Map.of(
                "error", "service_unavailable",
                "message", "Sighting service is temporarily unavailable."
        ));
    }

    @GetMapping("/pet")
    public ResponseEntity<Map<String, Object>> petFallback() {
        return ResponseEntity.status(503).body(Map.of(
                "error", "service_unavailable",
                "message", "Pet service is temporarily unavailable."
        ));
    }

    @GetMapping("/conversation")
    public ResponseEntity<Map<String, Object>> conversationFallback() {
        return ResponseEntity.status(503).body(Map.of(
                "error", "service_unavailable",
                "message", "Messaging service is temporarily unavailable."
        ));
    }

    @GetMapping("/message")
    public ResponseEntity<Map<String, Object>> messageFallback() {
        return ResponseEntity.status(503).body(Map.of(
                "error", "service_unavailable",
                "message", "Messaging service is temporarily unavailable."
        ));
    }

    @GetMapping("/reward")
    public ResponseEntity<Map<String, Object>> rewardFallback() {
        return ResponseEntity.status(503).body(Map.of(
                "error", "service_unavailable",
                "message", "Reward service is not yet available."
        ));
    }

    @GetMapping("/media")
    public ResponseEntity<Map<String, Object>> mediaFallback() {
        return ResponseEntity.status(503).body(Map.of(
                "error", "service_unavailable",
                "message", "Media service is not yet available."
        ));
    }

    @GetMapping("/dashboard")
    public ResponseEntity<Map<String, Object>> dashboardFallback() {
        return ResponseEntity.ok(Map.of(
                "activeAlerts", 0,
                "petsFound", 0,
                "communityMembers", 0,
                "sightingsToday", 0
        ));
    }

    @GetMapping("/leaderboard")
    public ResponseEntity<List<Map<String, Object>>> leaderboardFallback() {
        return ResponseEntity.ok(Collections.emptyList());
    }

    @GetMapping("/badge")
    public ResponseEntity<List<Map<String, Object>>> badgeFallback() {
        return ResponseEntity.ok(Collections.emptyList());
    }

    @GetMapping("/ws")
    public ResponseEntity<Map<String, Object>> wsFallback() {
        return ResponseEntity.status(503).body(Map.of(
                "error", "service_unavailable",
                "message", "WebSocket service is temporarily unavailable."
        ));
    }
}
