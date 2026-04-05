BEGIN;
-- Delete all Mamdani evidence (fabricated URLs + unsourced agent items)
DELETE FROM person_criteria WHERE person_id = 293;
-- Delete his stance assessment too
DELETE FROM positions WHERE person_id = 293;
COMMIT;
