package com.pawfinder.shared.domain;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.Type;
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

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "pet_id", nullable = false)
    private Pet pet;

    @Column(name = "pet_id", insertable = false, updatable = false)
    private UUID petId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "owner_id", nullable = false)
    private User owner;

    @Column(name = "owner_id", insertable = false, updatable = false)
    private UUID ownerId;

    @Column(nullable = false)
    @Builder.Default
    private String status = "active";

    @Type(value = org.hibernate.spatial.JTSGeometryType.class)
    @Column(name = "last_seen_location", columnDefinition = "GEOGRAPHY(Point,4326)")
    private Point lastSeenLocation;

    @Column(name = "last_seen_address")
    private String lastSeenAddress;

    @Column(name = "last_seen_timestamp")
    private LocalDateTime lastSeenTimestamp;

    @Column(columnDefinition = "TEXT")
    private String description;

    @Column(name = "reward_amount", precision = 10, scale = 2)
    private BigDecimal rewardAmount;

    @Column(name = "reward_currency", length = 3)
    @Builder.Default
    private String rewardCurrency = "USD";

    @Column(name = "reward_claimed", nullable = false)
    @Builder.Default
    private boolean rewardClaimed = false;

    @Column(name = "geofence_radius_km", nullable = false)
    @Builder.Default
    private int geofenceRadiusKm = 2;

    @Column(name = "view_count", nullable = false)
    @Builder.Default
    private int viewCount = 0;

    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt;

    @Column(name = "expires_at")
    private LocalDateTime expiresAt;

    @Column(name = "resolved_at")
    private LocalDateTime resolvedAt;

    @PrePersist
    protected void onCreate() {
        if (createdAt == null) {
            createdAt = LocalDateTime.now();
        }
        if (expiresAt == null) {
            expiresAt = createdAt.plusDays(30);
        }
    }
}
