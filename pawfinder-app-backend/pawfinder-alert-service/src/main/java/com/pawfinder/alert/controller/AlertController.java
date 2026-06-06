package com.pawfinder.alert.controller;

import com.pawfinder.alert.dto.AlertDTO;
import com.pawfinder.alert.dto.CreateAlertRequest;
import com.pawfinder.alert.service.AlertService;
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
import java.util.Map;
import java.util.UUID;

@RestController
@RequestMapping("/api/v1/alerts")
@RequiredArgsConstructor
@Tag(name = "Alerts", description = "Lost pet alert management endpoints")
public class AlertController {

    private final AlertService alertService;

    @PostMapping
    @Operation(summary = "Create a new lost pet alert")
    @ApiResponses({
        @ApiResponse(responseCode = "201", description = "Alert created successfully"),
        @ApiResponse(responseCode = "429", description = "Rate limit exceeded - max 3 active alerts")
    })
    public ResponseEntity<AlertDTO> createAlert(
            @Valid @RequestBody CreateAlertRequest request,
            Authentication authentication) {
        UUID ownerId = UUID.fromString(authentication.getName());
        AlertDTO alert = alertService.createAlert(ownerId, request);
        return ResponseEntity.status(HttpStatus.CREATED).body(alert);
    }

    @GetMapping("/nearby")
    @Operation(summary = "Find nearby lost pet alerts")
    @ApiResponses({
        @ApiResponse(responseCode = "200", description = "Nearby alerts retrieved")
    })
    public ResponseEntity<List<AlertDTO>> getNearbyAlerts(
            @RequestParam double lat,
            @RequestParam double lng,
            @RequestParam(defaultValue = "10") double radius) {
        List<AlertDTO> alerts = alertService.getNearbyAlerts(lat, lng, radius);
        return ResponseEntity.ok(alerts);
    }

    @GetMapping("/{id}")
    @Operation(summary = "Get alert details by ID")
    @ApiResponses({
        @ApiResponse(responseCode = "200", description = "Alert found"),
        @ApiResponse(responseCode = "404", description = "Alert not found")
    })
    public ResponseEntity<AlertDTO> getAlertById(@PathVariable UUID id) {
        AlertDTO alert = alertService.getAlertById(id);
        return ResponseEntity.ok(alert);
    }

    @PutMapping("/{id}/resolve")
    @Operation(summary = "Mark an alert as resolved")
    @ApiResponses({
        @ApiResponse(responseCode = "200", description = "Alert resolved"),
        @ApiResponse(responseCode = "403", description = "Not the alert owner"),
        @ApiResponse(responseCode = "404", description = "Alert not found")
    })
    public ResponseEntity<AlertDTO> resolveAlert(
            @PathVariable UUID id,
            Authentication authentication) {
        UUID ownerId = UUID.fromString(authentication.getName());
        AlertDTO alert = alertService.resolveAlert(id, ownerId);
        return ResponseEntity.ok(alert);
    }

    @DeleteMapping("/{id}")
    @Operation(summary = "Cancel an alert")
    @ApiResponses({
        @ApiResponse(responseCode = "204", description = "Alert cancelled"),
        @ApiResponse(responseCode = "403", description = "Not the alert owner"),
        @ApiResponse(responseCode = "404", description = "Alert not found")
    })
    public ResponseEntity<Void> cancelAlert(
            @PathVariable UUID id,
            Authentication authentication) {
        UUID ownerId = UUID.fromString(authentication.getName());
        alertService.cancelAlert(id, ownerId);
        return ResponseEntity.noContent().build();
    }

    @PostMapping("/{id}/boost")
    @Operation(summary = "Boost alert visibility (stub)")
    @ApiResponse(responseCode = "200", description = "Boost acknowledged")
    public ResponseEntity<Map<String, String>> boostAlert(@PathVariable UUID id) {
        return ResponseEntity.ok(Map.of(
                "message", "Boost requested for alert " + id,
                "status", "acknowledged"
        ));
    }
}
