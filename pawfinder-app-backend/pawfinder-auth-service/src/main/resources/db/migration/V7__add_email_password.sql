-- Add email (plaintext, for login lookup) and password_hash (BCrypt) columns
-- Uses IF NOT EXISTS guards so it's safe to run against existing schemas
ALTER TABLE users ADD COLUMN IF NOT EXISTS email VARCHAR(255);
ALTER TABLE users ADD COLUMN IF NOT EXISTS password_hash VARCHAR(255);

-- Unique constraint on email (only if the column was just added / doesn't already have one)
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_constraint WHERE conname = 'uq_users_email'
    ) THEN
        ALTER TABLE users ADD CONSTRAINT uq_users_email UNIQUE (email);
    END IF;
END $$;
