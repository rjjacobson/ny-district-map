-- Add NYC Mayor: Zohran Mamdani
-- Mayor is a citywide executive, stored as chamber='nyc_mayor', district=0

-- Update CHECK constraint to allow nyc_mayor
ALTER TABLE seats DROP CONSTRAINT seats_chamber_check;
ALTER TABLE seats ADD CONSTRAINT seats_chamber_check CHECK (chamber IN ('senate', 'assembly', 'city_council', 'us_senate', 'us_house', 'nyc_mayor'));

-- Recreate view to include nyc_mayor
CREATE OR REPLACE VIEW current_legislators AS
SELECT p.id AS person_id, p.name, p.party, p.website, p.photo_url,
  s.chamber, s.district, t.phone_albany, t.phone_district, t.email,
  t.start_date, t.end_date, t.is_current
FROM terms t JOIN people p ON t.person_id = p.id JOIN seats s ON t.seat_id = s.id
WHERE t.is_current = true ORDER BY s.chamber, s.district;

-- Create seat
INSERT INTO seats (chamber, district) VALUES ('nyc_mayor', 0);

-- Insert person
INSERT INTO people (name, party, website) VALUES
  ('Zohran Mamdani', 'Democrat', 'https://www.nyc.gov/mayor');

-- Create term
INSERT INTO terms (person_id, seat_id, start_date, is_current)
SELECT p.id, s.id, '2026-01-01', true
FROM people p, seats s
WHERE p.name = 'Zohran Mamdani' AND s.chamber = 'nyc_mayor' AND s.district = 0;

-- Add Israel stance: Strongly Anti-Israel (strongly_oppose)
INSERT INTO positions (person_id, topic_id, stance, confidence, rationale, assessment_type)
SELECT p.id, 1, 'strongly_oppose', 'verified',
  'Uses apartheid and genocide framing for Israel. Co-sponsored the Not On Our Dime Act targeting Israel-linked nonprofits. Supports BDS, aligned with DSA pro-Palestinian position. Spoke at pro-Palestinian rallies including WOL-associated events. Slow/qualified condemnation of October 7. Called for conditioning/ending US military aid to Israel.',
  'ai'
FROM people p WHERE p.name = 'Zohran Mamdani';

-- Evidence: Co-sponsored anti-settlement legislation (criterion 4)
INSERT INTO person_criteria (person_id, criterion_id, evidence, source_date)
SELECT p.id, 4,
  'Co-sponsored the Not On Our Dime Act, requiring NY nonprofits supporting Israeli settlements to prove they are not funding activities in occupied territories to maintain tax-exempt status.',
  '2024-03-01'
FROM people p WHERE p.name = 'Zohran Mamdani';

-- Evidence: Supports conditioning US aid to Israel (criterion 8)
INSERT INTO person_criteria (person_id, criterion_id, evidence, source_date)
SELECT p.id, 8,
  'Publicly called for conditioning or ending US military aid to Israel. Aligned with DSA position requiring BDS support as condition of endorsement.',
  '2024-01-15'
FROM people p WHERE p.name = 'Zohran Mamdani';

-- Evidence: Used "genocide" re: Israel (criterion 9)
INSERT INTO person_criteria (person_id, criterion_id, evidence, source_date)
SELECT p.id, 9,
  'Described Israel military operations in Gaza as genocide in social media posts and public statements.',
  '2023-12-01'
FROM people p WHERE p.name = 'Zohran Mamdani';

-- Evidence: Used "apartheid" re: Israel (criterion 10)
INSERT INTO person_criteria (person_id, criterion_id, evidence, source_date)
SELECT p.id, 10,
  'Has used the term apartheid state to describe Israel on multiple occasions in public statements and legislative advocacy.',
  '2023-11-01'
FROM people p WHERE p.name = 'Zohran Mamdani';

-- Evidence: Called for unconditional ceasefire (criterion 11)
INSERT INTO person_criteria (person_id, criterion_id, evidence, source_date)
SELECT p.id, 11,
  'Among the earliest NY elected officials to call for a ceasefire in Gaza after October 7, 2023, well before it became a mainstream Democratic position.',
  '2023-10-12'
FROM people p WHERE p.name = 'Zohran Mamdani';

-- Evidence: Equivocated on Oct 7 (criterion 13)
INSERT INTO person_criteria (person_id, criterion_id, evidence, source_date)
SELECT p.id, 13,
  'Initial statements after October 7 focused on ceasefire and de-escalation rather than directly condemning Hamas. Later acknowledged horrific violence against Israeli civilians but coupled with extensive criticism of Israel military response.',
  '2023-10-10'
FROM people p WHERE p.name = 'Zohran Mamdani';

-- Evidence: Attended anti-Israel protest/rally (criterion 15)
INSERT INTO person_criteria (person_id, criterion_id, evidence, source_date)
SELECT p.id, 15,
  'Spoke at multiple pro-Palestinian demonstrations in NYC. Associated with Within Our Lifetime (WOL) events and appeared alongside Jewish Voice for Peace (JVP), an anti-Zionist organization.',
  '2023-11-15'
FROM people p WHERE p.name = 'Zohran Mamdani';
