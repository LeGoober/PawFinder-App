package com.pawfinder.auth.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.UUID;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class UserDTO {

    private UUID id;
    private String authProvider;
    private String displayName;
    private boolean verified;
    private int rescuerBadgeLevel;
    private LocalDateTime createdAt;
    private LocalDateTime lastActive;
}
