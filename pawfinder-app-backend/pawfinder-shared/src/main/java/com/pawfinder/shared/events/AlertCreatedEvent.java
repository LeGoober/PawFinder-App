package com.pawfinder.shared.events;

import lombok.*;

import java.io.Serializable;
import java.time.LocalDateTime;
import java.util.UUID;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class AlertCreatedEvent implements Serializable {

    private static final long serialVersionUID = 1L;

    private UUID alertId;

    private UUID ownerId;

    private double lat;

    private double lng;

    private int radiusKm;

    private LocalDateTime createdAt;

    private String species;
}
