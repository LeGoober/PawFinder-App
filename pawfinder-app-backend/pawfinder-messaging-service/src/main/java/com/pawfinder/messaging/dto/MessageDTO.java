package com.pawfinder.messaging.dto;

import lombok.*;

import java.time.LocalDateTime;
import java.util.UUID;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class MessageDTO {
    private UUID id;
    private UUID conversationId;
    private UUID senderId;
    private String content;
    private String contentType;
    private LocalDateTime createdAt;
    private LocalDateTime readAt;
}
