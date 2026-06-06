package com.pawfinder.alert.service;

import org.locationtech.jts.geom.Coordinate;
import org.locationtech.jts.geom.GeometryFactory;
import org.locationtech.jts.geom.Point;
import org.locationtech.jts.geom.PrecisionModel;
import org.springframework.stereotype.Component;

import java.security.SecureRandom;

@Component
public class GeoUtils {

    private static final GeometryFactory GEOMETRY_FACTORY =
            new GeometryFactory(new PrecisionModel(), 4326);
    private static final SecureRandom RANDOM = new SecureRandom();

    /**
     * Creates a JTS Point from latitude and longitude.
     * Note: JTS uses (x=longitude, y=latitude) ordering.
     */
    public Point createPoint(double latitude, double longitude) {
        return GEOMETRY_FACTORY.createPoint(new Coordinate(longitude, latitude));
    }

    /**
     * Fuzzes coordinates by adding a small random offset.
     * Adds ±0.001 to ±0.005 degrees (roughly 100-500m) for privacy.
     */
    public double fuzzCoordinate(double coordinate) {
        double offset = (RANDOM.nextDouble() * 0.004) + 0.001;
        if (RANDOM.nextBoolean()) {
            offset = -offset;
        }
        return coordinate + offset;
    }

    /**
     * Calculates approximate distance in meters between two coordinates
     * using the Haversine formula.
     */
    public double calculateDistanceKm(double lat1, double lng1, double lat2, double lng2) {
        final double EARTH_RADIUS_KM = 6371.0;

        double dLat = Math.toRadians(lat2 - lat1);
        double dLng = Math.toRadians(lng2 - lng1);

        double a = Math.sin(dLat / 2) * Math.sin(dLat / 2) +
                Math.cos(Math.toRadians(lat1)) * Math.cos(Math.toRadians(lat2)) *
                        Math.sin(dLng / 2) * Math.sin(dLng / 2);

        double c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));

        return EARTH_RADIUS_KM * c;
    }

    /**
     * Converts the x/y of a JTS Point to lat/lng.
     * Returns double[]{latitude, longitude}.
     */
    public double[] pointToLatLng(Point point) {
        if (point == null) return null;
        return new double[]{point.getY(), point.getX()};
    }
}
