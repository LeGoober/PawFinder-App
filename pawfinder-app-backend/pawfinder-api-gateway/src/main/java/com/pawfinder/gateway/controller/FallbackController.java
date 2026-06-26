package com.pawfinder.gateway.controller;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Lightweight fallback controller for service endpoints whose downstream
 * microservices haven't been provisioned on Render yet.
 * <p>
 * Returns empty/safe responses instead of 500 Internal Server Error
 * so the Flutter frontend doesn't crash with loading skeletons.
 * <p>
 * Registered at {@code @Order(0)} via {@code RequestMappingHandlerMapping},
 * which takes precedence over Spring Cloud Gateway routes ({@code @Order(1)}).
 */
@RestController
public class FallbackController {

    // ═══════════════════════════════════════════════════════
    // Alerts
    // ═══════════════════════════════════════════════════════

    @GetMapping("/api/v1/alerts")
    public ResponseEntity<List<Map<String, Object>>> getAlerts() {
        return ResponseEntity.ok(Collections.emptyList());
    }

    @GetMapping("/api/v1/alerts/nearby")
    public ResponseEntity<List<Map<String, Object>>> getNearbyAlerts(
            @RequestParam(required = false) Double lat,
            @RequestParam(required = false) Double lng,
            @RequestParam(required = false) Double radiusKm) {
        return ResponseEntity.ok(Collections.emptyList());
    }

    @PostMapping("/api/v1/alerts")
    public ResponseEntity<Map<String, Object>> createAlert(@RequestBody(required = false) Map<String, Object> body) {
        return ResponseEntity.ok(new HashMap<>());
    }

    // ═══════════════════════════════════════════════════════
    // Pets
    // ═══════════════════════════════════════════════════════

    @GetMapping("/api/v1/pets")
    public ResponseEntity<List<Map<String, Object>>> getPets() {
        return ResponseEntity.ok(Collections.emptyList());
    }

    @PostMapping("/api/v1/pets")
    public ResponseEntity<Map<String, Object>> createPet(@RequestBody(required = false) Map<String, Object> body) {
        return ResponseEntity.ok(new HashMap<>());
    }

    // ═══════════════════════════════════════════════════════
    // Sightings
    // ═══════════════════════════════════════════════════════

    @GetMapping("/api/v1/sightings")
    public ResponseEntity<List<Map<String, Object>>> getSightings() {
        return ResponseEntity.ok(Collections.emptyList());
    }

    @PostMapping("/api/v1/sightings")
    public ResponseEntity<Map<String, Object>> reportSighting(@RequestBody(required = false) Map<String, Object> body) {
        return ResponseEntity.ok(new HashMap<>());
    }

    // ═══════════════════════════════════════════════════════
    // Conversations
    // ═══════════════════════════════════════════════════════

    @GetMapping("/api/v1/conversations")
    public ResponseEntity<List<Map<String, Object>>> getConversations() {
        return ResponseEntity.ok(Collections.emptyList());
    }

    @PostMapping("/api/v1/conversations")
    public ResponseEntity<Map<String, Object>> startConversation(@RequestBody(required = false) Map<String, Object> body) {
        return ResponseEntity.ok(new HashMap<>());
    }

    // ═══════════════════════════════════════════════════════
    // Messages
    // ═══════════════════════════════════════════════════════

    @GetMapping("/api/v1/messages")
    public ResponseEntity<List<Map<String, Object>>> getMessages() {
        return ResponseEntity.ok(Collections.emptyList());
    }

    @PostMapping("/api/v1/messages")
    public ResponseEntity<Map<String, Object>> sendMessage(@RequestBody(required = false) Map<String, Object> body) {
        return ResponseEntity.ok(new HashMap<>());
    }

    // ═══════════════════════════════════════════════════════
    // Dashboard / Leaderboard / Badges
    // ═══════════════════════════════════════════════════════

    @GetMapping("/api/v1/dashboard/metrics")
    public ResponseEntity<Map<String, Object>> getDashboardMetrics() {
        return ResponseEntity.ok(Map.of(
                "activeAlerts", 0,
                "petsFound", 0,
                "communityMembers", 0,
                "sightingsToday", 0
        ));
    }

    @GetMapping("/api/v1/leaderboard")
    public ResponseEntity<List<Map<String, Object>>> getLeaderboard() {
        return ResponseEntity.ok(Collections.emptyList());
    }

    @GetMapping("/api/v1/badges")
    public ResponseEntity<List<Map<String, Object>>> getBadges() {
        return ResponseEntity.ok(Collections.emptyList());
    }

    // ═══════════════════════════════════════════════════════
    // Rewards / Media / Matching / Notifications
    // ═══════════════════════════════════════════════════════

    @GetMapping("/api/v1/rewards")
    public ResponseEntity<List<Map<String, Object>>> getRewards() {
        return ResponseEntity.ok(Collections.emptyList());
    }

    @PostMapping("/api/v1/rewards")
    public ResponseEntity<Map<String, Object>> createReward(@RequestBody(required = false) Map<String, Object> body) {
        return ResponseEntity.ok(new HashMap<>());
    }

    @PostMapping("/api/v1/media/upload")
    public ResponseEntity<Map<String, Object>> uploadMedia(@RequestBody(required = false) Map<String, Object> body) {
        return ResponseEntity.ok(Map.of("url", ""));
    }

    @GetMapping("/api/v1/matching")
    public ResponseEntity<List<Map<String, Object>>> getMatches() {
        return ResponseEntity.ok(Collections.emptyList());
    }

    @GetMapping("/api/v1/notifications")
    public ResponseEntity<List<Map<String, Object>>> getNotifications() {
        return ResponseEntity.ok(Collections.emptyList());
    }
}
