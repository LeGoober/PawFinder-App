package com.pawfinder.alert.controller;

import com.pawfinder.alert.dto.ReportSightingRequest;
import com.pawfinder.alert.dto.SightingDTO;
import com.pawfinder.alert.service.SightingService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/v1/sightings")
@RequiredArgsConstructor
@Tag(name = "Sightings", description = "Pet sighting report management endpoints")
public class SightingController {

    private final SightingService sightingService;

    @PostMapping
    @Operation(summary = "Report a pet sighting")
    @ApiResponses({
        @ApiResponse(responseCode = "201", description = "Sighting reported"),
        @ApiResponse(responseCode = "404", description = "Alert not found")
    })
    public ResponseEntity<SightingDTO> reportSighting(
            @Valid @RequestBody ReportSightingRequest request,
            Authentication authentication) {
        UUID finderId = UUID.fromString(authentication.getName());
        SightingDTO sighting = sightingService.reportSighting(
                finderId,
                request.getAlertId(),
                request.getLatitude(),
                request.getLongitude(),
                request.getNotes(),
                request.getPhotoUrls()
        );
        return ResponseEntity.status(HttpStatus.CREATED).body(sighting);
    }

    @GetMapping("/alert/{alertId}")
    @Operation(summary = "Get all sightings for an alert")
    @ApiResponse(responseCode = "200", description = "Sightings retrieved")
    public ResponseEntity<List<SightingDTO>> getSightingsForAlert(
            @PathVariable UUID alertId) {
        List<SightingDTO> sightings = sightingService.getSightingsForAlert(alertId);
        return ResponseEntity.ok(sightings);
    }

    @GetMapping("/{id}")
    @Operation(summary = "Get sighting details by ID")
    @ApiResponses({
        @ApiResponse(responseCode = "200", description = "Sighting found"),
        @ApiResponse(responseCode = "404", description = "Sighting not found")
    })
    public ResponseEntity<SightingDTO> getSightingById(@PathVariable UUID id) {
        SightingDTO sighting = sightingService.getSightingById(id);
        return ResponseEntity.ok(sighting);
    }

    @PutMapping("/{id}/confirm")
    @Operation(summary = "Confirm a sighting (owner only)")
    @ApiResponses({
        @ApiResponse(responseCode = "200", description = "Sighting confirmed"),
        @ApiResponse(responseCode = "403", description = "Not the alert owner"),
        @ApiResponse(responseCode = "404", description = "Sighting not found")
    })
    public ResponseEntity<SightingDTO> confirmSighting(
            @PathVariable UUID id,
            Authentication authentication) {
        UUID ownerId = UUID.fromString(authentication.getName());
        SightingDTO sighting = sightingService.confirmSighting(id, ownerId);
        return ResponseEntity.ok(sighting);
    }

    @PutMapping("/{id}/reject")
    @Operation(summary = "Reject a sighting (owner only)")
    @ApiResponses({
        @ApiResponse(responseCode = "200", description = "Sighting rejected"),
        @ApiResponse(responseCode = "403", description = "Not the alert owner"),
        @ApiResponse(responseCode = "404", description = "Sighting not found")
    })
    public ResponseEntity<SightingDTO> rejectSighting(
            @PathVariable UUID id,
            Authentication authentication) {
        UUID ownerId = UUID.fromString(authentication.getName());
        SightingDTO sighting = sightingService.rejectSighting(id, ownerId);
        return ResponseEntity.ok(sighting);
    }
}
