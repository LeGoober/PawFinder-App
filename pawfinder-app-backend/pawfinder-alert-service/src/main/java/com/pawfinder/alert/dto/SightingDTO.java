package com.pawfinder.alert.dto;

import com.fasterxml.jackson.annotation.JsonAlias;
import com.fasterxml.jackson.annotation.JsonProperty;
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

    @JsonProperty("fuzzedLat")
    @JsonAlias({"latitude"})
    private Double latitude;

    @JsonProperty("fuzzedLng")
    @JsonAlias({"longitude"})
    private Double longitude;

    private List<String> photoUrls;
    private String notes;
    private String status;
    private LocalDateTime createdAt;
}
