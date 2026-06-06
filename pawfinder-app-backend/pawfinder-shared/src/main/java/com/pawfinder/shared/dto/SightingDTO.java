package com.pawfinder.shared.dto;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.*;

import java.time.LocalDateTime;
import java.util.UUID;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class SightingDTO {

    private UUID id;

    private UUID alertId;

    private UUID finderId;

    private String notes;

    private String photoUrls;

    private String status;

    @JsonFormat(pattern = "yyyy-MM-dd'T'HH:mm:ss")
    private LocalDateTime createdAt;

    private double fuzzedLat;

    private double fuzzedLng;
}
