-- =============================================================
-- Rearchitect: separate people from seats, add positions system
-- =============================================================

-- 1. SEATS — structural positions that exist regardless of who holds them
CREATE TABLE seats (
  id SERIAL PRIMARY KEY,
  chamber TEXT NOT NULL CHECK (chamber IN ('senate', 'assembly', 'city_council')),
  district INTEGER NOT NULL,
  description TEXT,
  UNIQUE (chamber, district)
);

ALTER TABLE seats ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Public read access" ON seats FOR SELECT USING (true);

-- 2. PEOPLE — the actual humans
CREATE TABLE people (
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL,
  party TEXT,
  website TEXT,
  photo_url TEXT,
  bio TEXT,
  born_year INTEGER,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE people ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Public read access" ON people FOR SELECT USING (true);

-- 3. TERMS — who holds which seat, when
CREATE TABLE terms (
  id SERIAL PRIMARY KEY,
  person_id INTEGER NOT NULL REFERENCES people(id) ON DELETE CASCADE,
  seat_id INTEGER NOT NULL REFERENCES seats(id) ON DELETE CASCADE,
  start_date DATE,
  end_date DATE,
  is_current BOOLEAN NOT NULL DEFAULT true,
  phone_albany TEXT,
  phone_district TEXT,
  email TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE terms ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Public read access" ON terms FOR SELECT USING (true);
CREATE INDEX idx_terms_current ON terms (is_current) WHERE is_current = true;
CREATE INDEX idx_terms_person ON terms (person_id);
CREATE INDEX idx_terms_seat ON terms (seat_id);

-- 4. TOPICS — issues being tracked
CREATE TABLE topics (
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL,
  slug TEXT NOT NULL UNIQUE,
  description TEXT,
  category TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE topics ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Public read access" ON topics FOR SELECT USING (true);

-- 5. POSITIONS — a person's stance on a topic
CREATE TABLE positions (
  id SERIAL PRIMARY KEY,
  person_id INTEGER NOT NULL REFERENCES people(id) ON DELETE CASCADE,
  topic_id INTEGER NOT NULL REFERENCES topics(id) ON DELETE CASCADE,
  stance TEXT NOT NULL CHECK (stance IN ('strongly_support', 'support', 'neutral', 'oppose', 'strongly_oppose')),
  confidence TEXT NOT NULL DEFAULT 'unknown' CHECK (confidence IN ('verified', 'inferred', 'unknown')),
  summary TEXT,
  source_url TEXT,
  source_date DATE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE (person_id, topic_id)
);

ALTER TABLE positions ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Public read access" ON positions FOR SELECT USING (true);
CREATE INDEX idx_positions_topic ON positions (topic_id);
CREATE INDEX idx_positions_person ON positions (person_id);

-- 6. BILLS — specific legislation relevant to topics
CREATE TABLE bills (
  id SERIAL PRIMARY KEY,
  bill_number TEXT NOT NULL,
  session TEXT,
  title TEXT NOT NULL,
  summary TEXT,
  topic_id INTEGER REFERENCES topics(id) ON DELETE SET NULL,
  bill_url TEXT,
  status TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE bills ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Public read access" ON bills FOR SELECT USING (true);

-- 7. BILL_ACTIONS — what a person did on a bill
CREATE TABLE bill_actions (
  id SERIAL PRIMARY KEY,
  person_id INTEGER NOT NULL REFERENCES people(id) ON DELETE CASCADE,
  bill_id INTEGER NOT NULL REFERENCES bills(id) ON DELETE CASCADE,
  action TEXT NOT NULL CHECK (action IN ('sponsor', 'cosponsor', 'vote_yes', 'vote_no', 'vote_abstain')),
  action_date DATE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE (person_id, bill_id, action)
);

ALTER TABLE bill_actions ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Public read access" ON bill_actions FOR SELECT USING (true);
CREATE INDEX idx_bill_actions_person ON bill_actions (person_id);
CREATE INDEX idx_bill_actions_bill ON bill_actions (bill_id);

-- =============================================================
-- MIGRATE DATA from old legislators table
-- =============================================================

-- Populate seats from existing legislators
INSERT INTO seats (chamber, district)
SELECT DISTINCT chamber, district FROM legislators
ORDER BY chamber, district;

-- Populate people from existing legislators
INSERT INTO people (name, party)
SELECT name, party FROM legislators
ORDER BY id;

-- Populate terms by joining back
INSERT INTO terms (person_id, seat_id, is_current, phone_albany, phone_district, email)
SELECT
  p.id,
  s.id,
  true,
  l.phone_albany,
  l.phone_district,
  l.email
FROM legislators l
JOIN people p ON p.name = l.name AND COALESCE(p.party, '') = COALESCE(l.party, '')
JOIN seats s ON s.chamber = l.chamber AND s.district = l.district;

-- =============================================================
-- VIEW for easy frontend querying (backwards-compatible shape)
-- =============================================================
CREATE OR REPLACE VIEW current_legislators AS
SELECT
  p.id AS person_id,
  p.name,
  p.party,
  p.website,
  p.photo_url,
  s.chamber,
  s.district,
  t.phone_albany,
  t.phone_district,
  t.email,
  t.start_date,
  t.end_date,
  t.is_current
FROM terms t
JOIN people p ON t.person_id = p.id
JOIN seats s ON t.seat_id = s.id
WHERE t.is_current = true
ORDER BY s.chamber, s.district;

-- Seed initial topics
INSERT INTO topics (name, slug, description, category) VALUES
  ('Israel / Palestine', 'israel', 'Positions on Israel, BDS, settlements, and related policy', 'foreign_policy'),
  ('Financial Regulation', 'financial-regulation', 'Wall Street oversight, banking regulation, consumer finance', 'finance'),
  ('Housing', 'housing', 'Rent control, zoning, affordable housing, tenant protections', 'domestic_policy'),
  ('Education', 'education', 'Public school funding, charter schools, higher education', 'domestic_policy'),
  ('Climate / Environment', 'climate', 'Climate policy, renewable energy, environmental regulation', 'environment');

-- Seed known Israel-related bills
INSERT INTO bills (bill_number, session, title, summary, topic_id, bill_url, status) VALUES
  ('S1255', '2025-2026', 'Anti-BDS Purchasing Restrictions', 'Prohibits NY from contracting with corporations boycotting Israel; restricts public fund investment in such companies', (SELECT id FROM topics WHERE slug = 'israel'), 'https://www.nysenate.gov/legislation/bills/2025/S1255', 'committee'),
  ('A4434', '2025-2026', 'Anti-BDS Purchasing Restrictions (Assembly)', 'Assembly companion to S1255', (SELECT id FROM topics WHERE slug = 'israel'), 'https://www.nysenate.gov/legislation/bills/2025/A4434', 'committee'),
  ('S606', '2025-2026', 'Not On Our Dime Act', 'Prohibits not-for-profit corporations from supporting Israeli settlement activity', (SELECT id FROM topics WHERE slug = 'israel'), 'https://www.nysenate.gov/legislation/bills/2025/S606', 'committee'),
  ('A6101', '2025-2026', 'Not On Our Dime Act (Assembly)', 'Assembly companion to S606', (SELECT id FROM topics WHERE slug = 'israel'), 'https://www.nysenate.gov/legislation/bills/2025/A6101', 'committee'),
  ('S531', '2025-2026', 'NY Antisemitism Vandalism Act', 'Makes it unlawful to destroy pro-Israel materials in public spaces', (SELECT id FROM topics WHERE slug = 'israel'), 'https://www.nysenate.gov/legislation/bills/2025/S531', 'committee'),
  ('S7034A', '2025-2026', 'HOPE Act', 'Honoring Our Pledge to Eliminate Antisemitism — amends civil rights law', (SELECT id FROM topics WHERE slug = 'israel'), 'https://www.nysenate.gov/legislation/bills/2025/S7034/amendment/A', 'committee');

-- Seed known bill sponsors (from earlier research)
-- S1255 sponsor: Addabbo
INSERT INTO bill_actions (person_id, bill_id, action)
SELECT p.id, b.id, 'sponsor'
FROM people p, bills b
WHERE p.name = 'Joseph P. Addabbo Jr.' AND b.bill_number = 'S1255';

-- S606 sponsors: Brisport, Gonzalez, Jackson, Salazar
INSERT INTO bill_actions (person_id, bill_id, action)
SELECT p.id, b.id, 'sponsor'
FROM people p, bills b
WHERE p.name IN ('Jabari Brisport', 'Kristen Gonzalez', 'Robert Jackson', 'Julia Salazar')
  AND b.bill_number = 'S606';

-- Drop old table
DROP TABLE legislators;
