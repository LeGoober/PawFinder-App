package com.pawfinder.shared.dto;

import lombok.*;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class TokenResponse {

    private String accessToken;

    private String refreshToken;

    private long expiresIn;

    @Builder.Default
    private String tokenType = "Bearer";
}
