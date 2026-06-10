-- Add PostGIS GEOGRAPHY column for last_seen_location
ALTER TABLE IF EXISTS alerts
    ADD COLUMN IF NOT EXISTS last_seen_location GEOGRAPHY(Point, 4326);

-- Populate from existing lat/lng columns if they have data
UPDATE alerts
SET last_seen_location = ST_SetSRID(ST_MakePoint(last_seen_longitude, last_seen_latitude), 4326)
WHERE last_seen_location IS NULL
  AND last_seen_latitude IS NOT NULL
  AND last_seen_longitude IS NOT NULL;

-- Spatial index for proximity queries
CREATE INDEX IF NOT EXISTS idx_alerts_location_geog
    ON alerts USING GIST (last_seen_location);
