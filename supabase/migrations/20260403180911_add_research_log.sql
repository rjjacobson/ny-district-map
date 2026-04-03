-- =============================================
-- Research log: tracks when research was done on each person × topic
-- =============================================

CREATE TABLE research_log (
  id SERIAL PRIMARY KEY,
  person_id INTEGER NOT NULL REFERENCES people(id) ON DELETE CASCADE,
  topic_id INTEGER NOT NULL REFERENCES topics(id) ON DELETE CASCADE,
  researched_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  pass_number INTEGER NOT NULL DEFAULT 1,
  result TEXT NOT NULL CHECK (result IN ('found', 'not_found')),
  notes TEXT,
  UNIQUE (person_id, topic_id, pass_number)
);

ALTER TABLE research_log ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Public read access" ON research_log FOR SELECT USING (true);
CREATE INDEX idx_research_log_person ON research_log (person_id);
CREATE INDEX idx_research_log_topic ON research_log (topic_id);
CREATE INDEX idx_research_log_result ON research_log (result);

-- =============================================
-- Backfill: log pass 1 for all 263 legislators on Israel topic
-- Everyone was researched on 2026-04-03
-- =============================================

-- People who got a position (found)
INSERT INTO research_log (person_id, topic_id, researched_at, pass_number, result, notes)
SELECT p.person_id, t.id, '2026-04-03T15:00:00Z', 1, 'found', 'First pass: AI agent web research'
FROM positions p
CROSS JOIN topics t
WHERE t.slug = 'israel' AND p.topic_id = t.id AND p.assessment_type = 'ai';

-- People who came back unknown (not_found) — insert from all people minus positioned
INSERT INTO research_log (person_id, topic_id, researched_at, pass_number, result, notes)
SELECT ppl.id, t.id, '2026-04-03T15:00:00Z', 1, 'not_found', 'First pass: AI agent web research — no public Israel-related statements found'
FROM people ppl
CROSS JOIN topics t
WHERE t.slug = 'israel'
  AND ppl.name != 'Vacant'
  AND ppl.id NOT IN (SELECT person_id FROM positions WHERE topic_id = t.id AND assessment_type = 'ai');

-- Also insert unknown stance rows into positions for completeness
INSERT INTO positions (person_id, topic_id, stance, confidence, assessment_type, rationale)
SELECT ppl.id, t.id, 'neutral', 'unknown', 'ai', 'No public Israel-related statements found after web research'
FROM people ppl
CROSS JOIN topics t
WHERE t.slug = 'israel'
  AND ppl.name != 'Vacant'
  AND ppl.id NOT IN (SELECT person_id FROM positions WHERE topic_id = t.id AND assessment_type = 'ai')
ON CONFLICT (person_id, topic_id, assessment_type) DO NOTHING;
