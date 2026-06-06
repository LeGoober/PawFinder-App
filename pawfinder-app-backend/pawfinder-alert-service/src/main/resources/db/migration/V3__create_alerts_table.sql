CREATE TABLE IF NOT EXISTS alerts (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    pet_id UUID NOT NULL,
    owner_id UUID NOT NULL,
    status VARCHAR(20) DEFAULT 'active',
    last_seen_location GEOGRAPHY(POINT, 4326),
    last_seen_address TEXT,
    last_seen_timestamp TIMESTAMP,
    description TEXT,
    reward_amount DECIMAL(10,2),
    reward_currency VARCHAR(3) DEFAULT 'USD',
    reward_claimed BOOLEAN DEFAULT FALSE,
    geofence_radius_km INT DEFAULT 2,
    view_count INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT NOW(),
    expires_at TIMESTAMP DEFAULT (NOW() + INTERVAL '30 days'),
    resolved_at TIMESTAMP
);

CREATE INDEX idx_alerts_location ON alerts USING GIST (last_seen_location);
CREATE INDEX idx_alerts_status ON alerts (status);
CREATE INDEX idx_alerts_owner ON alerts (owner_id);
