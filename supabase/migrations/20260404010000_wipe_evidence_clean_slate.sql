-- Clean slate: delete all evidence and AI assessments for full re-gather
BEGIN;
DELETE FROM person_criteria;
DELETE FROM positions;
COMMIT;
