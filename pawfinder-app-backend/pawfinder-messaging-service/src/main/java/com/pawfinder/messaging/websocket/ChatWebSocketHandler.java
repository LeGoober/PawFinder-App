package com.pawfinder.messaging.websocket;

import com.pawfinder.messaging.dto.MessageDTO;
import com.pawfinder.messaging.service.ConversationService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.messaging.handler.annotation.DestinationVariable;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;

import java.security.Principal;
import java.time.LocalDateTime;
import java.util.Map;
import java.util.UUID;

@Controller
@RequiredArgsConstructor
@Slf4j
public class ChatWebSocketHandler {

    private final SimpMessagingTemplate messagingTemplate;
    private final ConversationService conversationService;

    @MessageMapping("/chat.send/{conversationId}")
    public void handleChatMessage(
            @DestinationVariable UUID conversationId,
            @Payload Map<String, String> payload,
            Principal principal) {

        UUID senderId = UUID.fromString(principal.getName());
        String content = payload.get("content");

        if (content == null || content.isBlank()) {
            return;
        }

        String contentType = payload.getOrDefault("contentType", "text");

        MessageDTO message = conversationService.sendMessage(
                conversationId, senderId, content, contentType);

        messagingTemplate.convertAndSend(
                "/topic/conversation." + conversationId,
                message
        );

        log.debug("WebSocket message routed: conversationId={}, senderId={}",
                conversationId, senderId);
    }

    @MessageMapping("/sighting.report")
    public void handleSightingReport(
            @Payload Map<String, Object> payload,
            Principal principal) {

        UUID finderId = UUID.fromString(principal.getName());

        @SuppressWarnings("unchecked")
        Map<String, Object> sightingData = Map.of(
                "finderId", finderId.toString(),
                "alertId", payload.getOrDefault("alertId", "").toString(),
                "latitude", payload.getOrDefault("latitude", 0.0),
                "longitude", payload.getOrDefault("longitude", 0.0),
                "notes", payload.getOrDefault("notes", ""),
                "timestamp", LocalDateTime.now().toString()
        );

        String alertId = payload.getOrDefault("alertId", "").toString();

        messagingTemplate.convertAndSend(
                "/topic/alert." + alertId + ".sightings",
                sightingData
        );

        log.info("Sighting report broadcast via WebSocket: alertId={}, finderId={}",
                alertId, finderId);
    }
}
