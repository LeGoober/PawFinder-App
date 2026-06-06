package com.pawfinder.shared.dto;

import lombok.*;

import java.util.UUID;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class PetDTO {

    private UUID id;

    private UUID ownerId;

    private String name;

    private String species;

    private String breed;

    private String color;

    private String size;

    private String distinguishingFeatures;

    private String photos;

    private String qrCodeId;
}
