-- =============================================
-- Criteria system for structured position scoring
-- =============================================

-- 1. CRITERIA — the dimensions/signals that matter for a topic
CREATE TABLE criteria (
  id SERIAL PRIMARY KEY,
  topic_id INTEGER NOT NULL REFERENCES topics(id) ON DELETE CASCADE,
  label TEXT NOT NULL,
  description TEXT,
  direction TEXT NOT NULL CHECK (direction IN ('pro', 'anti')),
  weight INTEGER NOT NULL DEFAULT 2 CHECK (weight BETWEEN 1 AND 3),
  category TEXT NOT NULL CHECK (category IN ('legislation', 'rhetoric', 'policy_position', 'action')),
  created_at TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE criteria ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Public read access" ON criteria FOR SELECT USING (true);
CREATE INDEX idx_criteria_topic ON criteria (topic_id);

-- 2. PERSON_CRITERIA — evidence that a person matches a criterion
CREATE TABLE person_criteria (
  id SERIAL PRIMARY KEY,
  person_id INTEGER NOT NULL REFERENCES people(id) ON DELETE CASCADE,
  criterion_id INTEGER NOT NULL REFERENCES criteria(id) ON DELETE CASCADE,
  evidence TEXT,
  source_url TEXT,
  source_date DATE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE (person_id, criterion_id)
);

ALTER TABLE person_criteria ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Public read access" ON person_criteria FOR SELECT USING (true);
CREATE INDEX idx_person_criteria_person ON person_criteria (person_id);
CREATE INDEX idx_person_criteria_criterion ON person_criteria (criterion_id);

-- 3. Update positions table to support multiple assessment types per person/topic
-- Drop existing unique constraint and add assessment_type
ALTER TABLE positions DROP CONSTRAINT IF EXISTS positions_person_id_topic_id_key;

ALTER TABLE positions ADD COLUMN assessment_type TEXT NOT NULL DEFAULT 'rubric'
  CHECK (assessment_type IN ('rubric', 'ai'));

ALTER TABLE positions ADD COLUMN rationale TEXT;

ALTER TABLE positions ADD CONSTRAINT positions_person_topic_assessment_key
  UNIQUE (person_id, topic_id, assessment_type);

-- =============================================
-- Seed Israel criteria
-- =============================================

-- Legislation criteria
INSERT INTO criteria (topic_id, label, description, direction, weight, category) VALUES
  ((SELECT id FROM topics WHERE slug = 'israel'),
   'Sponsored anti-BDS legislation',
   'Primary sponsor of bills restricting BDS/boycotts of Israel (e.g., S1255, A4434)',
   'pro', 3, 'legislation'),

  ((SELECT id FROM topics WHERE slug = 'israel'),
   'Cosponsored anti-BDS legislation',
   'Cosponsor of anti-BDS bills',
   'pro', 2, 'legislation'),

  ((SELECT id FROM topics WHERE slug = 'israel'),
   'Sponsored anti-settlement legislation',
   'Primary sponsor of bills like "Not On Our Dime" (S606, A6101) restricting support for Israeli settlements',
   'anti', 3, 'legislation'),

  ((SELECT id FROM topics WHERE slug = 'israel'),
   'Cosponsored anti-settlement legislation',
   'Cosponsor of anti-settlement bills',
   'anti', 2, 'legislation'),

  ((SELECT id FROM topics WHERE slug = 'israel'),
   'Sponsored antisemitism protection legislation',
   'Primary sponsor of bills protecting against antisemitism (e.g., S531 Vandalism Act, S7034A HOPE Act)',
   'pro', 2, 'legislation'),

-- Policy position criteria
  ((SELECT id FROM topics WHERE slug = 'israel'),
   'Supports Iron Dome funding',
   'Voted for or publicly supported US funding of Israel Iron Dome missile defense',
   'pro', 2, 'policy_position'),

  ((SELECT id FROM topics WHERE slug = 'israel'),
   'Opposes Iron Dome funding',
   'Voted against or publicly opposed US funding of Israel Iron Dome missile defense',
   'anti', 3, 'policy_position'),

  ((SELECT id FROM topics WHERE slug = 'israel'),
   'Supports conditioning US aid to Israel',
   'Publicly supports placing conditions on US military aid to Israel',
   'anti', 2, 'policy_position'),

-- Rhetoric criteria
  ((SELECT id FROM topics WHERE slug = 'israel'),
   'Used "genocide" re: Israel',
   'Described Israel actions as genocide in official capacity or public statement',
   'anti', 3, 'rhetoric'),

  ((SELECT id FROM topics WHERE slug = 'israel'),
   'Used "apartheid" re: Israel',
   'Described Israel as an apartheid state in official capacity or public statement',
   'anti', 3, 'rhetoric'),

  ((SELECT id FROM topics WHERE slug = 'israel'),
   'Called for unconditional ceasefire',
   'Called for immediate/unconditional ceasefire without conditioning on hostage release',
   'anti', 2, 'rhetoric'),

  ((SELECT id FROM topics WHERE slug = 'israel'),
   'Strong condemnation of Oct 7 / Hamas',
   'Issued clear, unequivocal condemnation of Oct 7 attack and/or Hamas',
   'pro', 2, 'rhetoric'),

  ((SELECT id FROM topics WHERE slug = 'israel'),
   'Equivocated on Oct 7',
   'Response to Oct 7 was ambiguous, both-sides framing, or failed to condemn Hamas directly',
   'anti', 2, 'rhetoric'),

-- Action criteria
  ((SELECT id FROM topics WHERE slug = 'israel'),
   'Attended pro-Israel rally/event',
   'Attended or spoke at pro-Israel rally, vigil, or community event',
   'pro', 1, 'action'),

  ((SELECT id FROM topics WHERE slug = 'israel'),
   'Attended anti-Israel protest/rally',
   'Attended or spoke at anti-Israel or pro-BDS rally or protest',
   'anti', 2, 'action'),

  ((SELECT id FROM topics WHERE slug = 'israel'),
   'Signed solidarity letter with Israel',
   'Co-signed official letter expressing solidarity with Israel or condemning antisemitism',
   'pro', 2, 'action');

-- =============================================
-- Auto-populate person_criteria from existing bill_actions
-- =============================================

-- S1255 sponsor → "Sponsored anti-BDS legislation"
INSERT INTO person_criteria (person_id, criterion_id, evidence, source_url)
SELECT ba.person_id, c.id, 'Sponsor of S1255 (Anti-BDS Purchasing Restrictions)', 'https://www.nysenate.gov/legislation/bills/2025/S1255'
FROM bill_actions ba
JOIN bills b ON ba.bill_id = b.id
JOIN criteria c ON c.label = 'Sponsored anti-BDS legislation'
WHERE b.bill_number = 'S1255' AND ba.action = 'sponsor'
ON CONFLICT (person_id, criterion_id) DO NOTHING;

-- S606 sponsors → "Sponsored anti-settlement legislation"
INSERT INTO person_criteria (person_id, criterion_id, evidence, source_url)
SELECT ba.person_id, c.id, 'Sponsor of S606 (Not On Our Dime Act)', 'https://www.nysenate.gov/legislation/bills/2025/S606'
FROM bill_actions ba
JOIN bills b ON ba.bill_id = b.id
JOIN criteria c ON c.label = 'Sponsored anti-settlement legislation'
WHERE b.bill_number = 'S606' AND ba.action = 'sponsor'
ON CONFLICT (person_id, criterion_id) DO NOTHING;
