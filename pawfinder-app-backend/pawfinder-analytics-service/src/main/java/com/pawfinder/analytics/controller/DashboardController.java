package com.pawfinder.analytics.controller;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/v1")
public class DashboardController {

    /**
     * Get platform-wide metrics (active alerts, resolutions, users, rewards).
     * TODO: Query daily_metrics table and return real data.
     */
    @GetMapping("/dashboard/metrics")
    public ResponseEntity<Map<String, Object>> getDashboardMetrics() {
        return ResponseEntity.ok(Map.of(
                "activeAlerts", 0,
                "newAlerts", 0,
                "resolvedAlerts", 0,
                "avgResolutionHours", 0.0,
                "totalRewardsOffered", 0.0,
                "totalRewardsClaimed", 0.0,
                "newUsers", 0,
                "activeUsers", 0
        ));
    }

    /**
     * Get geospatial heatmap data for lost-pet activity.
     * TODO: Aggregate alert locations by region and return density data.
     */
    @GetMapping("/dashboard/heatmap")
    public ResponseEntity<List<Map<String, Object>>> getHeatmap() {
        return ResponseEntity.ok(List.of());
    }

    /**
     * Get community leaderboard (top contributors by alerts resolved).
     * TODO: Query user rankings based on resolved alerts.
     */
    @GetMapping("/leaderboard")
    public ResponseEntity<List<Map<String, Object>>> getLeaderboard() {
        return ResponseEntity.ok(List.of());
    }

    /**
     * Get badge/achievement definitions and user progress.
     * TODO: Return badge catalog with user completion status.
     */
    @GetMapping("/badges")
    public ResponseEntity<List<Map<String, Object>>> getBadges() {
        return ResponseEntity.ok(List.of());
    }
}
