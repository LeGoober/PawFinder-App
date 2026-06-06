package com.pawfinder.auth.service;

import lombok.extern.slf4j.Slf4j;
import org.springframework.context.annotation.Profile;
import org.springframework.stereotype.Service;

@Service
@Profile("dev | default")
@Slf4j
public class SmsVerificationService {

    /**
     * In dev mode, just logs the code instead of sending SMS via Twilio.
     * In production, this would use Twilio's API to send a real SMS.
     */
    public void sendVerificationCode(String phoneNumber) {
        log.info("DEV MODE: Sending verification code '123456' to phone number: {}", phoneNumber);
    }

    /**
     * Verifies the code provided by the user.
     * In dev mode, accepts "123456" as the valid code.
     * In production, this would verify against a stored code with expiry.
     */
    public boolean verifyCode(String phoneNumber, String code) {
        boolean valid = "123456".equals(code);
        log.info("DEV MODE: Verifying code '{}' for phone {} — result: {}", code, phoneNumber, valid);
        return valid;
    }
}
