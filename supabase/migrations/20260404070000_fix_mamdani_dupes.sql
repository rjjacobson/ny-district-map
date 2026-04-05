BEGIN;
-- Remove duplicate Mamdani entries (keep original + first new batch)
DELETE FROM person_criteria WHERE id IN (1215, 1216, 1217, 1218, 1219, 1220, 1221);
COMMIT;
