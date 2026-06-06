package com.pawfinder.shared.utils;

import java.util.concurrent.ThreadLocalRandom;

public final class GeoUtils {

    private static final double METERS_PER_DEGREE_LAT = 111_320.0;
    private static final double FUZZ_RADIUS_METERS = 100.0;
    private static final double EARTH_RADIUS_KM = 6371.0;

    private GeoUtils() {
        throw new UnsupportedOperationException("Utility class cannot be instantiated");
    }

    /**
     * Fuzzes coordinates by adding a random offset within ±100 meters.
     * Uses polar coordinates for uniform random angle and scaled distance.
     *
     * @param lat the original latitude
     * @param lng the original longitude
     * @return a double array with {fuzzedLat, fuzzedLng}
     */
    public static double[] fuzz(double lat, double lng) {
        ThreadLocalRandom random = ThreadLocalRandom.current();

        double angle = random.nextDouble() * 2 * Math.PI;
        double distanceMeters = random.nextDouble() * FUZZ_RADIUS_METERS;

        double deltaLatMeters = distanceMeters * Math.cos(angle);
        double deltaLngMeters = distanceMeters * Math.sin(angle);

        double deltaLat = deltaLatMeters / METERS_PER_DEGREE_LAT;
        double deltaLng = deltaLngMeters / (METERS_PER_DEGREE_LAT * Math.cos(Math.toRadians(lat)));

        double fuzzedLat = lat + deltaLat;
        double fuzzedLng = lng + deltaLng;

        fuzzedLat = Math.min(90.0, Math.max(-90.0, fuzzedLat));
        fuzzedLng = ((fuzzedLng + 180.0) % 360.0 + 360.0) % 360.0 - 180.0;

        return new double[]{fuzzedLat, fuzzedLng};
    }

    /**
     * Calculates the great-circle distance between two points on Earth
     * using the Haversine formula.
     *
     * @param lat1 latitude of point 1 in degrees
     * @param lng1 longitude of point 1 in degrees
     * @param lat2 latitude of point 2 in degrees
     * @param lng2 longitude of point 2 in degrees
     * @return distance in kilometers
     */
    public static double calculateDistance(double lat1, double lng1, double lat2, double lng2) {
        double dLat = Math.toRadians(lat2 - lat1);
        double dLng = Math.toRadians(lng2 - lng1);

        double a = Math.sin(dLat / 2) * Math.sin(dLat / 2)
                + Math.cos(Math.toRadians(lat1)) * Math.cos(Math.toRadians(lat2))
                * Math.sin(dLng / 2) * Math.sin(dLng / 2);

        double c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));

        return EARTH_RADIUS_KM * c;
    }
}
