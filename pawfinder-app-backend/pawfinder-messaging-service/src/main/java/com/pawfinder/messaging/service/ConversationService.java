package com.pawfinder.messaging.service;

import com.pawfinder.messaging.dto.ConversationDTO;
import com.pawfinder.messaging.dto.MessageDTO;
import com.pawfinder.messaging.entity.Conversation;
import com.pawfinder.messaging.entity.Message;
import com.pawfinder.messaging.repository.ConversationRepository;
import com.pawfinder.messaging.repository.MessageRepository;
import jakarta.persistence.EntityNotFoundException;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.Comparator;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

@Service
@Transactional
@RequiredArgsConstructor
@Slf4j
public class ConversationService {

    private final ConversationRepository conversationRepository;
    private final MessageRepository messageRepository;

    public Conversation startConversation(UUID alertId, UUID ownerId,
                                           UUID finderId, UUID sightingId) {
        var existing = conversationRepository.findByAlertIdAndFinderId(alertId, finderId);
        if (existing.isPresent()) {
            Conversation conv = existing.get();
            if ("closed".equals(conv.getStatus())) {
                conv.setStatus("open");
                conv.setClosedAt(null);
                conversationRepository.save(conv);
            }
            log.info("Reusing existing conversation: id={}", conv.getId());
            return conv;
        }

        Conversation conversation = Conversation.builder()
                .alertId(alertId)
                .ownerId(ownerId)
                .finderId(finderId)
                .sightingId(sightingId)
                .status("open")
                .createdAt(LocalDateTime.now())
                .build();

        conversation = conversationRepository.save(conversation);
        log.info("Conversation started: id={}, alertId={}, finderId={}",
                conversation.getId(), alertId, finderId);
        return conversation;
    }

    @Transactional(readOnly = true)
    public List<ConversationDTO> getUserConversations(UUID userId) {
        List<Conversation> conversations = conversationRepository
                .findByOwnerIdOrFinderId(userId, userId);

        return conversations.stream()
                .map(conv -> toConversationDTO(conv, userId))
                .sorted(Comparator.comparing(ConversationDTO::getCreatedAt).reversed())
                .collect(Collectors.toList());
    }

    @Transactional
    public Conversation closeConversation(UUID conversationId, UUID userId) {
        Conversation conversation = conversationRepository.findById(conversationId)
                .orElseThrow(() -> new EntityNotFoundException(
                        "Conversation not found with id: " + conversationId));

        if (!conversation.getOwnerId().equals(userId)
                && !conversation.getFinderId().equals(userId)) {
            throw new SecurityException("You are not a participant in this conversation");
        }

        conversation.setStatus("closed");
        conversation.setClosedAt(LocalDateTime.now());
        conversationRepository.save(conversation);
        log.info("Conversation closed: id={}", conversationId);
        return conversation;
    }

    @Transactional
    public Page<MessageDTO> getMessages(UUID conversationId, Pageable pageable) {
        var conversation = conversationRepository.findById(conversationId)
                .orElseThrow(() -> new EntityNotFoundException(
                        "Conversation not found with id: " + conversationId));

        Page<Message> messages = messageRepository
                .findByConversationId(conversationId, pageable);

        return messages.map(this::toMessageDTO);
    }

    @Transactional
    public MessageDTO sendMessage(UUID conversationId, UUID senderId,
                                   String content, String contentType) {
        var conversation = conversationRepository.findById(conversationId)
                .orElseThrow(() -> new EntityNotFoundException(
                        "Conversation not found with id: " + conversationId));

        if (!conversation.getOwnerId().equals(senderId)
                && !conversation.getFinderId().equals(senderId)) {
            throw new SecurityException("You are not a participant in this conversation");
        }

        if ("closed".equals(conversation.getStatus())) {
            throw new IllegalStateException("Cannot send messages to a closed conversation");
        }

        Message message = Message.builder()
                .conversationId(conversationId)
                .senderId(senderId)
                .content(content)
                .contentType(contentType != null ? contentType : "text")
                .createdAt(LocalDateTime.now())
                .build();

        message = messageRepository.save(message);
        log.debug("Message sent: id={}, conversationId={}, senderId={}",
                message.getId(), conversationId, senderId);
        return toMessageDTO(message);
    }

    private ConversationDTO toConversationDTO(Conversation conversation, UUID userId) {
        List<Message> messages = messageRepository
                .findByConversationIdOrderByCreatedAtAsc(conversation.getId());

        MessageDTO lastMessage = null;
        long unreadCount = 0;

        if (!messages.isEmpty()) {
            Message last = messages.get(messages.size() - 1);
            lastMessage = toMessageDTO(last);

            unreadCount = messages.stream()
                    .filter(m -> !m.getSenderId().equals(userId) && m.getReadAt() == null)
                    .count();
        }

        return ConversationDTO.builder()
                .id(conversation.getId())
                .alertId(conversation.getAlertId())
                .ownerId(conversation.getOwnerId())
                .finderId(conversation.getFinderId())
                .sightingId(conversation.getSightingId())
                .status(conversation.getStatus())
                .createdAt(conversation.getCreatedAt())
                .closedAt(conversation.getClosedAt())
                .lastMessage(lastMessage)
                .unreadCount(unreadCount)
                .build();
    }

    private MessageDTO toMessageDTO(Message message) {
        return MessageDTO.builder()
                .id(message.getId())
                .conversationId(message.getConversationId())
                .senderId(message.getSenderId())
                .content(message.getContent())
                .contentType(message.getContentType())
                .createdAt(message.getCreatedAt())
                .readAt(message.getReadAt())
                .build();
    }
}
