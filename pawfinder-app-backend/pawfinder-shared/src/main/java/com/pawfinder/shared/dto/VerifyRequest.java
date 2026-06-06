package com.pawfinder.shared.dto;

import jakarta.validation.constraints.NotBlank;
import lombok.*;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class VerifyRequest {

    private String phoneNumber;

    @NotBlank(message = "Verification code is required")
    private String verificationCode;
}
