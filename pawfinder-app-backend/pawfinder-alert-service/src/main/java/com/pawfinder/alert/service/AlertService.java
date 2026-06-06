package com.pawfinder.alert.service;

import com.pawfinder.alert.dto.AlertDTO;
import com.pawfinder.alert.dto.CreateAlertRequest;
import com.pawfinder.alert.dto.PetDTO;
import com.pawfinder.alert.entity.Alert;
import com.pawfinder.alert.entity.Pet;
import com.pawfinder.alert.exception.RateLimitExceededException;
import com.pawfinder.alert.repository.AlertRepository;
import com.pawfinder.alert.repository.PetRepository;
import com.pawfinder.alert.repository.SightingRepository;
import jakarta.persistence.EntityNotFoundException;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.locationtech.jts.geom.Point;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

@Service
@Transactional
@RequiredArgsConstructor
@Slf4j
public class AlertService {

    private static final int MAX_ACTIVE_ALERTS = 3;

    private final AlertRepository alertRepository;
    private final PetRepository petRepository;
    private final SightingRepository sightingRepository;
    private final GeoUtils geoUtils;

    public AlertDTO createAlert(UUID ownerId, CreateAlertRequest request) {
        long activeCount = alertRepository.countByOwnerIdAndStatus(ownerId, "active");
        if (activeCount >= MAX_ACTIVE_ALERTS) {
            throw new RateLimitExceededException(
                    "You have reached the maximum of " + MAX_ACTIVE_ALERTS + " active alerts. " +
                    "Please resolve or cancel an existing alert before creating a new one.");
        }

        Pet pet = resolvePet(ownerId, request);

        Point location = geoUtils.createPoint(request.getLatitude(), request.getLongitude());

        Alert alert = Alert.builder()
                .petId(pet.getId())
                .ownerId(ownerId)
                .status("active")
                .lastSeenLocation(location)
                .lastSeenAddress(request.getLastSeenAddress())
                .lastSeenTimestamp(LocalDateTime.now())
                .description(request.getDescription())
                .rewardAmount(request.getRewardAmount())
                .rewardCurrency(request.getRewardCurrency() != null
                        ? request.getRewardCurrency() : "USD")
                .rewardClaimed(false)
                .geofenceRadiusKm(request.getGeofenceRadiusKm() > 0
                        ? request.getGeofenceRadiusKm() : 2)
                .viewCount(0)
                .createdAt(LocalDateTime.now())
                .expiresAt(LocalDateTime.now().plusDays(30))
                .build();

        alert = alertRepository.save(alert);
        log.info("Alert created: id={}, ownerId={}, petId={}", alert.getId(), ownerId, pet.getId());

        return toAlertDTO(alert, pet);
    }

    private Pet resolvePet(UUID ownerId, CreateAlertRequest request) {
        if (request.getPetId() != null) {
            return petRepository.findById(request.getPetId())
                    .orElseThrow(() -> new EntityNotFoundException(
                            "Pet not found with id: " + request.getPetId()));
        }

        Pet pet = Pet.builder()
                .ownerId(ownerId)
                .name(request.getPetName())
                .species(request.getPetSpecies())
                .breed(request.getPetBreed())
                .color(request.getPetColor())
                .size(request.getPetSize())
                .distinguishingFeatures(request.getPetDistinguishingFeatures())
                .temperamentNotes(request.getPetTemperamentNotes())
                .medicalNeeds(request.getPetMedicalNeeds())
                .photos(request.getPetPhotos())
                .qrCodeId(request.getPetQrCodeId())
                .createdAt(LocalDateTime.now())
                .build();

        return petRepository.save(pet);
    }

    @Transactional(readOnly = true)
    public List<AlertDTO> getNearbyAlerts(double lat, double lng, double radiusKm) {
        double radiusMeters = radiusKm * 1000.0;
        List<Alert> alerts = alertRepository.findNearbyAlerts(lat, lng, radiusMeters);

        return alerts.stream()
                .map(alert -> {
                    Pet pet = petRepository.findById(alert.getPetId()).orElse(null);
                    return toAlertDTO(alert, pet);
                })
                .collect(Collectors.toList());
    }

    @Transactional
    public AlertDTO getAlertById(UUID alertId) {
        Alert alert = alertRepository.findById(alertId)
                .orElseThrow(() -> new EntityNotFoundException(
                        "Alert not found with id: " + alertId));

        alert.setViewCount(alert.getViewCount() + 1);
        alertRepository.save(alert);

        Pet pet = petRepository.findById(alert.getPetId()).orElse(null);
        return toAlertDTO(alert, pet);
    }

    @Transactional
    public AlertDTO resolveAlert(UUID alertId, UUID ownerId) {
        Alert alert = alertRepository.findById(alertId)
                .orElseThrow(() -> new EntityNotFoundException(
                        "Alert not found with id: " + alertId));

        if (!alert.getOwnerId().equals(ownerId)) {
            throw new SecurityException("You do not own this alert");
        }

        alert.setStatus("resolved");
        alert.setResolvedAt(LocalDateTime.now());
        alertRepository.save(alert);

        Pet pet = petRepository.findById(alert.getPetId()).orElse(null);
        log.info("Alert resolved: id={}, ownerId={}", alertId, ownerId);
        return toAlertDTO(alert, pet);
    }

    @Transactional
    public void cancelAlert(UUID alertId, UUID ownerId) {
        Alert alert = alertRepository.findById(alertId)
                .orElseThrow(() -> new EntityNotFoundException(
                        "Alert not found with id: " + alertId));

        if (!alert.getOwnerId().equals(ownerId)) {
            throw new SecurityException("You do not own this alert");
        }

        alert.setStatus("cancelled");
        alertRepository.save(alert);
        log.info("Alert cancelled: id={}, ownerId={}", alertId, ownerId);
    }

    @Scheduled(cron = "0 0 4 * * *")
    @Transactional
    public void expireOldAlerts() {
        List<Alert> expiredAlerts = alertRepository
                .findByStatusAndExpiresAtBefore("active", LocalDateTime.now());

        for (Alert alert : expiredAlerts) {
            alert.setStatus("expired");
            alertRepository.save(alert);
            log.info("Alert expired: id={}", alert.getId());
        }

        if (!expiredAlerts.isEmpty()) {
            log.info("Expired {} alerts", expiredAlerts.size());
        }
    }

    private AlertDTO toAlertDTO(Alert alert, Pet pet) {
        double[] coords = geoUtils.pointToLatLng(alert.getLastSeenLocation());
        Double lat = coords != null ? geoUtils.fuzzCoordinate(coords[0]) : null;
        Double lng = coords != null ? geoUtils.fuzzCoordinate(coords[1]) : null;

        PetDTO petDTO = null;
        if (pet != null) {
            petDTO = PetDTO.builder()
                    .id(pet.getId())
                    .ownerId(pet.getOwnerId())
                    .name(pet.getName())
                    .species(pet.getSpecies())
                    .breed(pet.getBreed())
                    .color(pet.getColor())
                    .size(pet.getSize())
                    .distinguishingFeatures(pet.getDistinguishingFeatures())
                    .temperamentNotes(pet.getTemperamentNotes())
                    .medicalNeeds(pet.getMedicalNeeds())
                    .photos(pet.getPhotos())
                    .qrCodeId(pet.getQrCodeId())
                    .createdAt(pet.getCreatedAt())
                    .build();
        }

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
                .pet(petDTO)
                .build();
    }
}
