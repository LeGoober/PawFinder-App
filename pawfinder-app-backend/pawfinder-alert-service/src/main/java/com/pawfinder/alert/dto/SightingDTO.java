package com.pawfinder.alert.dto;

import lombok.*;

import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class SightingDTO {
    private UUID id;
    private UUID alertId;
    private UUID finderId;
    private Double latitude;
    private Double longitude;
    private List<String> photoUrls;
    private String notes;
    private String status;
    private LocalDateTime createdAt;
}
