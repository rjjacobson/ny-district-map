-- Add source_url and source_date to person_criteria for proper evidence tracking
ALTER TABLE person_criteria ADD COLUMN IF NOT EXISTS source_url TEXT;
ALTER TABLE person_criteria ADD COLUMN IF NOT EXISTS source_date DATE;
