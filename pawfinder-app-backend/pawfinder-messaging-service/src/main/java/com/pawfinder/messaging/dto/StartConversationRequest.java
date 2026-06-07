package com.pawfinder.messaging.dto;

import jakarta.validation.constraints.NotNull;
import lombok.*;

import java.util.UUID;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class StartConversationRequest {
    @NotNull
    private UUID alertId;
    private UUID sightingId;
}
