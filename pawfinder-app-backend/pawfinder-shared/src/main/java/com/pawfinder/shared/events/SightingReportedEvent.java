package com.pawfinder.shared.events;

import lombok.*;

import java.io.Serializable;
import java.time.LocalDateTime;
import java.util.UUID;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class SightingReportedEvent implements Serializable {

    private static final long serialVersionUID = 1L;

    private UUID sightingId;

    private UUID alertId;

    private UUID finderId;

    private UUID ownerId;

    private LocalDateTime createdAt;
}
