package com.pawfinder.alert.entity;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.JdbcTypeCode;
import org.hibernate.type.SqlTypes;
import org.locationtech.jts.geom.Point;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.UUID;

@Entity
@Table(name = "alerts")
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Alert {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @Column(name = "pet_id", nullable = false)
    private UUID petId;

    @Column(name = "owner_id", nullable = false)
    private UUID ownerId;

    @Builder.Default
    @Column(nullable = false, length = 20)
    private String status = "active";

    @Column(name = "last_seen_location", columnDefinition = "GEOGRAPHY(Point,4326)")
    @JdbcTypeCode(SqlTypes.GEOGRAPHY)
    private Point lastSeenLocation;

    @Column(name = "last_seen_address", columnDefinition = "TEXT")
    private String lastSeenAddress;

    @Column(name = "last_seen_timestamp")
    private LocalDateTime lastSeenTimestamp;

    @Column(columnDefinition = "TEXT")
    private String description;

    @Column(name = "reward_amount", precision = 10, scale = 2)
    private BigDecimal rewardAmount;

    @Builder.Default
    @Column(name = "reward_currency", length = 3)
    private String rewardCurrency = "USD";

    @Builder.Default
    @Column(name = "reward_claimed")
    private boolean rewardClaimed = false;

    @Builder.Default
    @Column(name = "geofence_radius_km")
    private int geofenceRadiusKm = 2;

    @Builder.Default
    @Column(name = "view_count")
    private int viewCount = 0;

    @Builder.Default
    @Column(name = "created_at")
    private LocalDateTime createdAt = LocalDateTime.now();

    @Column(name = "expires_at")
    private LocalDateTime expiresAt;

    @Column(name = "resolved_at")
    private LocalDateTime resolvedAt;

    @PrePersist
    public void prePersist() {
        if (createdAt == null) {
            createdAt = LocalDateTime.now();
        }
        if (expiresAt == null) {
            expiresAt = createdAt.plusDays(30);
        }
    }
}
