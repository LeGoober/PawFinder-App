package com.pawfinder.shared.domain;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.JdbcTypeCode;
import org.hibernate.type.SqlTypes;

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

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "owner_id", nullable = false)
    private User owner;

    @Column(name = "owner_id", insertable = false, updatable = false)
    private UUID ownerId;

    private String name;

    private String species;

    private String breed;

    private String color;

    private String size;

    @Column(name = "distinguishing_features", columnDefinition = "TEXT")
    private String distinguishingFeatures;

    @Column(name = "temperament_notes", columnDefinition = "TEXT")
    private String temperamentNotes;

    @Column(name = "medical_needs", columnDefinition = "TEXT")
    private String medicalNeeds;

    @JdbcTypeCode(SqlTypes.JSON)
    @Column(columnDefinition = "JSONB")
    private String photos;

    @Column(name = "qr_code_id", unique = true)
    private String qrCodeId;

    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt;

    @PrePersist
    protected void onCreate() {
        if (createdAt == null) {
            createdAt = LocalDateTime.now();
        }
    }
}
