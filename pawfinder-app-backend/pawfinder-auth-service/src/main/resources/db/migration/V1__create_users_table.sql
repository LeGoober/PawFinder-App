CREATE TABLE IF NOT EXISTS users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    auth_provider VARCHAR(50),
    auth_id VARCHAR(255),
    phone_hash VARCHAR(255),
    email_hash VARCHAR(255),
    display_name VARCHAR(100),
    verified BOOLEAN DEFAULT FALSE,
    rescuer_badge_level INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT NOW(),
    last_active TIMESTAMP,
    CONSTRAINT uq_users_auth_id UNIQUE (auth_id)
);
