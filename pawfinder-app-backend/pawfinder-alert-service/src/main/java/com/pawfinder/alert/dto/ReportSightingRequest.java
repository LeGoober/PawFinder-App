package com.pawfinder.alert.dto;

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
    private Double latitude;

    @NotNull
    private Double longitude;

    private String notes;

    private List<String> photoUrls;
}
