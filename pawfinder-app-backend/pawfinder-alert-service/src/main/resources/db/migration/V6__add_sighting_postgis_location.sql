-- Add PostGIS GEOGRAPHY column for sighting location
ALTER TABLE IF EXISTS sightings
    ADD COLUMN IF NOT EXISTS location GEOGRAPHY(Point, 4326);

-- Populate from existing lat/lng columns if they have data
UPDATE sightings
SET location = ST_SetSRID(ST_MakePoint(location_longitude, location_latitude), 4326)
WHERE location IS NULL
  AND location_latitude IS NOT NULL
  AND location_longitude IS NOT NULL;

-- Spatial index for proximity queries
CREATE INDEX IF NOT EXISTS idx_sightings_location_geog
    ON sightings USING GIST (location);
