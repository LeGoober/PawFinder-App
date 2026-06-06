package com.pawfinder.messaging.repository;

import com.pawfinder.messaging.entity.Conversation;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Repository
public interface ConversationRepository extends JpaRepository<Conversation, UUID> {

    List<Conversation> findByOwnerIdOrFinderId(UUID ownerId, UUID finderId);

    Optional<Conversation> findByAlertIdAndFinderId(UUID alertId, UUID finderId);
}
