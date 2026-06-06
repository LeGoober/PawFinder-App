package com.pawfinder.shared.dto;

import jakarta.validation.constraints.DecimalMax;
import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.*;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.UUID;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class CreateAlertRequest {

    @NotNull(message = "Pet ID is required")
    private UUID petId;

    @DecimalMin(value = "-90.0", message = "Latitude must be between -90 and 90")
    @DecimalMax(value = "90.0", message = "Latitude must be between -90 and 90")
    private double lastSeenLat;

    @DecimalMin(value = "-180.0", message = "Longitude must be between -180 and 180")
    @DecimalMax(value = "180.0", message = "Longitude must be between -180 and 180")
    private double lastSeenLng;

    private String lastSeenAddress;

    private LocalDateTime lastSeenTimestamp;

    @NotBlank(message = "Description is required")
    private String description;

    private BigDecimal rewardAmount;

    @Builder.Default
    private int geofenceRadiusKm = 2;
}
