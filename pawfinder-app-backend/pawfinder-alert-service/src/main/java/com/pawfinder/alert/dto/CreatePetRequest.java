package com.pawfinder.alert.dto;

import lombok.*;

import java.time.LocalDateTime;
import java.util.UUID;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class CreatePetRequest {
    private String name;
    private String species;
    private String breed;
    private String color;
    private String size;
    private String distinguishingFeatures;
    private String temperamentNotes;
    private String medicalNeeds;
    private String photos;
    private String qrCodeId;
}
