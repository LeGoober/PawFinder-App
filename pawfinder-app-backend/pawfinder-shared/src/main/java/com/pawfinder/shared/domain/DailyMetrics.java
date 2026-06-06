package com.pawfinder.shared.domain;

import jakarta.persistence.*;
import lombok.*;

import java.math.BigDecimal;
import java.time.LocalDate;

@Entity
@Table(name = "daily_metrics")
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class DailyMetrics {

    @Id
    private LocalDate date;

    @Column(name = "active_alerts", nullable = false)
    private int activeAlerts;

    @Column(name = "new_alerts", nullable = false)
    private int newAlerts;

    @Column(name = "resolved_alerts", nullable = false)
    private int resolvedAlerts;

    @Column(name = "avg_resolution_hours", precision = 10, scale = 2)
    private BigDecimal avgResolutionHours;

    @Column(name = "total_rewards_offered", precision = 15, scale = 2)
    private BigDecimal totalRewardsOffered;

    @Column(name = "total_rewards_claimed", precision = 15, scale = 2)
    private BigDecimal totalRewardsClaimed;

    @Column(name = "new_users", nullable = false)
    private int newUsers;

    @Column(name = "active_users", nullable = false)
    private int activeUsers;
}
