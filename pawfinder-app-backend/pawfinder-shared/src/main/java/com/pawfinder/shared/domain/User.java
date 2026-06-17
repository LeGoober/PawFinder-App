package com.pawfinder.shared.domain;

import jakarta.persistence.*;
import jakarta.validation.constraints.Email;
import lombok.*;

import java.time.LocalDateTime;
import java.util.UUID;

@Entity
@Table(name = "users")
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class User {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @Column(name = "auth_provider")
    private String authProvider;

    @Column(name = "auth_id", unique = true)
    private String authId;

    @Column(name = "phone_hash")
    private String phoneHash;

    @Column(name = "email")
    @Email
    private String email;

    @Column(name = "email_hash")
    private String emailHash;

    @Column(name = "password_hash")
    private String passwordHash;

    @Column(name = "display_name")
    private String displayName;

    @Column(nullable = false)
    @Builder.Default
    private boolean verified = false;

    @Column(name = "rescuer_badge_level", nullable = false)
    @Builder.Default
    private int rescuerBadgeLevel = 0;

    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt;

    @Column(name = "last_active")
    private LocalDateTime lastActive;

    @PrePersist
    protected void onCreate() {
        if (createdAt == null) {
            createdAt = LocalDateTime.now();
        }
    }
}
