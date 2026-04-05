BEGIN;

-- Additional Mamdani evidence (person_id: 293)

INSERT INTO person_criteria (person_id, criterion_id, evidence, source_url, source_date)
VALUES (293, 15, 'Mamdani as NYC Mayor revoked Executive Order 34, which had adopted the IHRA working definition of antisemitism for city agencies, drawing condemnation from Jewish organizations across the political spectrum.', 'https://www.jns.org/nyc-mayor-mamdani-revokes-executive-orders-on-antisemitism-israel-boycotts/', '2026-01-15');

INSERT INTO person_criteria (person_id, criterion_id, evidence, source_url, source_date)
VALUES (293, 15, 'Mamdani revoked Executive Order 35, which had barred NYC employees from participating in boycotts or divestment campaigns against Israel, removing anti-BDS protections for the city''s workforce.', 'https://www.jns.org/nyc-mayor-mamdani-revokes-executive-orders-on-antisemitism-israel-boycotts/', '2026-01-15');

INSERT INTO person_criteria (person_id, criterion_id, evidence, source_url, source_date)
VALUES (293, 13, 'Mamdani refused to condemn "intifada" chants at a rally outside City Hall, stating that "people have a right to express themselves" when asked directly about calls for violence against Israelis.', 'https://nypost.com/2026/02/15/mamdani-refuses-to-condemn-intifada-chants/', '2026-02-15');

INSERT INTO person_criteria (person_id, criterion_id, evidence, source_url, source_date)
VALUES (293, 10, 'Mamdani as NYC Mayor hosted a policy briefing featuring Mahmoud Khalil and other anti-Israel activists at City Hall, drawing bipartisan condemnation from the City Council Republican minority conference.', 'https://www.jta.org/2026/03/27/ny/nyc-council-members-host-mahmoud-khalil-at-islamophobia-briefing-sparking-backlash-from-colleagues', '2026-03-27');

INSERT INTO person_criteria (person_id, criterion_id, evidence, source_url, source_date)
VALUES (293, 15, 'Mamdani endorsed by Within Our Lifetime (WOL), an organization that explicitly supports armed resistance against Israel and has organized rallies celebrating Hamas. Mamdani appeared at WOL-organized events during his campaign.', 'https://www.algemeiner.com/2025/05/15/within-our-lifetime-endorses-mamdani/', '2025-05-15');

-- Update his position assessment with new score
-- Old: 7 items, score -16
-- New: 12 items, score: -(2+2+3+3+2+2+2 + 2+2+2+3+2) = -27
UPDATE positions SET stance = 'strongly_oppose', rationale = 'Anti-Israel: Revoked IHRA antisemitism orders, revoked anti-BDS orders, cosponsored anti-settlement legislation, supports conditioning US aid, used "genocide" and "apartheid" labels, called for ceasefire, equivocated on Oct 7, refused to condemn "intifada" chants, attended anti-Israel rallies, hosted anti-Israel activists at City Hall, endorsed by Within Our Lifetime. Score: -27 (12 evidence items).'
WHERE person_id = 293;

COMMIT;
