package com.pawfinder.media.controller;

import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.Map;

@RestController
@RequestMapping("/api/v1/media")
public class MediaController {

    /**
     * Upload a media file (image/video) for a lost or found pet alert.
     * TODO: Validate file type and size, upload to S3, return public URL.
     */
    @PostMapping(value = "/upload", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    public ResponseEntity<Map<String, String>> uploadMedia(@RequestParam("file") MultipartFile file) {
        return ResponseEntity.ok(Map.of(
                "url", "https://placeholder.example.com/image.jpg"
        ));
    }
}
