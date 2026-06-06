package com.pawfinder.alert.repository;

import com.pawfinder.alert.entity.Alert;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

@Repository
public interface AlertRepository extends JpaRepository<Alert, UUID> {

    @Query(value = """
        SELECT a.* FROM alerts a
        WHERE a.status = 'active'
          AND a.last_seen_location IS NOT NULL
          AND ST_DWithin(
                a.last_seen_location,
                ST_SetSRID(ST_MakePoint(:lng, :lat), 4326),
                :radiusMeters
              )
        ORDER BY a.created_at DESC
        """, nativeQuery = true)
    List<Alert> findNearbyAlerts(@Param("lat") double lat,
                                  @Param("lng") double lng,
                                  @Param("radiusMeters") double radiusMeters);

    List<Alert> findByOwnerId(UUID ownerId);

    List<Alert> findByStatus(String status);

    List<Alert> findByStatusAndExpiresAtBefore(String status, LocalDateTime dateTime);

    long countByOwnerIdAndStatus(UUID ownerId, String status);
}
