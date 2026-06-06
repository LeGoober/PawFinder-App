package com.pawfinder.shared.dto;

import lombok.*;

import java.math.BigDecimal;
import java.time.LocalDate;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class DashboardMetricsDTO {

    private LocalDate date;

    private int activeAlerts;

    private int newAlerts;

    private int resolvedAlerts;

    private BigDecimal avgResolutionHours;

    private BigDecimal totalRewardsOffered;

    private BigDecimal totalRewardsClaimed;
}
