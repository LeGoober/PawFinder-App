package com.pawfinder.shared.dto;

import com.fasterxml.jackson.annotation.JsonFormat;
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

    private String petName;

    private String species;

    private String status;

    private String lastSeenAddress;

    private String description;

    private BigDecimal rewardAmount;

    private String rewardCurrency;

    private int geofenceRadiusKm;

    private int viewCount;

    @JsonFormat(pattern = "yyyy-MM-dd'T'HH:mm:ss")
    private LocalDateTime createdAt;

    @JsonFormat(pattern = "yyyy-MM-dd'T'HH:mm:ss")
    private LocalDateTime expiresAt;

    private double fuzzedLat;

    private double fuzzedLng;
}
