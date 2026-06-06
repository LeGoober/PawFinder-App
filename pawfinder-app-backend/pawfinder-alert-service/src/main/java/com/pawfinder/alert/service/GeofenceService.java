package com.pawfinder.alert.service;

import com.pawfinder.alert.dto.AlertDTO;
import com.pawfinder.alert.entity.Alert;
import com.pawfinder.alert.entity.Pet;
import com.pawfinder.alert.repository.AlertRepository;
import com.pawfinder.alert.repository.PetRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Slf4j
public class GeofenceService {

    private final AlertRepository alertRepository;
    private final PetRepository petRepository;
    private final GeoUtils geoUtils;

    @Transactional(readOnly = true)
    public List<AlertDTO> findAlertsInRadius(double lat, double lng, double radiusKm) {
        double radiusMeters = radiusKm * 1000.0;
        List<Alert> alerts = alertRepository.findNearbyAlerts(lat, lng, radiusMeters);

        return alerts.stream()
                .map(alert -> {
                    Pet pet = petRepository.findById(alert.getPetId()).orElse(null);
                    return mapToDTO(alert, pet);
                })
                .collect(Collectors.toList());
    }

    @Transactional(readOnly = true)
    public boolean isAlertInUserArea(UUID alertId, double userLat, double userLng) {
        return alertRepository.findById(alertId)
                .map(alert -> {
                    double[] coords = geoUtils.pointToLatLng(alert.getLastSeenLocation());
                    if (coords == null) return false;
                    double distanceKm = geoUtils.calculateDistanceKm(
                            userLat, userLng, coords[0], coords[1]);
                    return distanceKm <= alert.getGeofenceRadiusKm();
                })
                .orElse(false);
    }

    private AlertDTO mapToDTO(Alert alert, Pet pet) {
        double[] coords = geoUtils.pointToLatLng(alert.getLastSeenLocation());
        Double lat = coords != null ? coords[0] : null;
        Double lng = coords != null ? coords[1] : null;

        return AlertDTO.builder()
                .id(alert.getId())
                .petId(alert.getPetId())
                .ownerId(alert.getOwnerId())
                .status(alert.getStatus())
                .latitude(lat)
                .longitude(lng)
                .lastSeenAddress(alert.getLastSeenAddress())
                .lastSeenTimestamp(alert.getLastSeenTimestamp())
                .description(alert.getDescription())
                .rewardAmount(alert.getRewardAmount())
                .rewardCurrency(alert.getRewardCurrency())
                .rewardClaimed(alert.isRewardClaimed())
                .geofenceRadiusKm(alert.getGeofenceRadiusKm())
                .viewCount(alert.getViewCount())
                .createdAt(alert.getCreatedAt())
                .expiresAt(alert.getExpiresAt())
                .resolvedAt(alert.getResolvedAt())
                .build();
    }
}
