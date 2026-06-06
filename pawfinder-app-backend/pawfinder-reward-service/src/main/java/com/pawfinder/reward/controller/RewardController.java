package com.pawfinder.reward.controller;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/api/v1/rewards")
public class RewardController {

    /**
     * Claim a reward for successfully finding a lost pet.
     * TODO: Validate claim eligibility, initiate Stripe payout.
     */
    @PostMapping("/{id}/claim")
    public ResponseEntity<Map<String, Object>> claimReward(@PathVariable Long id) {
        return ResponseEntity.accepted().body(Map.of(
                "rewardId", id,
                "status", "CLAIM_INITIATED",
                "message", "Reward claim submitted for processing"
        ));
    }

    /**
     * Confirm a reward claim after verification.
     * TODO: Admin/owner confirms the find, triggers payout.
     */
    @PostMapping("/{id}/confirm")
    public ResponseEntity<Map<String, Object>> confirmReward(@PathVariable Long id) {
        return ResponseEntity.ok(Map.of(
                "rewardId", id,
                "status", "CONFIRMED",
                "message", "Reward confirmed and payout initiated"
        ));
    }

    /**
     * Get the status of a reward claim.
     */
    @GetMapping("/{id}/status")
    public ResponseEntity<Map<String, Object>> getRewardStatus(@PathVariable Long id) {
        return ResponseEntity.ok(Map.of(
                "rewardId", id,
                "status", "PENDING",
                "amount", 0.00,
                "currency", "ZAR"
        ));
    }
}
