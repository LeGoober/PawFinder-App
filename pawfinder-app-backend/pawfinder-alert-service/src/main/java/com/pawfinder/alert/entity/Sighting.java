package com.pawfinder.alert.entity;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.JdbcTypeCode;
import org.hibernate.type.SqlTypes;
import org.locationtech.jts.geom.Point;

import java.time.LocalDateTime;
import java.util.UUID;

@Entity
@Table(name = "sightings")
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Sighting {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @Column(name = "alert_id", nullable = false)
    private UUID alertId;

    @Column(name = "finder_id", nullable = false)
    private UUID finderId;

    @Column(columnDefinition = "GEOGRAPHY(Point,4326)")
    @JdbcTypeCode(SqlTypes.GEOGRAPHY)
    private Point location;

    @Column(name = "photo_urls", columnDefinition = "jsonb")
    private String photoUrls;

    @Column(columnDefinition = "TEXT")
    private String notes;

    @Builder.Default
    @Column(nullable = false, length = 20)
    private String status = "pending";

    @Builder.Default
    @Column(name = "created_at")
    private LocalDateTime createdAt = LocalDateTime.now();
}
