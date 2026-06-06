package com.pawfinder.messaging.entity;

import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;
import java.util.UUID;

@Entity
@Table(name = "conversations")
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Conversation {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @Column(name = "alert_id")
    private UUID alertId;

    @Column(name = "owner_id", nullable = false)
    private UUID ownerId;

    @Column(name = "finder_id", nullable = false)
    private UUID finderId;

    @Column(name = "sighting_id")
    private UUID sightingId;

    @Builder.Default
    @Column(nullable = false, length = 20)
    private String status = "open";

    @Builder.Default
    @Column(name = "created_at")
    private LocalDateTime createdAt = LocalDateTime.now();

    @Column(name = "closed_at")
    private LocalDateTime closedAt;
}
