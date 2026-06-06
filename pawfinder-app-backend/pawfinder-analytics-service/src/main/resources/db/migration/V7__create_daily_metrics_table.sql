CREATE TABLE IF NOT EXISTS daily_metrics (
    date DATE PRIMARY KEY,
    active_alerts INT DEFAULT 0,
    new_alerts INT DEFAULT 0,
    resolved_alerts INT DEFAULT 0,
    avg_resolution_hours DECIMAL(8,2),
    total_rewards_offered DECIMAL(12,2),
    total_rewards_claimed DECIMAL(12,2),
    new_users INT DEFAULT 0,
    active_users INT DEFAULT 0
);
