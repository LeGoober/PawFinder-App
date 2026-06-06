package com.pawfinder.alert.dto;

import lombok.*;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.UUID;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class AlertDTO {
    private UUID id;
    private UUID petId;
    private UUID ownerId;
    private String status;
    private Double latitude;
    private Double longitude;
    private String lastSeenAddress;
    private LocalDateTime lastSeenTimestamp;
    private String description;
    private BigDecimal rewardAmount;
    private String rewardCurrency;
    private boolean rewardClaimed;
    private int geofenceRadiusKm;
    private int viewCount;
    private LocalDateTime createdAt;
    private LocalDateTime expiresAt;
    private LocalDateTime resolvedAt;
    private PetDTO pet;
}
