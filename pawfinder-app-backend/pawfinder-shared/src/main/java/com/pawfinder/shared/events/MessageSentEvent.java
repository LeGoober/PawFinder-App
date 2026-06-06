package com.pawfinder.shared.events;

import lombok.*;

import java.io.Serializable;
import java.time.LocalDateTime;
import java.util.UUID;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class MessageSentEvent implements Serializable {

    private static final long serialVersionUID = 1L;

    private UUID messageId;

    private UUID conversationId;

    private UUID senderId;

    private UUID recipientId;

    private String content;

    private LocalDateTime createdAt;
}
