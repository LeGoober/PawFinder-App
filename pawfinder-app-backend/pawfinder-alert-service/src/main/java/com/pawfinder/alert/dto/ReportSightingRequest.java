package com.pawfinder.alert.dto;

import com.fasterxml.jackson.annotation.JsonAlias;
import com.fasterxml.jackson.annotation.JsonProperty;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;
import lombok.*;

import java.util.List;
import java.util.UUID;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ReportSightingRequest {

    @NotNull
    private UUID alertId;

    @NotNull
    @JsonProperty("latitude")
    @JsonAlias({"lat"})
    private Double latitude;

    @NotNull
    @JsonProperty("longitude")
    @JsonAlias({"lng"})
    private Double longitude;

    private String notes;

    private List<String> photoUrls;
}
