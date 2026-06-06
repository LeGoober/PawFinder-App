package com.pawfinder.alert.service;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.pawfinder.alert.dto.SightingDTO;
import com.pawfinder.alert.entity.Alert;
import com.pawfinder.alert.entity.Sighting;
import com.pawfinder.alert.repository.AlertRepository;
import com.pawfinder.alert.repository.SightingRepository;
import jakarta.persistence.EntityNotFoundException;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.locationtech.jts.geom.Point;
import org.springframework.amqp.rabbit.core.RabbitTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.Collections;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

@Service
@Transactional
@RequiredArgsConstructor
@Slf4j
public class SightingService {

    private final SightingRepository sightingRepository;
    private final AlertRepository alertRepository;
    private final GeoUtils geoUtils;
    private final ObjectMapper objectMapper;

    private final RabbitTemplate rabbitTemplate;

    @Transactional
    public SightingDTO reportSighting(UUID finderId, UUID alertId, double lat, double lng,
                                       String notes, List<String> photoUrls) {
        Alert alert = alertRepository.findById(alertId)
                .orElseThrow(() -> new EntityNotFoundException(
                        "Alert not found with id: " + alertId));

        if (!"active".equals(alert.getStatus())) {
            throw new IllegalStateException("Cannot report sighting for an alert that is not active");
        }

        Point location = geoUtils.createPoint(lat, lng);

        String photoUrlsJson = null;
        if (photoUrls != null && !photoUrls.isEmpty()) {
            try {
                photoUrlsJson = objectMapper.writeValueAsString(photoUrls);
            } catch (JsonProcessingException e) {
                log.warn("Failed to serialize photo URLs, storing as empty: {}", e.getMessage());
                photoUrlsJson = "[]";
            }
        }

        Sighting sighting = Sighting.builder()
                .alertId(alertId)
                .finderId(finderId)
                .location(location)
                .photoUrls(photoUrlsJson)
                .notes(notes)
                .status("pending")
                .createdAt(LocalDateTime.now())
                .build();

        sighting = sightingRepository.save(sighting);

        publishSightingEvent(sighting, alert);

        log.info("Sighting reported: id={}, alertId={}, finderId={}",
                sighting.getId(), alertId, finderId);

        return toSightingDTO(sighting);
    }

    private void publishSightingEvent(Sighting sighting, Alert alert) {
        try {
            rabbitTemplate.convertAndSend(
                    "pawfinder.sighting.exchange",
                    "sighting.reported",
                    sighting
            );
            log.debug("Published SightingReportedEvent for sighting id={}", sighting.getId());
        } catch (Exception e) {
            log.warn("Failed to publish sighting event to RabbitMQ (may not be configured): {}",
                    e.getMessage());
            log.info("Sighting id={} saved but event not published to broker", sighting.getId());
        }
    }

    @Transactional(readOnly = true)
    public SightingDTO getSightingById(UUID sightingId) {
        Sighting sighting = sightingRepository.findById(sightingId)
                .orElseThrow(() -> new EntityNotFoundException(
                        "Sighting not found with id: " + sightingId));
        return toSightingDTO(sighting);
    }

    @Transactional(readOnly = true)
    public List<SightingDTO> getSightingsForAlert(UUID alertId) {
        List<Sighting> sightings = sightingRepository.findByAlertId(alertId);

        return sightings.stream()
                .map(this::toSightingDTO)
                .collect(Collectors.toList());
    }

    @Transactional
    public SightingDTO confirmSighting(UUID sightingId, UUID ownerId) {
        Sighting sighting = sightingRepository.findById(sightingId)
                .orElseThrow(() -> new EntityNotFoundException(
                        "Sighting not found with id: " + sightingId));

        Alert alert = alertRepository.findById(sighting.getAlertId())
                .orElseThrow(() -> new EntityNotFoundException(
                        "Associated alert not found"));

        if (!alert.getOwnerId().equals(ownerId)) {
            throw new SecurityException("You do not own the alert associated with this sighting");
        }

        sighting.setStatus("confirmed");
        sightingRepository.save(sighting);

        log.info("Sighting confirmed: id={}, ownerId={}", sightingId, ownerId);
        return toSightingDTO(sighting);
    }

    @Transactional
    public SightingDTO rejectSighting(UUID sightingId, UUID ownerId) {
        Sighting sighting = sightingRepository.findById(sightingId)
                .orElseThrow(() -> new EntityNotFoundException(
                        "Sighting not found with id: " + sightingId));

        Alert alert = alertRepository.findById(sighting.getAlertId())
                .orElseThrow(() -> new EntityNotFoundException(
                        "Associated alert not found"));

        if (!alert.getOwnerId().equals(ownerId)) {
            throw new SecurityException("You do not own the alert associated with this sighting");
        }

        sighting.setStatus("rejected");
        sightingRepository.save(sighting);

        log.info("Sighting rejected: id={}, ownerId={}", sightingId, ownerId);
        return toSightingDTO(sighting);
    }

    private SightingDTO toSightingDTO(Sighting sighting) {
        double[] coords = geoUtils.pointToLatLng(sighting.getLocation());
        Double lat = coords != null ? geoUtils.fuzzCoordinate(coords[0]) : null;
        Double lng = coords != null ? geoUtils.fuzzCoordinate(coords[1]) : null;

        List<String> urls = Collections.emptyList();
        if (sighting.getPhotoUrls() != null) {
            try {
                urls = objectMapper.readValue(sighting.getPhotoUrls(),
                        new TypeReference<List<String>>() {});
            } catch (JsonProcessingException e) {
                log.warn("Failed to deserialize photo URLs for sighting id={}", sighting.getId());
            }
        }

        return SightingDTO.builder()
                .id(sighting.getId())
                .alertId(sighting.getAlertId())
                .finderId(sighting.getFinderId())
                .latitude(lat)
                .longitude(lng)
                .photoUrls(urls)
                .notes(sighting.getNotes())
                .status(sighting.getStatus())
                .createdAt(sighting.getCreatedAt())
                .build();
    }
}
