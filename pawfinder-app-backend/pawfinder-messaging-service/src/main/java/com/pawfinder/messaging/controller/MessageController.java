package com.pawfinder.messaging.controller;

import com.pawfinder.messaging.dto.ConversationDTO;
import com.pawfinder.messaging.dto.MessageDTO;
import com.pawfinder.messaging.dto.SendMessageRequest;
import com.pawfinder.messaging.dto.StartConversationRequest;
import com.pawfinder.messaging.entity.Conversation;
import com.pawfinder.messaging.service.ConversationService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/v1")
@RequiredArgsConstructor
@Tag(name = "Messaging", description = "Conversation and message management endpoints")
public class MessageController {

    private final ConversationService conversationService;

    @PostMapping("/conversations")
    @Operation(summary = "Start a new conversation")
    @ApiResponses({
        @ApiResponse(responseCode = "201", description = "Conversation created"),
        @ApiResponse(responseCode = "400", description = "Invalid request")
    })
    public ResponseEntity<Conversation> startConversation(
            @Valid @RequestBody StartConversationRequest request,
            Authentication authentication) {

        UUID finderId = UUID.fromString(authentication.getName());

        // Note: In a real implementation, ownerId would be fetched from the alert service.
        // For now, we pass it as empty and let the service handle it.
        // The finder is the one initiating the conversation.
        Conversation conversation = conversationService.startConversation(
                request.getAlertId(),
                UUID.randomUUID(), // ownerId should come from alert service lookup
                finderId,
                request.getSightingId()
        );

        return ResponseEntity.status(HttpStatus.CREATED).body(conversation);
    }

    @GetMapping("/conversations")
    @Operation(summary = "List user conversations")
    @ApiResponse(responseCode = "200", description = "Conversations retrieved")
    public ResponseEntity<List<ConversationDTO>> listConversations(
            Authentication authentication) {
        UUID userId = UUID.fromString(authentication.getName());
        List<ConversationDTO> conversations = conversationService.getUserConversations(userId);
        return ResponseEntity.ok(conversations);
    }

    @GetMapping("/conversations/{id}/messages")
    @Operation(summary = "Get paginated messages for a conversation")
    @ApiResponses({
        @ApiResponse(responseCode = "200", description = "Messages retrieved"),
        @ApiResponse(responseCode = "404", description = "Conversation not found")
    })
    public ResponseEntity<Page<MessageDTO>> getMessages(
            @PathVariable UUID id,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "50") int size) {
        Pageable pageable = PageRequest.of(page, size, Sort.by("createdAt").ascending());
        Page<MessageDTO> messages = conversationService.getMessages(id, pageable);
        return ResponseEntity.ok(messages);
    }

    @PostMapping("/conversations/{id}/messages")
    @Operation(summary = "Send a message in a conversation")
    @ApiResponses({
        @ApiResponse(responseCode = "201", description = "Message sent"),
        @ApiResponse(responseCode = "404", description = "Conversation not found"),
        @ApiResponse(responseCode = "403", description = "Not a participant")
    })
    public ResponseEntity<MessageDTO> sendMessage(
            @PathVariable UUID id,
            @Valid @RequestBody SendMessageRequest request,
            Authentication authentication) {
        UUID senderId = UUID.fromString(authentication.getName());
        MessageDTO message = conversationService.sendMessage(
                id, senderId, request.getContent(),
                request.getContentType() != null ? request.getContentType() : "text");
        return ResponseEntity.status(HttpStatus.CREATED).body(message);
    }

    @PutMapping("/conversations/{id}/close")
    @Operation(summary = "Close a conversation")
    @ApiResponses({
        @ApiResponse(responseCode = "200", description = "Conversation closed"),
        @ApiResponse(responseCode = "404", description = "Conversation not found"),
        @ApiResponse(responseCode = "403", description = "Not a participant")
    })
    public ResponseEntity<Conversation> closeConversation(
            @PathVariable UUID id,
            Authentication authentication) {
        UUID userId = UUID.fromString(authentication.getName());
        Conversation conversation = conversationService.closeConversation(id, userId);
        return ResponseEntity.ok(conversation);
    }
}
