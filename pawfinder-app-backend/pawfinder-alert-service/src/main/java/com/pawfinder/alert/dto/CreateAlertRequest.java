package com.pawfinder.alert.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.*;

import java.math.BigDecimal;
import java.util.UUID;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class CreateAlertRequest {

    private UUID petId;

    private String petName;
    private String petSpecies;
    private String petBreed;
    private String petColor;
    private String petSize;
    private String petDistinguishingFeatures;
    private String petTemperamentNotes;
    private String petMedicalNeeds;
    private String petPhotos;
    private String petQrCodeId;

    @NotNull
    private Double latitude;

    @NotNull
    private Double longitude;

    private String lastSeenAddress;

    private String description;

    private BigDecimal rewardAmount;

    private String rewardCurrency;

    private int geofenceRadiusKm = 2;
}
