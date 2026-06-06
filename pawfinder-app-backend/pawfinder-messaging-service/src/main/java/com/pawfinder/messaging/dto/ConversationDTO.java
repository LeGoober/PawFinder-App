package com.pawfinder.messaging.dto;

import lombok.*;

import java.time.LocalDateTime;
import java.util.UUID;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ConversationDTO {
    private UUID id;
    private UUID alertId;
    private UUID ownerId;
    private UUID finderId;
    private UUID sightingId;
    private String status;
    private LocalDateTime createdAt;
    private LocalDateTime closedAt;
    private MessageDTO lastMessage;
    private long unreadCount;
}
