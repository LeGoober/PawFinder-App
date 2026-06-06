package com.pawfinder.alert.entity;

import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;
import java.util.UUID;

@Entity
@Table(name = "pets")
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Pet {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @Column(name = "owner_id", nullable = false)
    private UUID ownerId;

    @Column(length = 100)
    private String name;

    @Column(length = 50)
    private String species;

    @Column(length = 100)
    private String breed;

    @Column(length = 100)
    private String color;

    @Column(length = 20)
    private String size;

    @Column(name = "distinguishing_features", columnDefinition = "TEXT")
    private String distinguishingFeatures;

    @Column(name = "temperament_notes", columnDefinition = "TEXT")
    private String temperamentNotes;

    @Column(name = "medical_needs", columnDefinition = "TEXT")
    private String medicalNeeds;

    @Column(columnDefinition = "jsonb")
    private String photos;

    @Column(name = "qr_code_id", unique = true, length = 255)
    private String qrCodeId;

    @Builder.Default
    @Column(name = "created_at")
    private LocalDateTime createdAt = LocalDateTime.now();
}
