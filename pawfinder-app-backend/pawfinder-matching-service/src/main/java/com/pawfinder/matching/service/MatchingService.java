package com.pawfinder.matching.service;

import org.springframework.stereotype.Service;

/**
 * Service responsible for matching found pets with lost pet alerts
 * using visual similarity detection.
 *
 * TODO: Integrate AWS Rekognition for image comparison
 *       - Compare uploaded found-pet images against open lost-pet alert images
 *       - Return match confidence scores above a configurable threshold
 *       - Cache comparison results in Redis to avoid redundant API calls
 */
@Service
public class MatchingService {

    // Stub – implementation pending AWS Rekognition integration
}
