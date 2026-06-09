CREATE TABLE IF NOT EXISTS sightings (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    alert_id UUID NOT NULL,
    finder_id UUID NOT NULL,
    location_latitude DOUBLE PRECISION,
    location_longitude DOUBLE PRECISION,
    photo_urls JSONB,
    notes TEXT,
    status VARCHAR(20) DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT NOW(),
    CONSTRAINT fk_sightings_alert FOREIGN KEY (alert_id) REFERENCES alerts(id)
);

CREATE INDEX idx_sightings_alert ON sightings (alert_id);
CREATE INDEX idx_sightings_location ON sightings (location_latitude, location_longitude);
