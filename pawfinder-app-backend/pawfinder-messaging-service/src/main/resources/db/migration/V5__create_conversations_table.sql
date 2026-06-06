CREATE TABLE IF NOT EXISTS conversations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    alert_id UUID,
    owner_id UUID NOT NULL,
    finder_id UUID NOT NULL,
    sighting_id UUID,
    status VARCHAR(20) DEFAULT 'open',
    created_at TIMESTAMP DEFAULT NOW(),
    closed_at TIMESTAMP
);

CREATE INDEX idx_conversations_users ON conversations (owner_id, finder_id);
