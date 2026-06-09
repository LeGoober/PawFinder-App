CREATE TABLE IF NOT EXISTS pets (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    owner_id UUID NOT NULL,
    name VARCHAR(100),
    species VARCHAR(50),
    breed VARCHAR(100),
    color VARCHAR(100),
    size VARCHAR(20),
    distinguishing_features TEXT,
    temperament_notes TEXT,
    medical_needs TEXT,
    photos JSONB,
    qr_code_id VARCHAR(255) UNIQUE,
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_pets_owner ON pets (owner_id);
