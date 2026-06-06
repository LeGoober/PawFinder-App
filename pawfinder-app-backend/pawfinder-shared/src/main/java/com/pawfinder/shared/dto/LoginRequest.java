package com.pawfinder.shared.dto;

import lombok.*;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class LoginRequest {

    private String authProvider;

    private String authId;

    private String phoneNumber;
}
