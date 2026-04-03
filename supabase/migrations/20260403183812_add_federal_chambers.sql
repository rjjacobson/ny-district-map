-- =============================================
-- Add federal chambers: us_senate and us_house
-- =============================================

-- Update CHECK constraint
ALTER TABLE seats DROP CONSTRAINT seats_chamber_check;
ALTER TABLE seats ADD CONSTRAINT seats_chamber_check CHECK (chamber IN ('senate', 'assembly', 'city_council', 'us_senate', 'us_house'));

-- Recreate view to include new chambers
CREATE OR REPLACE VIEW current_legislators AS
SELECT p.id AS person_id, p.name, p.party, p.website, p.photo_url,
  s.chamber, s.district, t.phone_albany, t.phone_district, t.email,
  t.start_date, t.end_date, t.is_current
FROM terms t JOIN people p ON t.person_id = p.id JOIN seats s ON t.seat_id = s.id
WHERE t.is_current = true ORDER BY s.chamber, s.district;

-- US Senate seats
INSERT INTO seats (chamber, district) VALUES ('us_senate', 1), ('us_senate', 2);

-- US House seats
INSERT INTO seats (chamber, district) VALUES ('us_house', 1);
INSERT INTO seats (chamber, district) VALUES ('us_house', 2);
INSERT INTO seats (chamber, district) VALUES ('us_house', 3);
INSERT INTO seats (chamber, district) VALUES ('us_house', 4);
INSERT INTO seats (chamber, district) VALUES ('us_house', 5);
INSERT INTO seats (chamber, district) VALUES ('us_house', 6);
INSERT INTO seats (chamber, district) VALUES ('us_house', 7);
INSERT INTO seats (chamber, district) VALUES ('us_house', 8);
INSERT INTO seats (chamber, district) VALUES ('us_house', 9);
INSERT INTO seats (chamber, district) VALUES ('us_house', 10);
INSERT INTO seats (chamber, district) VALUES ('us_house', 11);
INSERT INTO seats (chamber, district) VALUES ('us_house', 12);
INSERT INTO seats (chamber, district) VALUES ('us_house', 13);
INSERT INTO seats (chamber, district) VALUES ('us_house', 14);
INSERT INTO seats (chamber, district) VALUES ('us_house', 15);
INSERT INTO seats (chamber, district) VALUES ('us_house', 16);
INSERT INTO seats (chamber, district) VALUES ('us_house', 17);
INSERT INTO seats (chamber, district) VALUES ('us_house', 18);
INSERT INTO seats (chamber, district) VALUES ('us_house', 19);
INSERT INTO seats (chamber, district) VALUES ('us_house', 20);
INSERT INTO seats (chamber, district) VALUES ('us_house', 21);
INSERT INTO seats (chamber, district) VALUES ('us_house', 22);
INSERT INTO seats (chamber, district) VALUES ('us_house', 23);
INSERT INTO seats (chamber, district) VALUES ('us_house', 24);
INSERT INTO seats (chamber, district) VALUES ('us_house', 25);
INSERT INTO seats (chamber, district) VALUES ('us_house', 26);

INSERT INTO people (name, party, website) VALUES ('Chuck Schumer', 'Democratic', 'https://www.schumer.senate.gov');
INSERT INTO terms (person_id, seat_id, is_current, start_date, end_date)
  SELECT p.id, s.id, true, '2023-01-03', '2028-01-03'
  FROM people p, seats s
  WHERE p.name = 'Chuck Schumer' AND p.website = 'https://www.schumer.senate.gov'
    AND s.chamber = 'us_senate' AND s.district = 1;
INSERT INTO positions (person_id, topic_id, stance, confidence, assessment_type, rationale, summary)
  SELECT p.id, (SELECT id FROM topics WHERE slug = 'israel'), 'strongly_support', 'inferred', 'ai', 'Self-described "guardian of Israel" in the Senate. Has called himself a "shomer" (guardian) for Israel. Led push for $500M in Iron Dome/missile defense funding. Supported largest-ever aid package to Israel. While he gave a notable March 2024 speech criticizing Netanyahu and calling for new Israeli elections, he explicitly frames this as pro-Israel (removing an obstacle to Israel''s long-term security) and has stated "my job is to keep the left pro-Israel."', 'March 2024 Senate floor speech calling for new Israeli elections while affirming Israel''s right to defend itself (https://www.democrats.senate.gov/newsroom/press-releases/majority-leader-schumer-delivers-major-address-calling-on-the-israeli-government-to-hold-elections). Voted for largest aid package to Israel in history with only 3 Democratic dissenters. Pushed for $500M in U.S.-Israeli missile defense funding (https://www.gillibrand.senate.gov/news/press/release/schumer-gillibrand-announce-tha'
  FROM people p WHERE p.name = 'Chuck Schumer' AND p.website = 'https://www.schumer.senate.gov'
  ON CONFLICT (person_id, topic_id, assessment_type) DO NOTHING;
INSERT INTO research_log (person_id, topic_id, researched_at, pass_number, result, notes)
  SELECT p.id, (SELECT id FROM topics WHERE slug = 'israel'), NOW(), 1, 'found', 'Federal delegation research'
  FROM people p WHERE p.name = 'Chuck Schumer' AND p.website = 'https://www.schumer.senate.gov'
  ON CONFLICT (person_id, topic_id, pass_number) DO NOTHING;
INSERT INTO person_criteria (person_id, criterion_id, evidence)
  SELECT p.id, 1, 'March 2024 Senate floor speech calling for new Israeli elections while affirming Israel''''s right to defend itself (https://www.democrats.senate.gov/newsroom/press-releases/majority-leader-schumer-deli'
  FROM people p WHERE p.name = 'Chuck Schumer' AND p.website = 'https://www.schumer.senate.gov'
  ON CONFLICT (person_id, criterion_id) DO NOTHING;
INSERT INTO person_criteria (person_id, criterion_id, evidence)
  SELECT p.id, 6, 'March 2024 Senate floor speech calling for new Israeli elections while affirming Israel''''s right to defend itself (https://www.democrats.senate.gov/newsroom/press-releases/majority-leader-schumer-deli'
  FROM people p WHERE p.name = 'Chuck Schumer' AND p.website = 'https://www.schumer.senate.gov'
  ON CONFLICT (person_id, criterion_id) DO NOTHING;
INSERT INTO person_criteria (person_id, criterion_id, evidence)
  SELECT p.id, 12, 'March 2024 Senate floor speech calling for new Israeli elections while affirming Israel''''s right to defend itself (https://www.democrats.senate.gov/newsroom/press-releases/majority-leader-schumer-deli'
  FROM people p WHERE p.name = 'Chuck Schumer' AND p.website = 'https://www.schumer.senate.gov'
  ON CONFLICT (person_id, criterion_id) DO NOTHING;
INSERT INTO person_criteria (person_id, criterion_id, evidence)
  SELECT p.id, 14, 'March 2024 Senate floor speech calling for new Israeli elections while affirming Israel''''s right to defend itself (https://www.democrats.senate.gov/newsroom/press-releases/majority-leader-schumer-deli'
  FROM people p WHERE p.name = 'Chuck Schumer' AND p.website = 'https://www.schumer.senate.gov'
  ON CONFLICT (person_id, criterion_id) DO NOTHING;
INSERT INTO person_criteria (person_id, criterion_id, evidence)
  SELECT p.id, 16, 'March 2024 Senate floor speech calling for new Israeli elections while affirming Israel''''s right to defend itself (https://www.democrats.senate.gov/newsroom/press-releases/majority-leader-schumer-deli'
  FROM people p WHERE p.name = 'Chuck Schumer' AND p.website = 'https://www.schumer.senate.gov'
  ON CONFLICT (person_id, criterion_id) DO NOTHING;

INSERT INTO people (name, party, website) VALUES ('Kirsten Gillibrand', 'Democratic', 'https://www.gillibrand.senate.gov');
INSERT INTO terms (person_id, seat_id, is_current, start_date, end_date)
  SELECT p.id, s.id, true, '2025-01-03', '2030-01-03'
  FROM people p, seats s
  WHERE p.name = 'Kirsten Gillibrand' AND p.website = 'https://www.gillibrand.senate.gov'
    AND s.chamber = 'us_senate' AND s.district = 2;
INSERT INTO positions (person_id, topic_id, stance, confidence, assessment_type, rationale, summary)
  SELECT p.id, (SELECT id FROM topics WHERE slug = 'israel'), 'support', 'inferred', 'ai', 'Consistent supporter of Israel''s security and military aid, voted against blocking $675M arms sale to Israel. Supported Iron Dome funding. However, also joined 45 Senate Democrats urging Trump to oppose West Bank annexation and called for humanitarian aid and ceasefire deal. Focus on hostages over Palestinian civilian casualties drew criticism.', 'Voted against Sen. Sanders'' measure to block $675M in arms sales to Israel. Joined push for $500M in U.S.-Israeli missile defense funding (https://www.gillibrand.senate.gov/news/press/release/schumer-gillibrand-announce-that-following-their-push-usisraeli-cooperative-missile-defense-programs-to-receive-500-million-in-federal-funds/). Joined 45 Senate Democrats urging Trump to oppose West Bank annexation (https://www.gillibrand.senate.gov/news/press/release/gillibrand-45-senate-democrats-urge-pre'
  FROM people p WHERE p.name = 'Kirsten Gillibrand' AND p.website = 'https://www.gillibrand.senate.gov'
  ON CONFLICT (person_id, topic_id, assessment_type) DO NOTHING;
INSERT INTO research_log (person_id, topic_id, researched_at, pass_number, result, notes)
  SELECT p.id, (SELECT id FROM topics WHERE slug = 'israel'), NOW(), 1, 'found', 'Federal delegation research'
  FROM people p WHERE p.name = 'Kirsten Gillibrand' AND p.website = 'https://www.gillibrand.senate.gov'
  ON CONFLICT (person_id, topic_id, pass_number) DO NOTHING;
INSERT INTO person_criteria (person_id, criterion_id, evidence)
  SELECT p.id, 1, 'Voted against Sen. Sanders'''' measure to block $675M in arms sales to Israel. Joined push for $500M in U.S.-Israeli missile defense funding (https://www.gillibrand.senate.gov/news/press/release/schumer'
  FROM people p WHERE p.name = 'Kirsten Gillibrand' AND p.website = 'https://www.gillibrand.senate.gov'
  ON CONFLICT (person_id, criterion_id) DO NOTHING;
INSERT INTO person_criteria (person_id, criterion_id, evidence)
  SELECT p.id, 6, 'Voted against Sen. Sanders'''' measure to block $675M in arms sales to Israel. Joined push for $500M in U.S.-Israeli missile defense funding (https://www.gillibrand.senate.gov/news/press/release/schumer'
  FROM people p WHERE p.name = 'Kirsten Gillibrand' AND p.website = 'https://www.gillibrand.senate.gov'
  ON CONFLICT (person_id, criterion_id) DO NOTHING;
INSERT INTO person_criteria (person_id, criterion_id, evidence)
  SELECT p.id, 12, 'Voted against Sen. Sanders'''' measure to block $675M in arms sales to Israel. Joined push for $500M in U.S.-Israeli missile defense funding (https://www.gillibrand.senate.gov/news/press/release/schumer'
  FROM people p WHERE p.name = 'Kirsten Gillibrand' AND p.website = 'https://www.gillibrand.senate.gov'
  ON CONFLICT (person_id, criterion_id) DO NOTHING;
INSERT INTO person_criteria (person_id, criterion_id, evidence)
  SELECT p.id, 16, 'Voted against Sen. Sanders'''' measure to block $675M in arms sales to Israel. Joined push for $500M in U.S.-Israeli missile defense funding (https://www.gillibrand.senate.gov/news/press/release/schumer'
  FROM people p WHERE p.name = 'Kirsten Gillibrand' AND p.website = 'https://www.gillibrand.senate.gov'
  ON CONFLICT (person_id, criterion_id) DO NOTHING;

INSERT INTO people (name, party, website) VALUES ('Nick LaLota', 'Republican', 'https://lalota.house.gov');
INSERT INTO terms (person_id, seat_id, is_current, start_date, end_date)
  SELECT p.id, s.id, true, '2025-01-03', '2027-01-03'
  FROM people p, seats s
  WHERE p.name = 'Nick LaLota' AND p.website = 'https://lalota.house.gov'
    AND s.chamber = 'us_house' AND s.district = 1;
INSERT INTO positions (person_id, topic_id, stance, confidence, assessment_type, rationale, summary)
  SELECT p.id, (SELECT id FROM topics WHERE slug = 'israel'), 'strongly_support', 'inferred', 'ai', 'Unequivocal supporter of Israel with dedicated "Stand with Israel" campaign page. Voted for all major Israel aid packages and co-sponsored pro-Israel resolutions. Strongly condemns Hamas/Hezbollah/Iran.', 'Voted for H.R. 6126, Israel Security Supplemental Appropriations Act ($14.3B). Voted for H.Res.768 standing with Israel. Voted for Israel Security Supplemental including Iron Dome/Iron Beam/David''s Sling replenishment and UNRWA funding ban (https://lalota.house.gov/media/press-releases/lalotaisraelsupport1). Dedicated "Stand with Israel" campaign page (https://www.nicklalota.com/stand-with-israel).'
  FROM people p WHERE p.name = 'Nick LaLota' AND p.website = 'https://lalota.house.gov'
  ON CONFLICT (person_id, topic_id, assessment_type) DO NOTHING;
INSERT INTO research_log (person_id, topic_id, researched_at, pass_number, result, notes)
  SELECT p.id, (SELECT id FROM topics WHERE slug = 'israel'), NOW(), 1, 'found', 'Federal delegation research'
  FROM people p WHERE p.name = 'Nick LaLota' AND p.website = 'https://lalota.house.gov'
  ON CONFLICT (person_id, topic_id, pass_number) DO NOTHING;
INSERT INTO person_criteria (person_id, criterion_id, evidence)
  SELECT p.id, 6, 'Voted for H.R. 6126, Israel Security Supplemental Appropriations Act ($14.3B). Voted for H.Res.768 standing with Israel. Voted for Israel Security Supplemental including Iron Dome/Iron Beam/David''''s S'
  FROM people p WHERE p.name = 'Nick LaLota' AND p.website = 'https://lalota.house.gov'
  ON CONFLICT (person_id, criterion_id) DO NOTHING;
INSERT INTO person_criteria (person_id, criterion_id, evidence)
  SELECT p.id, 12, 'Voted for H.R. 6126, Israel Security Supplemental Appropriations Act ($14.3B). Voted for H.Res.768 standing with Israel. Voted for Israel Security Supplemental including Iron Dome/Iron Beam/David''''s S'
  FROM people p WHERE p.name = 'Nick LaLota' AND p.website = 'https://lalota.house.gov'
  ON CONFLICT (person_id, criterion_id) DO NOTHING;
INSERT INTO person_criteria (person_id, criterion_id, evidence)
  SELECT p.id, 16, 'Voted for H.R. 6126, Israel Security Supplemental Appropriations Act ($14.3B). Voted for H.Res.768 standing with Israel. Voted for Israel Security Supplemental including Iron Dome/Iron Beam/David''''s S'
  FROM people p WHERE p.name = 'Nick LaLota' AND p.website = 'https://lalota.house.gov'
  ON CONFLICT (person_id, criterion_id) DO NOTHING;

INSERT INTO people (name, party, website) VALUES ('Andrew Garbarino', 'Republican', 'https://garbarino.house.gov');
INSERT INTO terms (person_id, seat_id, is_current, start_date, end_date)
  SELECT p.id, s.id, true, '2025-01-03', '2027-01-03'
  FROM people p, seats s
  WHERE p.name = 'Andrew Garbarino' AND p.website = 'https://garbarino.house.gov'
    AND s.chamber = 'us_house' AND s.district = 2;
INSERT INTO positions (person_id, topic_id, stance, confidence, assessment_type, rationale, summary)
  SELECT p.id, (SELECT id FROM topics WHERE slug = 'israel'), 'strongly_support', 'inferred', 'ai', 'Voted for H.Res.768 standing with Israel and supported Israel security supplemental funding. Consistent Republican pro-Israel voting record with no public dissent on any Israel-related measure.', 'Voted for H.Res.768, standing with Israel as it defends itself against Hamas (https://www.congress.gov/bill/118th-congress/house-resolution/768/text). Voted for Israel security supplemental appropriations. No public statements critical of Israel''s conduct in Gaza found.'
  FROM people p WHERE p.name = 'Andrew Garbarino' AND p.website = 'https://garbarino.house.gov'
  ON CONFLICT (person_id, topic_id, assessment_type) DO NOTHING;
INSERT INTO research_log (person_id, topic_id, researched_at, pass_number, result, notes)
  SELECT p.id, (SELECT id FROM topics WHERE slug = 'israel'), NOW(), 1, 'found', 'Federal delegation research'
  FROM people p WHERE p.name = 'Andrew Garbarino' AND p.website = 'https://garbarino.house.gov'
  ON CONFLICT (person_id, topic_id, pass_number) DO NOTHING;
INSERT INTO person_criteria (person_id, criterion_id, evidence)
  SELECT p.id, 6, 'Voted for H.Res.768, standing with Israel as it defends itself against Hamas (https://www.congress.gov/bill/118th-congress/house-resolution/768/text). Voted for Israel security supplemental appropriat'
  FROM people p WHERE p.name = 'Andrew Garbarino' AND p.website = 'https://garbarino.house.gov'
  ON CONFLICT (person_id, criterion_id) DO NOTHING;
INSERT INTO person_criteria (person_id, criterion_id, evidence)
  SELECT p.id, 12, 'Voted for H.Res.768, standing with Israel as it defends itself against Hamas (https://www.congress.gov/bill/118th-congress/house-resolution/768/text). Voted for Israel security supplemental appropriat'
  FROM people p WHERE p.name = 'Andrew Garbarino' AND p.website = 'https://garbarino.house.gov'
  ON CONFLICT (person_id, criterion_id) DO NOTHING;
INSERT INTO person_criteria (person_id, criterion_id, evidence)
  SELECT p.id, 16, 'Voted for H.Res.768, standing with Israel as it defends itself against Hamas (https://www.congress.gov/bill/118th-congress/house-resolution/768/text). Voted for Israel security supplemental appropriat'
  FROM people p WHERE p.name = 'Andrew Garbarino' AND p.website = 'https://garbarino.house.gov'
  ON CONFLICT (person_id, criterion_id) DO NOTHING;

INSERT INTO people (name, party, website) VALUES ('Tom Suozzi', 'Democratic', 'https://suozzi.house.gov');
INSERT INTO terms (person_id, seat_id, is_current, start_date, end_date)
  SELECT p.id, s.id, true, '2025-01-03', '2027-01-03'
  FROM people p, seats s
  WHERE p.name = 'Tom Suozzi' AND p.website = 'https://suozzi.house.gov'
    AND s.chamber = 'us_house' AND s.district = 3;
INSERT INTO positions (person_id, topic_id, stance, confidence, assessment_type, rationale, summary)
  SELECT p.id, (SELECT id FROM topics WHERE slug = 'israel'), 'strongly_support', 'inferred', 'ai', '"Longtime stalwart supporter of Israel" who won his 2024 special election in part on pro-Israel positioning. Backed by DMFI (pro-Israel Democratic PAC). Supported Israel-only supplemental that many Democrats opposed, while also backing humanitarian aid for Gaza.', 'Strong pro-Israel stance central to 2024 special election campaign (https://forward.com/news/582360/tom-suozzi-israel-santos-pilip/). Endorsed by pro-Israel DMFI PAC (https://theintercept.com/2024/02/09/ny-democrat-tom-suozzi-israel/). Supported Republican bill for additional Israel assistance, breaking with Democratic leadership. Called for UNRWA chief resignation while supporting humanitarian aid to Gaza (https://suozzi.house.gov/media/in-the-news/tom-suozzi-finds-comfort-zone-political-middle'
  FROM people p WHERE p.name = 'Tom Suozzi' AND p.website = 'https://suozzi.house.gov'
  ON CONFLICT (person_id, topic_id, assessment_type) DO NOTHING;
INSERT INTO research_log (person_id, topic_id, researched_at, pass_number, result, notes)
  SELECT p.id, (SELECT id FROM topics WHERE slug = 'israel'), NOW(), 1, 'found', 'Federal delegation research'
  FROM people p WHERE p.name = 'Tom Suozzi' AND p.website = 'https://suozzi.house.gov'
  ON CONFLICT (person_id, topic_id, pass_number) DO NOTHING;
INSERT INTO person_criteria (person_id, criterion_id, evidence)
  SELECT p.id, 6, 'Strong pro-Israel stance central to 2024 special election campaign (https://forward.com/news/582360/tom-suozzi-israel-santos-pilip/). Endorsed by pro-Israel DMFI PAC (https://theintercept.com/2024/02/'
  FROM people p WHERE p.name = 'Tom Suozzi' AND p.website = 'https://suozzi.house.gov'
  ON CONFLICT (person_id, criterion_id) DO NOTHING;
INSERT INTO person_criteria (person_id, criterion_id, evidence)
  SELECT p.id, 12, 'Strong pro-Israel stance central to 2024 special election campaign (https://forward.com/news/582360/tom-suozzi-israel-santos-pilip/). Endorsed by pro-Israel DMFI PAC (https://theintercept.com/2024/02/'
  FROM people p WHERE p.name = 'Tom Suozzi' AND p.website = 'https://suozzi.house.gov'
  ON CONFLICT (person_id, criterion_id) DO NOTHING;
INSERT INTO person_criteria (person_id, criterion_id, evidence)
  SELECT p.id, 14, 'Strong pro-Israel stance central to 2024 special election campaign (https://forward.com/news/582360/tom-suozzi-israel-santos-pilip/). Endorsed by pro-Israel DMFI PAC (https://theintercept.com/2024/02/'
  FROM people p WHERE p.name = 'Tom Suozzi' AND p.website = 'https://suozzi.house.gov'
  ON CONFLICT (person_id, criterion_id) DO NOTHING;
INSERT INTO person_criteria (person_id, criterion_id, evidence)
  SELECT p.id, 16, 'Strong pro-Israel stance central to 2024 special election campaign (https://forward.com/news/582360/tom-suozzi-israel-santos-pilip/). Endorsed by pro-Israel DMFI PAC (https://theintercept.com/2024/02/'
  FROM people p WHERE p.name = 'Tom Suozzi' AND p.website = 'https://suozzi.house.gov'
  ON CONFLICT (person_id, criterion_id) DO NOTHING;

INSERT INTO people (name, party, website) VALUES ('Laura Gillen', 'Democratic', 'https://gillen.house.gov');
INSERT INTO terms (person_id, seat_id, is_current, start_date, end_date)
  SELECT p.id, s.id, true, '2025-01-03', '2027-01-03'
  FROM people p, seats s
  WHERE p.name = 'Laura Gillen' AND p.website = 'https://gillen.house.gov'
    AND s.chamber = 'us_house' AND s.district = 4;
INSERT INTO positions (person_id, topic_id, stance, confidence, assessment_type, rationale, summary)
  SELECT p.id, (SELECT id FROM topics WHERE slug = 'israel'), 'strongly_support', 'inferred', 'ai', 'Describes herself as "consistent and unequivocal" in support for Israel. Visited Israel on congressional trip, touted bipartisan support for strong U.S.-Israel relationship. Called for aggressive stance against Iran. Released antisemitism action plan. Represents Long Island district with significant Jewish population.', 'Visited Israel in 2025, returned "doubly committed to a strong U.S.-Israel relationship" (https://jewishinsider.com/2025/08/laura-gillen-israel-visit-u-s-allies-gaza-war-hostages-aid/). Called for U.S. to "get more hawkish and get more aggressive against Iran" (https://jewishinsider.com/2025/02/freshman-democratic-rep-laura-gillen-iran-trump-nuclear-deal/). Outlined antisemitism action plan (https://www.liherald.com/merrick/stories/antisemitism-action-plan-unveiled,209809). Supports two-state so'
  FROM people p WHERE p.name = 'Laura Gillen' AND p.website = 'https://gillen.house.gov'
  ON CONFLICT (person_id, topic_id, assessment_type) DO NOTHING;
INSERT INTO research_log (person_id, topic_id, researched_at, pass_number, result, notes)
  SELECT p.id, (SELECT id FROM topics WHERE slug = 'israel'), NOW(), 1, 'found', 'Federal delegation research'
  FROM people p WHERE p.name = 'Laura Gillen' AND p.website = 'https://gillen.house.gov'
  ON CONFLICT (person_id, topic_id, pass_number) DO NOTHING;
INSERT INTO person_criteria (person_id, criterion_id, evidence)
  SELECT p.id, 6, 'Visited Israel in 2025, returned "doubly committed to a strong U.S.-Israel relationship" (https://jewishinsider.com/2025/08/laura-gillen-israel-visit-u-s-allies-gaza-war-hostages-aid/). Called for U.S'
  FROM people p WHERE p.name = 'Laura Gillen' AND p.website = 'https://gillen.house.gov'
  ON CONFLICT (person_id, criterion_id) DO NOTHING;
INSERT INTO person_criteria (person_id, criterion_id, evidence)
  SELECT p.id, 12, 'Visited Israel in 2025, returned "doubly committed to a strong U.S.-Israel relationship" (https://jewishinsider.com/2025/08/laura-gillen-israel-visit-u-s-allies-gaza-war-hostages-aid/). Called for U.S'
  FROM people p WHERE p.name = 'Laura Gillen' AND p.website = 'https://gillen.house.gov'
  ON CONFLICT (person_id, criterion_id) DO NOTHING;
INSERT INTO person_criteria (person_id, criterion_id, evidence)
  SELECT p.id, 14, 'Visited Israel in 2025, returned "doubly committed to a strong U.S.-Israel relationship" (https://jewishinsider.com/2025/08/laura-gillen-israel-visit-u-s-allies-gaza-war-hostages-aid/). Called for U.S'
  FROM people p WHERE p.name = 'Laura Gillen' AND p.website = 'https://gillen.house.gov'
  ON CONFLICT (person_id, criterion_id) DO NOTHING;
INSERT INTO person_criteria (person_id, criterion_id, evidence)
  SELECT p.id, 16, 'Visited Israel in 2025, returned "doubly committed to a strong U.S.-Israel relationship" (https://jewishinsider.com/2025/08/laura-gillen-israel-visit-u-s-allies-gaza-war-hostages-aid/). Called for U.S'
  FROM people p WHERE p.name = 'Laura Gillen' AND p.website = 'https://gillen.house.gov'
  ON CONFLICT (person_id, criterion_id) DO NOTHING;

INSERT INTO people (name, party, website) VALUES ('Gregory Meeks', 'Democratic', 'https://meeks.house.gov');
INSERT INTO terms (person_id, seat_id, is_current, start_date, end_date)
  SELECT p.id, s.id, true, '2025-01-03', '2027-01-03'
  FROM people p, seats s
  WHERE p.name = 'Gregory Meeks' AND p.website = 'https://meeks.house.gov'
    AND s.chamber = 'us_house' AND s.district = 5;
INSERT INTO positions (person_id, topic_id, stance, confidence, assessment_type, rationale, summary)
  SELECT p.id, (SELECT id FROM topics WHERE slug = 'israel'), 'support', 'inferred', 'ai', 'As Ranking Member of House Foreign Affairs Committee, generally supports Israel but with nuance. Voted no on Israel-only supplemental (wanted comprehensive package with Gaza humanitarian aid). Initially tried to hold up F-15 sale to Israel but backed down under Biden administration pressure. Criticized Netanyahu for rejecting two-state solution.', 'Voted NO on Republican Israel-only supplemental because it stripped humanitarian aid for Gaza (https://democrats-foreignaffairs.house.gov/2024/2/meeks-issues-statement-announcing-no-vote-on-israel-only-supplemental). Backed $18B F-15 sale to Israel after initially seeking "assurances" (https://mondoweiss.net/2024/06/the-shift-under-pressure-from-biden-meeks-backs-major-arms-sale-to-israel/). Criticized Netanyahu for dismissing two-state solution (https://democrats-foreignaffairs.house.gov/2024/7'
  FROM people p WHERE p.name = 'Gregory Meeks' AND p.website = 'https://meeks.house.gov'
  ON CONFLICT (person_id, topic_id, assessment_type) DO NOTHING;
INSERT INTO research_log (person_id, topic_id, researched_at, pass_number, result, notes)
  SELECT p.id, (SELECT id FROM topics WHERE slug = 'israel'), NOW(), 1, 'found', 'Federal delegation research'
  FROM people p WHERE p.name = 'Gregory Meeks' AND p.website = 'https://meeks.house.gov'
  ON CONFLICT (person_id, topic_id, pass_number) DO NOTHING;
INSERT INTO person_criteria (person_id, criterion_id, evidence)
  SELECT p.id, 6, 'Voted NO on Republican Israel-only supplemental because it stripped humanitarian aid for Gaza (https://democrats-foreignaffairs.house.gov/2024/2/meeks-issues-statement-announcing-no-vote-on-israel-onl'
  FROM people p WHERE p.name = 'Gregory Meeks' AND p.website = 'https://meeks.house.gov'
  ON CONFLICT (person_id, criterion_id) DO NOTHING;
INSERT INTO person_criteria (person_id, criterion_id, evidence)
  SELECT p.id, 12, 'Voted NO on Republican Israel-only supplemental because it stripped humanitarian aid for Gaza (https://democrats-foreignaffairs.house.gov/2024/2/meeks-issues-statement-announcing-no-vote-on-israel-onl'
  FROM people p WHERE p.name = 'Gregory Meeks' AND p.website = 'https://meeks.house.gov'
  ON CONFLICT (person_id, criterion_id) DO NOTHING;
INSERT INTO person_criteria (person_id, criterion_id, evidence)
  SELECT p.id, 16, 'Voted NO on Republican Israel-only supplemental because it stripped humanitarian aid for Gaza (https://democrats-foreignaffairs.house.gov/2024/2/meeks-issues-statement-announcing-no-vote-on-israel-onl'
  FROM people p WHERE p.name = 'Gregory Meeks' AND p.website = 'https://meeks.house.gov'
  ON CONFLICT (person_id, criterion_id) DO NOTHING;

INSERT INTO people (name, party, website) VALUES ('Grace Meng', 'Democratic', 'https://meng.house.gov');
INSERT INTO terms (person_id, seat_id, is_current, start_date, end_date)
  SELECT p.id, s.id, true, '2025-01-03', '2027-01-03'
  FROM people p, seats s
  WHERE p.name = 'Grace Meng' AND p.website = 'https://meng.house.gov'
    AND s.chamber = 'us_house' AND s.district = 6;
INSERT INTO positions (person_id, topic_id, stance, confidence, assessment_type, rationale, summary)
  SELECT p.id, (SELECT id FROM topics WHERE slug = 'israel'), 'support', 'inferred', 'ai', 'Strong pro-Israel stance since Oct 7, attending vigils with Jewish leaders. Voted for Israel Security Supplemental Act. Refused constituent calls for ceasefire, arguing a return to pre-Oct 7 ceasefire would let Hamas regroup. Supports humanitarian pauses but not permanent ceasefire.', 'Voted for Israel Security Supplemental Act (https://meng.house.gov/media-center/press-releases/statement-congresswoman-meng-israel-security-supplemental-act). Refused to support ceasefire despite constituent pressure at heated Zoom meeting (https://qns.com/2024/01/congresswoman-meng-backlash-gaza-ceasefire-stance/). Attended vigils with Jewish leaders after Oct 7. Led bipartisan call to protect humanitarian aid delivery to Gaza from unvetted Turkish flotilla. Received $85,250 from AIPAC in 2023-'
  FROM people p WHERE p.name = 'Grace Meng' AND p.website = 'https://meng.house.gov'
  ON CONFLICT (person_id, topic_id, assessment_type) DO NOTHING;
INSERT INTO research_log (person_id, topic_id, researched_at, pass_number, result, notes)
  SELECT p.id, (SELECT id FROM topics WHERE slug = 'israel'), NOW(), 1, 'found', 'Federal delegation research'
  FROM people p WHERE p.name = 'Grace Meng' AND p.website = 'https://meng.house.gov'
  ON CONFLICT (person_id, topic_id, pass_number) DO NOTHING;
INSERT INTO person_criteria (person_id, criterion_id, evidence)
  SELECT p.id, 6, 'Voted for Israel Security Supplemental Act (https://meng.house.gov/media-center/press-releases/statement-congresswoman-meng-israel-security-supplemental-act). Refused to support ceasefire despite cons'
  FROM people p WHERE p.name = 'Grace Meng' AND p.website = 'https://meng.house.gov'
  ON CONFLICT (person_id, criterion_id) DO NOTHING;
INSERT INTO person_criteria (person_id, criterion_id, evidence)
  SELECT p.id, 12, 'Voted for Israel Security Supplemental Act (https://meng.house.gov/media-center/press-releases/statement-congresswoman-meng-israel-security-supplemental-act). Refused to support ceasefire despite cons'
  FROM people p WHERE p.name = 'Grace Meng' AND p.website = 'https://meng.house.gov'
  ON CONFLICT (person_id, criterion_id) DO NOTHING;
INSERT INTO person_criteria (person_id, criterion_id, evidence)
  SELECT p.id, 14, 'Voted for Israel Security Supplemental Act (https://meng.house.gov/media-center/press-releases/statement-congresswoman-meng-israel-security-supplemental-act). Refused to support ceasefire despite cons'
  FROM people p WHERE p.name = 'Grace Meng' AND p.website = 'https://meng.house.gov'
  ON CONFLICT (person_id, criterion_id) DO NOTHING;

INSERT INTO people (name, party, website) VALUES ('Nydia Velazquez', 'Democratic', 'https://velazquez.house.gov');
INSERT INTO terms (person_id, seat_id, is_current, start_date, end_date)
  SELECT p.id, s.id, true, '2025-01-03', '2027-01-03'
  FROM people p, seats s
  WHERE p.name = 'Nydia Velazquez' AND p.website = 'https://velazquez.house.gov'
    AND s.chamber = 'us_house' AND s.district = 7;
INSERT INTO positions (person_id, topic_id, stance, confidence, assessment_type, rationale, summary)
  SELECT p.id, (SELECT id FROM topics WHERE slug = 'israel'), 'oppose', 'inferred', 'ai', 'One of the more critical voices on Israel in the NY delegation. Voted against Israel Security Supplemental, arguing continued military aid makes Congress "complicit in the tragedy." Called for permanent ceasefire and de-escalation. Boycotted Netanyahu''s joint address to Congress. Voted "present" on resolution supporting Israel. Supports Palestinian self-determination.', 'Voted against H.R. 8034, Israel Security Supplemental, saying Congress would be "complicit in the tragedy" (https://velazquez.house.gov/media-center/press-releases/statement-velazquez-castro-doggett-jayapal-khanna-ocasio-cortez-balint). Voted "present" on McCaul-Meeks resolution supporting Israel (https://velazquez.house.gov/media-center/press-releases/velazquezs-statement-mccaul-meeks-resolution). Boycotted Netanyahu''s address to Congress (https://velazquez.house.gov/media-center/press-releases'
  FROM people p WHERE p.name = 'Nydia Velazquez' AND p.website = 'https://velazquez.house.gov'
  ON CONFLICT (person_id, topic_id, assessment_type) DO NOTHING;
INSERT INTO research_log (person_id, topic_id, researched_at, pass_number, result, notes)
  SELECT p.id, (SELECT id FROM topics WHERE slug = 'israel'), NOW(), 1, 'found', 'Federal delegation research'
  FROM people p WHERE p.name = 'Nydia Velazquez' AND p.website = 'https://velazquez.house.gov'
  ON CONFLICT (person_id, topic_id, pass_number) DO NOTHING;
INSERT INTO person_criteria (person_id, criterion_id, evidence)
  SELECT p.id, 11, 'Voted against H.R. 8034, Israel Security Supplemental, saying Congress would be "complicit in the tragedy" (https://velazquez.house.gov/media-center/press-releases/statement-velazquez-castro-doggett-j'
  FROM people p WHERE p.name = 'Nydia Velazquez' AND p.website = 'https://velazquez.house.gov'
  ON CONFLICT (person_id, criterion_id) DO NOTHING;
INSERT INTO person_criteria (person_id, criterion_id, evidence)
  SELECT p.id, 8, 'Voted against H.R. 8034, Israel Security Supplemental, saying Congress would be "complicit in the tragedy" (https://velazquez.house.gov/media-center/press-releases/statement-velazquez-castro-doggett-j'
  FROM people p WHERE p.name = 'Nydia Velazquez' AND p.website = 'https://velazquez.house.gov'
  ON CONFLICT (person_id, criterion_id) DO NOTHING;

INSERT INTO people (name, party, website) VALUES ('Hakeem Jeffries', 'Democratic', 'https://jeffries.house.gov');
INSERT INTO terms (person_id, seat_id, is_current, start_date, end_date)
  SELECT p.id, s.id, true, '2025-01-03', '2027-01-03'
  FROM people p, seats s
  WHERE p.name = 'Hakeem Jeffries' AND p.website = 'https://jeffries.house.gov'
    AND s.chamber = 'us_house' AND s.district = 8;
INSERT INTO positions (person_id, topic_id, stance, confidence, assessment_type, rationale, summary)
  SELECT p.id, (SELECT id FROM topics WHERE slug = 'israel'), 'strongly_support', 'inferred', 'ai', 'As House Democratic Leader, has been one of the strongest pro-Israel voices in the Democratic caucus. Called for Hamas to be "decisively defeated," opposed conditions on US aid to Israel, and pushed back on progressives seeking to cut aid. Took multiple trips to Israel. Reliable supporter of Israeli military campaigns.', 'Called for Hamas to be "decisively defeated" (https://jewishinsider.com/2024/03/hakeem-jeffries-israel-gaza-hamas-biden/). Pushed back on Democratic calls to condition aid to Israel (https://www.cbsnews.com/news/hakeem-jeffries-talks-israel-house-republicans-upcoming-election-60-minutes-transcript/). Took multiple trips to Israel (https://jewishcurrents.org/another-trip-to-israel-for-hakeem-jeffries). Opposed conditions on US aid. Marked one year since Oct 7 with strong statement (https://jeffri'
  FROM people p WHERE p.name = 'Hakeem Jeffries' AND p.website = 'https://jeffries.house.gov'
  ON CONFLICT (person_id, topic_id, assessment_type) DO NOTHING;
INSERT INTO research_log (person_id, topic_id, researched_at, pass_number, result, notes)
  SELECT p.id, (SELECT id FROM topics WHERE slug = 'israel'), NOW(), 1, 'found', 'Federal delegation research'
  FROM people p WHERE p.name = 'Hakeem Jeffries' AND p.website = 'https://jeffries.house.gov'
  ON CONFLICT (person_id, topic_id, pass_number) DO NOTHING;
INSERT INTO person_criteria (person_id, criterion_id, evidence)
  SELECT p.id, 6, 'Called for Hamas to be "decisively defeated" (https://jewishinsider.com/2024/03/hakeem-jeffries-israel-gaza-hamas-biden/). Pushed back on Democratic calls to condition aid to Israel (https://www.cbsne'
  FROM people p WHERE p.name = 'Hakeem Jeffries' AND p.website = 'https://jeffries.house.gov'
  ON CONFLICT (person_id, criterion_id) DO NOTHING;
INSERT INTO person_criteria (person_id, criterion_id, evidence)
  SELECT p.id, 12, 'Called for Hamas to be "decisively defeated" (https://jewishinsider.com/2024/03/hakeem-jeffries-israel-gaza-hamas-biden/). Pushed back on Democratic calls to condition aid to Israel (https://www.cbsne'
  FROM people p WHERE p.name = 'Hakeem Jeffries' AND p.website = 'https://jeffries.house.gov'
  ON CONFLICT (person_id, criterion_id) DO NOTHING;
INSERT INTO person_criteria (person_id, criterion_id, evidence)
  SELECT p.id, 14, 'Called for Hamas to be "decisively defeated" (https://jewishinsider.com/2024/03/hakeem-jeffries-israel-gaza-hamas-biden/). Pushed back on Democratic calls to condition aid to Israel (https://www.cbsne'
  FROM people p WHERE p.name = 'Hakeem Jeffries' AND p.website = 'https://jeffries.house.gov'
  ON CONFLICT (person_id, criterion_id) DO NOTHING;
INSERT INTO person_criteria (person_id, criterion_id, evidence)
  SELECT p.id, 16, 'Called for Hamas to be "decisively defeated" (https://jewishinsider.com/2024/03/hakeem-jeffries-israel-gaza-hamas-biden/). Pushed back on Democratic calls to condition aid to Israel (https://www.cbsne'
  FROM people p WHERE p.name = 'Hakeem Jeffries' AND p.website = 'https://jeffries.house.gov'
  ON CONFLICT (person_id, criterion_id) DO NOTHING;

INSERT INTO people (name, party, website) VALUES ('Yvette Clarke', 'Democratic', 'https://clarke.house.gov');
INSERT INTO terms (person_id, seat_id, is_current, start_date, end_date)
  SELECT p.id, s.id, true, '2025-01-03', '2027-01-03'
  FROM people p, seats s
  WHERE p.name = 'Yvette Clarke' AND p.website = 'https://clarke.house.gov'
    AND s.chamber = 'us_house' AND s.district = 9;
INSERT INTO positions (person_id, topic_id, stance, confidence, assessment_type, rationale, summary)
  SELECT p.id, (SELECT id FROM topics WHERE slug = 'israel'), 'support', 'inferred', 'ai', 'Has described herself as a "fierce defender" of Israel and voted for Israel security supplemental including UNRWA funding ban. However, later called the situation a "moral catastrophe" and voted against H.Res.867. Did not sign ceasefire resolutions despite constituent pressure, but shifted messaging toward acknowledging Palestinian suffering.', 'Voted for H.R. 8034 sending billions in weapons to Israel and banning UNRWA funding. Voted against H.Res.867 (https://clarke.house.gov/congresswoman-yvette-d-clarke-votes-against-h-res-867/). Called situation a "moral catastrophe" in July 2024 statement. Previously promised to remain "fierce defender" of Israel (https://jewishinsider.com/2020/06/rep-yvette-clarke-promises-to-remain-a-fierce-defender-of-israel/). Did not sign ceasefire resolutions despite Brooklyn constituent pressure (https://ww'
  FROM people p WHERE p.name = 'Yvette Clarke' AND p.website = 'https://clarke.house.gov'
  ON CONFLICT (person_id, topic_id, assessment_type) DO NOTHING;
INSERT INTO research_log (person_id, topic_id, researched_at, pass_number, result, notes)
  SELECT p.id, (SELECT id FROM topics WHERE slug = 'israel'), NOW(), 1, 'found', 'Federal delegation research'
  FROM people p WHERE p.name = 'Yvette Clarke' AND p.website = 'https://clarke.house.gov'
  ON CONFLICT (person_id, topic_id, pass_number) DO NOTHING;
INSERT INTO person_criteria (person_id, criterion_id, evidence)
  SELECT p.id, 6, 'Voted for H.R. 8034 sending billions in weapons to Israel and banning UNRWA funding. Voted against H.Res.867 (https://clarke.house.gov/congresswoman-yvette-d-clarke-votes-against-h-res-867/). Called s'
  FROM people p WHERE p.name = 'Yvette Clarke' AND p.website = 'https://clarke.house.gov'
  ON CONFLICT (person_id, criterion_id) DO NOTHING;
INSERT INTO person_criteria (person_id, criterion_id, evidence)
  SELECT p.id, 12, 'Voted for H.R. 8034 sending billions in weapons to Israel and banning UNRWA funding. Voted against H.Res.867 (https://clarke.house.gov/congresswoman-yvette-d-clarke-votes-against-h-res-867/). Called s'
  FROM people p WHERE p.name = 'Yvette Clarke' AND p.website = 'https://clarke.house.gov'
  ON CONFLICT (person_id, criterion_id) DO NOTHING;

INSERT INTO people (name, party, website) VALUES ('Dan Goldman', 'Democratic', 'https://goldman.house.gov');
INSERT INTO terms (person_id, seat_id, is_current, start_date, end_date)
  SELECT p.id, s.id, true, '2025-01-03', '2027-01-03'
  FROM people p, seats s
  WHERE p.name = 'Dan Goldman' AND p.website = 'https://goldman.house.gov'
    AND s.chamber = 'us_house' AND s.district = 10;
INSERT INTO positions (person_id, topic_id, stance, confidence, assessment_type, rationale, summary)
  SELECT p.id, (SELECT id FROM topics WHERE slug = 'israel'), 'support', 'inferred', 'ai', 'Strong supporter of Israel who voted to censure Rep. Tlaib and signed effort to discredit ICJ genocide case against Israel. However, called for temporary ceasefire with other Jewish Democratic members, supports humanitarian aid to Palestinians, and acknowledged civilian suffering. Refuses to use "genocide" label. Facing heated 2026 primary over pro-Israel stance.', 'Voted to censure Rep. Rashida Tlaib (one of 22 Democrats) (https://theintercept.com/2024/02/01/dan-goldman-icj-israel-genocide/). Signed effort to discredit South Africa''s ICJ genocide case. Called for temporary ceasefire with 11 other Jewish Democratic members (https://www.cityandstateny.com/politics/2024/02/goldman-and-nadler-call-temporary-ceasefire-gaza/394370/). Expressed "disgust" at ICJ genocide case. Received $45,400 from AIPAC PAC. Defending pro-Israel stance in 2026 primary (https://ww'
  FROM people p WHERE p.name = 'Dan Goldman' AND p.website = 'https://goldman.house.gov'
  ON CONFLICT (person_id, topic_id, assessment_type) DO NOTHING;
INSERT INTO research_log (person_id, topic_id, researched_at, pass_number, result, notes)
  SELECT p.id, (SELECT id FROM topics WHERE slug = 'israel'), NOW(), 1, 'found', 'Federal delegation research'
  FROM people p WHERE p.name = 'Dan Goldman' AND p.website = 'https://goldman.house.gov'
  ON CONFLICT (person_id, topic_id, pass_number) DO NOTHING;
INSERT INTO person_criteria (person_id, criterion_id, evidence)
  SELECT p.id, 6, 'Voted to censure Rep. Rashida Tlaib (one of 22 Democrats) (https://theintercept.com/2024/02/01/dan-goldman-icj-israel-genocide/). Signed effort to discredit South Africa''''s ICJ genocide case. Called f'
  FROM people p WHERE p.name = 'Dan Goldman' AND p.website = 'https://goldman.house.gov'
  ON CONFLICT (person_id, criterion_id) DO NOTHING;
INSERT INTO person_criteria (person_id, criterion_id, evidence)
  SELECT p.id, 12, 'Voted to censure Rep. Rashida Tlaib (one of 22 Democrats) (https://theintercept.com/2024/02/01/dan-goldman-icj-israel-genocide/). Signed effort to discredit South Africa''''s ICJ genocide case. Called f'
  FROM people p WHERE p.name = 'Dan Goldman' AND p.website = 'https://goldman.house.gov'
  ON CONFLICT (person_id, criterion_id) DO NOTHING;
INSERT INTO person_criteria (person_id, criterion_id, evidence)
  SELECT p.id, 16, 'Voted to censure Rep. Rashida Tlaib (one of 22 Democrats) (https://theintercept.com/2024/02/01/dan-goldman-icj-israel-genocide/). Signed effort to discredit South Africa''''s ICJ genocide case. Called f'
  FROM people p WHERE p.name = 'Dan Goldman' AND p.website = 'https://goldman.house.gov'
  ON CONFLICT (person_id, criterion_id) DO NOTHING;

INSERT INTO people (name, party, website) VALUES ('Nicole Malliotakis', 'Republican', 'https://malliotakis.house.gov');
INSERT INTO terms (person_id, seat_id, is_current, start_date, end_date)
  SELECT p.id, s.id, true, '2025-01-03', '2027-01-03'
  FROM people p, seats s
  WHERE p.name = 'Nicole Malliotakis' AND p.website = 'https://malliotakis.house.gov'
    AND s.chamber = 'us_house' AND s.district = 11;
INSERT INTO positions (person_id, topic_id, stance, confidence, assessment_type, rationale, summary)
  SELECT p.id, (SELECT id FROM topics WHERE slug = 'israel'), 'strongly_support', 'inferred', 'ai', 'Consistent and vocal supporter of Israel. Cosponsored H.Res.768 and H.R.6126 Israel Security Supplemental. Visited Israel and reported Israeli leaders'' concerns about U.S. support. Attended Netanyahu''s joint address. Received $15,000 from pro-Israel PACs in 2024.', 'Cosponsored H.Res.768 standing with Israel and H.R.6126 Israel Security Supplemental (https://www.congress.gov/bill/118th-congress/house-resolution/768/cosponsors). Cosponsored H.R.6118 Stand with Israel Act. Visited Israel, reported Israeli leaders'' security concerns (https://malliotakis.house.gov/media/in-the-news/after-israel-visit-malliotakis-says-israeli-leaders-have-serious-concerns-about). Attended and praised Netanyahu''s address to Congress (https://malliotakis.house.gov/media/press-rele'
  FROM people p WHERE p.name = 'Nicole Malliotakis' AND p.website = 'https://malliotakis.house.gov'
  ON CONFLICT (person_id, topic_id, assessment_type) DO NOTHING;
INSERT INTO research_log (person_id, topic_id, researched_at, pass_number, result, notes)
  SELECT p.id, (SELECT id FROM topics WHERE slug = 'israel'), NOW(), 1, 'found', 'Federal delegation research'
  FROM people p WHERE p.name = 'Nicole Malliotakis' AND p.website = 'https://malliotakis.house.gov'
  ON CONFLICT (person_id, topic_id, pass_number) DO NOTHING;
INSERT INTO person_criteria (person_id, criterion_id, evidence)
  SELECT p.id, 1, 'Cosponsored H.Res.768 standing with Israel and H.R.6126 Israel Security Supplemental (https://www.congress.gov/bill/118th-congress/house-resolution/768/cosponsors). Cosponsored H.R.6118 Stand with Isr'
  FROM people p WHERE p.name = 'Nicole Malliotakis' AND p.website = 'https://malliotakis.house.gov'
  ON CONFLICT (person_id, criterion_id) DO NOTHING;
INSERT INTO person_criteria (person_id, criterion_id, evidence)
  SELECT p.id, 6, 'Cosponsored H.Res.768 standing with Israel and H.R.6126 Israel Security Supplemental (https://www.congress.gov/bill/118th-congress/house-resolution/768/cosponsors). Cosponsored H.R.6118 Stand with Isr'
  FROM people p WHERE p.name = 'Nicole Malliotakis' AND p.website = 'https://malliotakis.house.gov'
  ON CONFLICT (person_id, criterion_id) DO NOTHING;
INSERT INTO person_criteria (person_id, criterion_id, evidence)
  SELECT p.id, 12, 'Cosponsored H.Res.768 standing with Israel and H.R.6126 Israel Security Supplemental (https://www.congress.gov/bill/118th-congress/house-resolution/768/cosponsors). Cosponsored H.R.6118 Stand with Isr'
  FROM people p WHERE p.name = 'Nicole Malliotakis' AND p.website = 'https://malliotakis.house.gov'
  ON CONFLICT (person_id, criterion_id) DO NOTHING;
INSERT INTO person_criteria (person_id, criterion_id, evidence)
  SELECT p.id, 14, 'Cosponsored H.Res.768 standing with Israel and H.R.6126 Israel Security Supplemental (https://www.congress.gov/bill/118th-congress/house-resolution/768/cosponsors). Cosponsored H.R.6118 Stand with Isr'
  FROM people p WHERE p.name = 'Nicole Malliotakis' AND p.website = 'https://malliotakis.house.gov'
  ON CONFLICT (person_id, criterion_id) DO NOTHING;
INSERT INTO person_criteria (person_id, criterion_id, evidence)
  SELECT p.id, 16, 'Cosponsored H.Res.768 standing with Israel and H.R.6126 Israel Security Supplemental (https://www.congress.gov/bill/118th-congress/house-resolution/768/cosponsors). Cosponsored H.R.6118 Stand with Isr'
  FROM people p WHERE p.name = 'Nicole Malliotakis' AND p.website = 'https://malliotakis.house.gov'
  ON CONFLICT (person_id, criterion_id) DO NOTHING;

INSERT INTO people (name, party, website) VALUES ('Jerry Nadler', 'Democratic', 'https://nadler.house.gov');
INSERT INTO terms (person_id, seat_id, is_current, start_date, end_date)
  SELECT p.id, s.id, true, '2025-01-03', '2027-01-03'
  FROM people p, seats s
  WHERE p.name = 'Jerry Nadler' AND p.website = 'https://nadler.house.gov'
    AND s.chamber = 'us_house' AND s.district = 12;
INSERT INTO positions (person_id, topic_id, stance, confidence, assessment_type, rationale, summary)
  SELECT p.id, (SELECT id FROM topics WHERE slug = 'israel'), 'support', 'inferred', 'ai', 'Longtime supporter of Israel and strong two-state solution advocate. As a senior Jewish member of Congress, called for temporary ceasefire (not permanent) and humanitarian pauses. Voted for Israel military aid combined with humanitarian assistance. Condemns settler violence. Rejects "genocide" characterization but acknowledges humanitarian crisis.', 'Called for temporary ceasefire with 11 other Jewish Democratic members, explicitly opposing permanent ceasefire while Hamas controls Gaza (https://www.cityandstateny.com/politics/2024/02/goldman-and-nadler-call-temporary-ceasefire-gaza/394370/). Voted for Israel military aid and humanitarian assistance for Gaza. Condemns settler violence in West Bank. Has dedicated Israel/Foreign Affairs page on official site (https://nadler.house.gov/news/documentquery.aspx?IssueID=43459). Campaign site has ded'
  FROM people p WHERE p.name = 'Jerry Nadler' AND p.website = 'https://nadler.house.gov'
  ON CONFLICT (person_id, topic_id, assessment_type) DO NOTHING;
INSERT INTO research_log (person_id, topic_id, researched_at, pass_number, result, notes)
  SELECT p.id, (SELECT id FROM topics WHERE slug = 'israel'), NOW(), 1, 'found', 'Federal delegation research'
  FROM people p WHERE p.name = 'Jerry Nadler' AND p.website = 'https://nadler.house.gov'
  ON CONFLICT (person_id, topic_id, pass_number) DO NOTHING;
INSERT INTO person_criteria (person_id, criterion_id, evidence)
  SELECT p.id, 6, 'Called for temporary ceasefire with 11 other Jewish Democratic members, explicitly opposing permanent ceasefire while Hamas controls Gaza (https://www.cityandstateny.com/politics/2024/02/goldman-and-n'
  FROM people p WHERE p.name = 'Jerry Nadler' AND p.website = 'https://nadler.house.gov'
  ON CONFLICT (person_id, criterion_id) DO NOTHING;
INSERT INTO person_criteria (person_id, criterion_id, evidence)
  SELECT p.id, 12, 'Called for temporary ceasefire with 11 other Jewish Democratic members, explicitly opposing permanent ceasefire while Hamas controls Gaza (https://www.cityandstateny.com/politics/2024/02/goldman-and-n'
  FROM people p WHERE p.name = 'Jerry Nadler' AND p.website = 'https://nadler.house.gov'
  ON CONFLICT (person_id, criterion_id) DO NOTHING;
INSERT INTO person_criteria (person_id, criterion_id, evidence)
  SELECT p.id, 16, 'Called for temporary ceasefire with 11 other Jewish Democratic members, explicitly opposing permanent ceasefire while Hamas controls Gaza (https://www.cityandstateny.com/politics/2024/02/goldman-and-n'
  FROM people p WHERE p.name = 'Jerry Nadler' AND p.website = 'https://nadler.house.gov'
  ON CONFLICT (person_id, criterion_id) DO NOTHING;

INSERT INTO people (name, party, website) VALUES ('Adriano Espaillat', 'Democratic', 'https://espaillat.house.gov');
INSERT INTO terms (person_id, seat_id, is_current, start_date, end_date)
  SELECT p.id, s.id, true, '2025-01-03', '2027-01-03'
  FROM people p, seats s
  WHERE p.name = 'Adriano Espaillat' AND p.website = 'https://espaillat.house.gov'
    AND s.chamber = 'us_house' AND s.district = 13;
INSERT INTO positions (person_id, topic_id, stance, confidence, assessment_type, rationale, summary)
  SELECT p.id, (SELECT id FROM topics WHERE slug = 'israel'), 'support', 'inferred', 'ai', 'Supports Israel''s right to defend itself and backs Biden/Schumer approach. Calls for hostage release, humanitarian aid to Gaza, and two-state solution. Attended "Zionist Democrats" event at DNC. Accepted ~$30,000 from AIPAC. Facing DSA-backed challengers over his Israel stance. No evidence of voting against Israel aid measures.', 'Statement supporting Biden''s leadership and calling for hostage release, humanitarian aid, and two-state solution (https://espaillat.house.gov/media/press-releases/statement-representative-adriano-espaillat-israel-hamas-war). Attended "Zionist Democrats" event at 2024 DNC. Pro-Palestine protesters shut down his office (https://www.aa.com.tr/en/americas/pro-palestine-protestors-shut-down-office-of-new-york-rep-adriano-espaillat/3158603). Accepted ~$30,000 from AIPAC. Supported Schumer''s call for '
  FROM people p WHERE p.name = 'Adriano Espaillat' AND p.website = 'https://espaillat.house.gov'
  ON CONFLICT (person_id, topic_id, assessment_type) DO NOTHING;
INSERT INTO research_log (person_id, topic_id, researched_at, pass_number, result, notes)
  SELECT p.id, (SELECT id FROM topics WHERE slug = 'israel'), NOW(), 1, 'found', 'Federal delegation research'
  FROM people p WHERE p.name = 'Adriano Espaillat' AND p.website = 'https://espaillat.house.gov'
  ON CONFLICT (person_id, topic_id, pass_number) DO NOTHING;
INSERT INTO person_criteria (person_id, criterion_id, evidence)
  SELECT p.id, 12, 'Statement supporting Biden''''s leadership and calling for hostage release, humanitarian aid, and two-state solution (https://espaillat.house.gov/media/press-releases/statement-representative-adriano-es'
  FROM people p WHERE p.name = 'Adriano Espaillat' AND p.website = 'https://espaillat.house.gov'
  ON CONFLICT (person_id, criterion_id) DO NOTHING;
INSERT INTO person_criteria (person_id, criterion_id, evidence)
  SELECT p.id, 6, 'Statement supporting Biden''''s leadership and calling for hostage release, humanitarian aid, and two-state solution (https://espaillat.house.gov/media/press-releases/statement-representative-adriano-es'
  FROM people p WHERE p.name = 'Adriano Espaillat' AND p.website = 'https://espaillat.house.gov'
  ON CONFLICT (person_id, criterion_id) DO NOTHING;

INSERT INTO people (name, party, website) VALUES ('Alexandria Ocasio-Cortez', 'Democratic', 'https://ocasio-cortez.house.gov');
INSERT INTO terms (person_id, seat_id, is_current, start_date, end_date)
  SELECT p.id, s.id, true, '2025-01-03', '2027-01-03'
  FROM people p, seats s
  WHERE p.name = 'Alexandria Ocasio-Cortez' AND p.website = 'https://ocasio-cortez.house.gov'
    AND s.chamber = 'us_house' AND s.district = 14;
INSERT INTO positions (person_id, topic_id, stance, confidence, assessment_type, rationale, summary)
  SELECT p.id, (SELECT id FROM topics WHERE slug = 'israel'), 'strongly_oppose', 'inferred', 'ai', 'One of the most vocal critics of Israel''s military campaign in Gaza. Accused Israel of committing genocide in a House floor speech, called for U.S. arms embargo on Israel, and said unconditional aid "enabled a genocide." Voted against Israel Security Supplemental. However, voted against a Greene amendment to cut Iron Dome funding, drawing criticism from the left.', 'House floor speech accusing Israel of "unfolding genocide" and calling for weapons suspension (https://www.cnn.com/2024/03/24/politics/alexandria-ocasio-cortez-aoc-israel-gaza-genocide-cnntv). Said unconditional aid "enabled a genocide in Gaza" (https://thehill.com/homenews/house/5738391-ocasio-cortez-israel-gaza-genocide-biden/). Called for U.S. arms embargo on Israel (https://jewishinsider.com/2024/10/alexandria-ocasio-cortez-u-s-arms-embargo-israel/). Voted against Israel Security Supplementa'
  FROM people p WHERE p.name = 'Alexandria Ocasio-Cortez' AND p.website = 'https://ocasio-cortez.house.gov'
  ON CONFLICT (person_id, topic_id, assessment_type) DO NOTHING;
INSERT INTO research_log (person_id, topic_id, researched_at, pass_number, result, notes)
  SELECT p.id, (SELECT id FROM topics WHERE slug = 'israel'), NOW(), 1, 'found', 'Federal delegation research'
  FROM people p WHERE p.name = 'Alexandria Ocasio-Cortez' AND p.website = 'https://ocasio-cortez.house.gov'
  ON CONFLICT (person_id, topic_id, pass_number) DO NOTHING;
INSERT INTO person_criteria (person_id, criterion_id, evidence)
  SELECT p.id, 9, 'House floor speech accusing Israel of "unfolding genocide" and calling for weapons suspension (https://www.cnn.com/2024/03/24/politics/alexandria-ocasio-cortez-aoc-israel-gaza-genocide-cnntv). Said un'
  FROM people p WHERE p.name = 'Alexandria Ocasio-Cortez' AND p.website = 'https://ocasio-cortez.house.gov'
  ON CONFLICT (person_id, criterion_id) DO NOTHING;
INSERT INTO person_criteria (person_id, criterion_id, evidence)
  SELECT p.id, 11, 'House floor speech accusing Israel of "unfolding genocide" and calling for weapons suspension (https://www.cnn.com/2024/03/24/politics/alexandria-ocasio-cortez-aoc-israel-gaza-genocide-cnntv). Said un'
  FROM people p WHERE p.name = 'Alexandria Ocasio-Cortez' AND p.website = 'https://ocasio-cortez.house.gov'
  ON CONFLICT (person_id, criterion_id) DO NOTHING;
INSERT INTO person_criteria (person_id, criterion_id, evidence)
  SELECT p.id, 8, 'House floor speech accusing Israel of "unfolding genocide" and calling for weapons suspension (https://www.cnn.com/2024/03/24/politics/alexandria-ocasio-cortez-aoc-israel-gaza-genocide-cnntv). Said un'
  FROM people p WHERE p.name = 'Alexandria Ocasio-Cortez' AND p.website = 'https://ocasio-cortez.house.gov'
  ON CONFLICT (person_id, criterion_id) DO NOTHING;

INSERT INTO people (name, party, website) VALUES ('Ritchie Torres', 'Democratic', 'https://torres.house.gov');
INSERT INTO terms (person_id, seat_id, is_current, start_date, end_date)
  SELECT p.id, s.id, true, '2025-01-03', '2027-01-03'
  FROM people p, seats s
  WHERE p.name = 'Ritchie Torres' AND p.website = 'https://torres.house.gov'
    AND s.chamber = 'us_house' AND s.district = 15;
INSERT INTO positions (person_id, topic_id, stance, confidence, assessment_type, rationale, summary)
  SELECT p.id, (SELECT id FROM topics WHERE slug = 'israel'), 'strongly_support', 'inferred', 'ai', 'Self-described Zionist and "pro-Israel progressive" who left the Congressional Progressive Caucus over Israel. Second-largest House recipient of AIPAC donations (~$1.77M total). Vocal defender of Israel''s military campaign, denies genocide characterization, blames humanitarian crisis on Hamas. Called for end to war but only through Hamas surrender.', 'Left Congressional Progressive Caucus over Israel stance in January 2024. Self-described Zionist who says he "always will be" (https://jewishcurrents.org/ritchie-torres-is-the-future-of-pro-israel-politics). Total AIPAC donations: ~$1,766,086 (https://www.boughtbyzionism.org/interventionweek072024). Denies Israel committing genocide, blames Hamas for humanitarian crisis. Called for end to war in July 2024 but blamed Netanyahu''s leadership rather than Israel''s right to fight (https://www.cityands'
  FROM people p WHERE p.name = 'Ritchie Torres' AND p.website = 'https://torres.house.gov'
  ON CONFLICT (person_id, topic_id, assessment_type) DO NOTHING;
INSERT INTO research_log (person_id, topic_id, researched_at, pass_number, result, notes)
  SELECT p.id, (SELECT id FROM topics WHERE slug = 'israel'), NOW(), 1, 'found', 'Federal delegation research'
  FROM people p WHERE p.name = 'Ritchie Torres' AND p.website = 'https://torres.house.gov'
  ON CONFLICT (person_id, topic_id, pass_number) DO NOTHING;
INSERT INTO person_criteria (person_id, criterion_id, evidence)
  SELECT p.id, 6, 'Left Congressional Progressive Caucus over Israel stance in January 2024. Self-described Zionist who says he "always will be" (https://jewishcurrents.org/ritchie-torres-is-the-future-of-pro-israel-pol'
  FROM people p WHERE p.name = 'Ritchie Torres' AND p.website = 'https://torres.house.gov'
  ON CONFLICT (person_id, criterion_id) DO NOTHING;
INSERT INTO person_criteria (person_id, criterion_id, evidence)
  SELECT p.id, 12, 'Left Congressional Progressive Caucus over Israel stance in January 2024. Self-described Zionist who says he "always will be" (https://jewishcurrents.org/ritchie-torres-is-the-future-of-pro-israel-pol'
  FROM people p WHERE p.name = 'Ritchie Torres' AND p.website = 'https://torres.house.gov'
  ON CONFLICT (person_id, criterion_id) DO NOTHING;
INSERT INTO person_criteria (person_id, criterion_id, evidence)
  SELECT p.id, 14, 'Left Congressional Progressive Caucus over Israel stance in January 2024. Self-described Zionist who says he "always will be" (https://jewishcurrents.org/ritchie-torres-is-the-future-of-pro-israel-pol'
  FROM people p WHERE p.name = 'Ritchie Torres' AND p.website = 'https://torres.house.gov'
  ON CONFLICT (person_id, criterion_id) DO NOTHING;
INSERT INTO person_criteria (person_id, criterion_id, evidence)
  SELECT p.id, 16, 'Left Congressional Progressive Caucus over Israel stance in January 2024. Self-described Zionist who says he "always will be" (https://jewishcurrents.org/ritchie-torres-is-the-future-of-pro-israel-pol'
  FROM people p WHERE p.name = 'Ritchie Torres' AND p.website = 'https://torres.house.gov'
  ON CONFLICT (person_id, criterion_id) DO NOTHING;

INSERT INTO people (name, party, website) VALUES ('George Latimer', 'Democratic', 'https://latimer.house.gov');
INSERT INTO terms (person_id, seat_id, is_current, start_date, end_date)
  SELECT p.id, s.id, true, '2025-01-03', '2027-01-03'
  FROM people p, seats s
  WHERE p.name = 'George Latimer' AND p.website = 'https://latimer.house.gov'
    AND s.chamber = 'us_house' AND s.district = 16;
INSERT INTO positions (person_id, topic_id, stance, confidence, assessment_type, rationale, summary)
  SELECT p.id, (SELECT id FROM topics WHERE slug = 'israel'), 'strongly_support', 'inferred', 'ai', 'Defeated Jamaal Bowman in the most expensive House primary in history, largely funded by AIPAC ($14.5M from AIPAC''s super PAC). Ran explicitly as a pro-Israel alternative to Bowman''s criticism of Israel. Redirects Gaza discussion to Oct 7 attack and Hamas responsibility. Entered race at urging of Jewish leaders.', 'Defeated Bowman with $14.5M from AIPAC''s super PAC in most expensive House primary ever (https://mondoweiss.net/2024/06/latimer-defeats-bowman-with-15-million-worth-of-help-from-aipac/). Entered race at urging of Jewish leaders (https://www.commondreams.org/news/george-latimer-jamaal-bowman). Emphasizes Oct 7 as origin of all conflict, redirecting from Palestinian casualties (https://jewishinsider.com/2025/09/george-latimer-new-york-congressman-israel-gaza-war-hamas/). Supports two-state solutio'
  FROM people p WHERE p.name = 'George Latimer' AND p.website = 'https://latimer.house.gov'
  ON CONFLICT (person_id, topic_id, assessment_type) DO NOTHING;
INSERT INTO research_log (person_id, topic_id, researched_at, pass_number, result, notes)
  SELECT p.id, (SELECT id FROM topics WHERE slug = 'israel'), NOW(), 1, 'found', 'Federal delegation research'
  FROM people p WHERE p.name = 'George Latimer' AND p.website = 'https://latimer.house.gov'
  ON CONFLICT (person_id, topic_id, pass_number) DO NOTHING;
INSERT INTO person_criteria (person_id, criterion_id, evidence)
  SELECT p.id, 6, 'Defeated Bowman with $14.5M from AIPAC''''s super PAC in most expensive House primary ever (https://mondoweiss.net/2024/06/latimer-defeats-bowman-with-15-million-worth-of-help-from-aipac/). Entered race'
  FROM people p WHERE p.name = 'George Latimer' AND p.website = 'https://latimer.house.gov'
  ON CONFLICT (person_id, criterion_id) DO NOTHING;
INSERT INTO person_criteria (person_id, criterion_id, evidence)
  SELECT p.id, 12, 'Defeated Bowman with $14.5M from AIPAC''''s super PAC in most expensive House primary ever (https://mondoweiss.net/2024/06/latimer-defeats-bowman-with-15-million-worth-of-help-from-aipac/). Entered race'
  FROM people p WHERE p.name = 'George Latimer' AND p.website = 'https://latimer.house.gov'
  ON CONFLICT (person_id, criterion_id) DO NOTHING;
INSERT INTO person_criteria (person_id, criterion_id, evidence)
  SELECT p.id, 14, 'Defeated Bowman with $14.5M from AIPAC''''s super PAC in most expensive House primary ever (https://mondoweiss.net/2024/06/latimer-defeats-bowman-with-15-million-worth-of-help-from-aipac/). Entered race'
  FROM people p WHERE p.name = 'George Latimer' AND p.website = 'https://latimer.house.gov'
  ON CONFLICT (person_id, criterion_id) DO NOTHING;
INSERT INTO person_criteria (person_id, criterion_id, evidence)
  SELECT p.id, 16, 'Defeated Bowman with $14.5M from AIPAC''''s super PAC in most expensive House primary ever (https://mondoweiss.net/2024/06/latimer-defeats-bowman-with-15-million-worth-of-help-from-aipac/). Entered race'
  FROM people p WHERE p.name = 'George Latimer' AND p.website = 'https://latimer.house.gov'
  ON CONFLICT (person_id, criterion_id) DO NOTHING;

INSERT INTO people (name, party, website) VALUES ('Mike Lawler', 'Republican', 'https://lawler.house.gov');
INSERT INTO terms (person_id, seat_id, is_current, start_date, end_date)
  SELECT p.id, s.id, true, '2025-01-03', '2027-01-03'
  FROM people p, seats s
  WHERE p.name = 'Mike Lawler' AND p.website = 'https://lawler.house.gov'
    AND s.chamber = 'us_house' AND s.district = 17;
INSERT INTO positions (person_id, topic_id, stance, confidence, assessment_type, rationale, summary)
  SELECT p.id, (SELECT id FROM topics WHERE slug = 'israel'), 'strongly_support', 'inferred', 'ai', 'Introduced bipartisan Stand with Israel Act to confront anti-Israel bias at the UN. Co-authored IGO Anti-Boycott Act expanding anti-boycott laws. Opposes ceasefire except through Hamas surrender. Visited Israel early in his term. Won 2024 re-election partly on pro-Israel positioning in district with large Jewish population.', 'Introduced Stand with Israel Act to withhold U.S. funding from UN agencies that restrict Israel (https://lawler.house.gov/news/documentsingle.aspx?DocumentID=3156). Co-authored IGO Anti-Boycott Act with Rep. Gottheimer (https://mondoweiss.net/2025/05/the-shift-house-republicans-pull-anti-bds-bill-from-schedule/). Said ceasefire requires Hamas surrender and hostage release (https://www.jpost.com/annual-conference/article-805137). Visited Israel as one of first congressional trips. Won 2024 with s'
  FROM people p WHERE p.name = 'Mike Lawler' AND p.website = 'https://lawler.house.gov'
  ON CONFLICT (person_id, topic_id, assessment_type) DO NOTHING;
INSERT INTO research_log (person_id, topic_id, researched_at, pass_number, result, notes)
  SELECT p.id, (SELECT id FROM topics WHERE slug = 'israel'), NOW(), 1, 'found', 'Federal delegation research'
  FROM people p WHERE p.name = 'Mike Lawler' AND p.website = 'https://lawler.house.gov'
  ON CONFLICT (person_id, topic_id, pass_number) DO NOTHING;
INSERT INTO person_criteria (person_id, criterion_id, evidence)
  SELECT p.id, 1, 'Introduced Stand with Israel Act to withhold U.S. funding from UN agencies that restrict Israel (https://lawler.house.gov/news/documentsingle.aspx?DocumentID=3156). Co-authored IGO Anti-Boycott Act wi'
  FROM people p WHERE p.name = 'Mike Lawler' AND p.website = 'https://lawler.house.gov'
  ON CONFLICT (person_id, criterion_id) DO NOTHING;
INSERT INTO person_criteria (person_id, criterion_id, evidence)
  SELECT p.id, 6, 'Introduced Stand with Israel Act to withhold U.S. funding from UN agencies that restrict Israel (https://lawler.house.gov/news/documentsingle.aspx?DocumentID=3156). Co-authored IGO Anti-Boycott Act wi'
  FROM people p WHERE p.name = 'Mike Lawler' AND p.website = 'https://lawler.house.gov'
  ON CONFLICT (person_id, criterion_id) DO NOTHING;
INSERT INTO person_criteria (person_id, criterion_id, evidence)
  SELECT p.id, 12, 'Introduced Stand with Israel Act to withhold U.S. funding from UN agencies that restrict Israel (https://lawler.house.gov/news/documentsingle.aspx?DocumentID=3156). Co-authored IGO Anti-Boycott Act wi'
  FROM people p WHERE p.name = 'Mike Lawler' AND p.website = 'https://lawler.house.gov'
  ON CONFLICT (person_id, criterion_id) DO NOTHING;
INSERT INTO person_criteria (person_id, criterion_id, evidence)
  SELECT p.id, 14, 'Introduced Stand with Israel Act to withhold U.S. funding from UN agencies that restrict Israel (https://lawler.house.gov/news/documentsingle.aspx?DocumentID=3156). Co-authored IGO Anti-Boycott Act wi'
  FROM people p WHERE p.name = 'Mike Lawler' AND p.website = 'https://lawler.house.gov'
  ON CONFLICT (person_id, criterion_id) DO NOTHING;
INSERT INTO person_criteria (person_id, criterion_id, evidence)
  SELECT p.id, 16, 'Introduced Stand with Israel Act to withhold U.S. funding from UN agencies that restrict Israel (https://lawler.house.gov/news/documentsingle.aspx?DocumentID=3156). Co-authored IGO Anti-Boycott Act wi'
  FROM people p WHERE p.name = 'Mike Lawler' AND p.website = 'https://lawler.house.gov'
  ON CONFLICT (person_id, criterion_id) DO NOTHING;

INSERT INTO people (name, party, website) VALUES ('Pat Ryan', 'Democratic', 'https://patryan.house.gov');
INSERT INTO terms (person_id, seat_id, is_current, start_date, end_date)
  SELECT p.id, s.id, true, '2025-01-03', '2027-01-03'
  FROM people p, seats s
  WHERE p.name = 'Pat Ryan' AND p.website = 'https://patryan.house.gov'
    AND s.chamber = 'us_house' AND s.district = 18;
INSERT INTO positions (person_id, topic_id, stance, confidence, assessment_type, rationale, summary)
  SELECT p.id, (SELECT id FROM topics WHERE slug = 'israel'), 'support', 'inferred', 'ai', 'Supports Israel''s right to exist and defend itself, voted for $26.38B military aid package including Israel aid. However, calls for comprehensive ceasefire with conditions (hostage return, Hamas accountability, two-state solution, humanitarian aid). Criticized from both left (for supporting Israel aid) and right (for not supporting Israel-only bill). Moderate positioning.', 'Voted YES on $26.38B aid package including Israel military aid and $9B humanitarian aid for Gaza (https://patryan.house.gov/media/press-releases/ryan-votes-strengthen-american-security-bolstering-democratic-allies-fight). Called for comprehensive ceasefire including hostage return, Hamas surrender, two-state solution, end to settler violence. Declined to vote for Israel-only Republican bill, drawing GOP attacks. Faced repeated pro-ceasefire protests (https://www.cityandstateny.com/politics/2024/'
  FROM people p WHERE p.name = 'Pat Ryan' AND p.website = 'https://patryan.house.gov'
  ON CONFLICT (person_id, topic_id, assessment_type) DO NOTHING;
INSERT INTO research_log (person_id, topic_id, researched_at, pass_number, result, notes)
  SELECT p.id, (SELECT id FROM topics WHERE slug = 'israel'), NOW(), 1, 'found', 'Federal delegation research'
  FROM people p WHERE p.name = 'Pat Ryan' AND p.website = 'https://patryan.house.gov'
  ON CONFLICT (person_id, topic_id, pass_number) DO NOTHING;
INSERT INTO person_criteria (person_id, criterion_id, evidence)
  SELECT p.id, 6, 'Voted YES on $26.38B aid package including Israel military aid and $9B humanitarian aid for Gaza (https://patryan.house.gov/media/press-releases/ryan-votes-strengthen-american-security-bolstering-demo'
  FROM people p WHERE p.name = 'Pat Ryan' AND p.website = 'https://patryan.house.gov'
  ON CONFLICT (person_id, criterion_id) DO NOTHING;
INSERT INTO person_criteria (person_id, criterion_id, evidence)
  SELECT p.id, 12, 'Voted YES on $26.38B aid package including Israel military aid and $9B humanitarian aid for Gaza (https://patryan.house.gov/media/press-releases/ryan-votes-strengthen-american-security-bolstering-demo'
  FROM people p WHERE p.name = 'Pat Ryan' AND p.website = 'https://patryan.house.gov'
  ON CONFLICT (person_id, criterion_id) DO NOTHING;

INSERT INTO people (name, party, website) VALUES ('Josh Riley', 'Democratic', 'https://riley.house.gov');
INSERT INTO terms (person_id, seat_id, is_current, start_date, end_date)
  SELECT p.id, s.id, true, '2025-01-03', '2027-01-03'
  FROM people p, seats s
  WHERE p.name = 'Josh Riley' AND p.website = 'https://riley.house.gov'
    AND s.chamber = 'us_house' AND s.district = 19;
INSERT INTO positions (person_id, topic_id, stance, confidence, assessment_type, rationale, summary)
  SELECT p.id, (SELECT id FROM topics WHERE slug = 'israel'), 'support', 'inferred', 'ai', 'Freshman congressman who supports Israel''s right to defend itself and calls Hamas a "barbaric terrorist organization." Supports immediate ceasefire for hostage release and humanitarian access. Visited Israel on AIPAC-affiliated trip in August 2025. Received $36,645 from pro-Israel lobby. Faces progressive backlash from Ithaca-area constituents.', 'Statement: "Israel has a right to defend itself. Hamas is a barbaric terrorist organization and it needs to be eliminated" while also having "serious concerns about the way this war has unfolded" (https://theithacan.org/63333/news/locals-express-concern-with-rep-rileys-support-for-israel-amid-genocide/). Visited Israel on AIPAC-affiliated American Israel Education Foundation trip (https://www.ithaca.com/news/regional_news/josh-riley-faces-backlash-from-constituents-after-taking-aipac-trip-to-isr'
  FROM people p WHERE p.name = 'Josh Riley' AND p.website = 'https://riley.house.gov'
  ON CONFLICT (person_id, topic_id, assessment_type) DO NOTHING;
INSERT INTO research_log (person_id, topic_id, researched_at, pass_number, result, notes)
  SELECT p.id, (SELECT id FROM topics WHERE slug = 'israel'), NOW(), 1, 'found', 'Federal delegation research'
  FROM people p WHERE p.name = 'Josh Riley' AND p.website = 'https://riley.house.gov'
  ON CONFLICT (person_id, topic_id, pass_number) DO NOTHING;
INSERT INTO person_criteria (person_id, criterion_id, evidence)
  SELECT p.id, 6, 'Statement: "Israel has a right to defend itself. Hamas is a barbaric terrorist organization and it needs to be eliminated" while also having "serious concerns about the way this war has unfolded" (htt'
  FROM people p WHERE p.name = 'Josh Riley' AND p.website = 'https://riley.house.gov'
  ON CONFLICT (person_id, criterion_id) DO NOTHING;
INSERT INTO person_criteria (person_id, criterion_id, evidence)
  SELECT p.id, 12, 'Statement: "Israel has a right to defend itself. Hamas is a barbaric terrorist organization and it needs to be eliminated" while also having "serious concerns about the way this war has unfolded" (htt'
  FROM people p WHERE p.name = 'Josh Riley' AND p.website = 'https://riley.house.gov'
  ON CONFLICT (person_id, criterion_id) DO NOTHING;
INSERT INTO person_criteria (person_id, criterion_id, evidence)
  SELECT p.id, 14, 'Statement: "Israel has a right to defend itself. Hamas is a barbaric terrorist organization and it needs to be eliminated" while also having "serious concerns about the way this war has unfolded" (htt'
  FROM people p WHERE p.name = 'Josh Riley' AND p.website = 'https://riley.house.gov'
  ON CONFLICT (person_id, criterion_id) DO NOTHING;

INSERT INTO people (name, party, website) VALUES ('Paul Tonko', 'Democratic', 'https://tonko.house.gov');
INSERT INTO terms (person_id, seat_id, is_current, start_date, end_date)
  SELECT p.id, s.id, true, '2025-01-03', '2027-01-03'
  FROM people p, seats s
  WHERE p.name = 'Paul Tonko' AND p.website = 'https://tonko.house.gov'
    AND s.chamber = 'us_house' AND s.district = 20;
INSERT INTO positions (person_id, topic_id, stance, confidence, assessment_type, rationale, summary)
  SELECT p.id, (SELECT id FROM topics WHERE slug = 'israel'), 'neutral', 'inferred', 'ai', 'Most nuanced position in the NY delegation. Voted for H.Res.768 supporting Israel and for Israel Security Supplemental, but also called for "immediate and permanent ceasefire" — one of relatively few mainstream Democrats to use that language. Opposed forced transfer of Palestinians from Gaza. Endorsed by J Street. Balances pro-Israel security votes with vocal humanitarian concern.', 'Called for "immediate and permanent ceasefire" on social media (https://x.com/RepPaulTonko/status/1749795799280521376). Voted for H.Res.768 standing with Israel and for Israel Security Supplemental (https://tonko.house.gov/news/documentsingle.aspx?DocumentID=4109). Opposed forced transfer of Palestinians from Gaza, joined letter urging rejection of these ideas. Endorsed by J Street (https://www.wamc.org/commentary-opinion/2024-10-01/j-street-tonko-and-peace-in-the-middle-east). Marked one year s'
  FROM people p WHERE p.name = 'Paul Tonko' AND p.website = 'https://tonko.house.gov'
  ON CONFLICT (person_id, topic_id, assessment_type) DO NOTHING;
INSERT INTO research_log (person_id, topic_id, researched_at, pass_number, result, notes)
  SELECT p.id, (SELECT id FROM topics WHERE slug = 'israel'), NOW(), 1, 'found', 'Federal delegation research'
  FROM people p WHERE p.name = 'Paul Tonko' AND p.website = 'https://tonko.house.gov'
  ON CONFLICT (person_id, topic_id, pass_number) DO NOTHING;
INSERT INTO person_criteria (person_id, criterion_id, evidence)
  SELECT p.id, 6, 'Called for "immediate and permanent ceasefire" on social media (https://x.com/RepPaulTonko/status/1749795799280521376). Voted for H.Res.768 standing with Israel and for Israel Security Supplemental (h'
  FROM people p WHERE p.name = 'Paul Tonko' AND p.website = 'https://tonko.house.gov'
  ON CONFLICT (person_id, criterion_id) DO NOTHING;
INSERT INTO person_criteria (person_id, criterion_id, evidence)
  SELECT p.id, 12, 'Called for "immediate and permanent ceasefire" on social media (https://x.com/RepPaulTonko/status/1749795799280521376). Voted for H.Res.768 standing with Israel and for Israel Security Supplemental (h'
  FROM people p WHERE p.name = 'Paul Tonko' AND p.website = 'https://tonko.house.gov'
  ON CONFLICT (person_id, criterion_id) DO NOTHING;
INSERT INTO person_criteria (person_id, criterion_id, evidence)
  SELECT p.id, 11, 'Called for "immediate and permanent ceasefire" on social media (https://x.com/RepPaulTonko/status/1749795799280521376). Voted for H.Res.768 standing with Israel and for Israel Security Supplemental (h'
  FROM people p WHERE p.name = 'Paul Tonko' AND p.website = 'https://tonko.house.gov'
  ON CONFLICT (person_id, criterion_id) DO NOTHING;

INSERT INTO people (name, party, website) VALUES ('Elise Stefanik', 'Republican', 'https://stefanik.house.gov');
INSERT INTO terms (person_id, seat_id, is_current, start_date, end_date)
  SELECT p.id, s.id, true, '2025-01-03', '2027-01-03'
  FROM people p, seats s
  WHERE p.name = 'Elise Stefanik' AND p.website = 'https://stefanik.house.gov'
    AND s.chamber = 'us_house' AND s.district = 21;
INSERT INTO positions (person_id, topic_id, stance, confidence, assessment_type, rationale, summary)
  SELECT p.id, (SELECT id FROM topics WHERE slug = 'israel'), 'strongly_support', 'inferred', 'ai', 'Among the most vocal pro-Israel members of Congress. Delivered historic address at Israeli Knesset calling for unrestricted U.S. war aid. Led campus antisemitism hearings that toppled university presidents. Voted to defund UNRWA, ICC, and ICJ. Supports Israel''s "biblical right" to the West Bank. Refused to affirm Palestinian right to self-determination. Was Trump''s pick for UN Ambassador (pulled to preserve House majority).', 'Historic address at Israeli Knesset calling for unrestricted U.S. military aid (https://www.npr.org/2024/05/19/1252353096/in-knesset-speech-gops-elise-stefanik-calls-for-unrestricted-u-s-war-aid-to-isra). Led campus antisemitism hearings that led to resignations of Penn and Harvard presidents (https://stefanik.house.gov/2024/5/stefanik-delivers-historic-address-on-antisemitism-and-u-s-support-for-israel-at-israeli-knesset). Voted to defund UNRWA, ICC, ICJ, and UN Commission of Inquiry. Supported'
  FROM people p WHERE p.name = 'Elise Stefanik' AND p.website = 'https://stefanik.house.gov'
  ON CONFLICT (person_id, topic_id, assessment_type) DO NOTHING;
INSERT INTO research_log (person_id, topic_id, researched_at, pass_number, result, notes)
  SELECT p.id, (SELECT id FROM topics WHERE slug = 'israel'), NOW(), 1, 'found', 'Federal delegation research'
  FROM people p WHERE p.name = 'Elise Stefanik' AND p.website = 'https://stefanik.house.gov'
  ON CONFLICT (person_id, topic_id, pass_number) DO NOTHING;
INSERT INTO person_criteria (person_id, criterion_id, evidence)
  SELECT p.id, 1, 'Historic address at Israeli Knesset calling for unrestricted U.S. military aid (https://www.npr.org/2024/05/19/1252353096/in-knesset-speech-gops-elise-stefanik-calls-for-unrestricted-u-s-war-aid-to-is'
  FROM people p WHERE p.name = 'Elise Stefanik' AND p.website = 'https://stefanik.house.gov'
  ON CONFLICT (person_id, criterion_id) DO NOTHING;
INSERT INTO person_criteria (person_id, criterion_id, evidence)
  SELECT p.id, 6, 'Historic address at Israeli Knesset calling for unrestricted U.S. military aid (https://www.npr.org/2024/05/19/1252353096/in-knesset-speech-gops-elise-stefanik-calls-for-unrestricted-u-s-war-aid-to-is'
  FROM people p WHERE p.name = 'Elise Stefanik' AND p.website = 'https://stefanik.house.gov'
  ON CONFLICT (person_id, criterion_id) DO NOTHING;
INSERT INTO person_criteria (person_id, criterion_id, evidence)
  SELECT p.id, 12, 'Historic address at Israeli Knesset calling for unrestricted U.S. military aid (https://www.npr.org/2024/05/19/1252353096/in-knesset-speech-gops-elise-stefanik-calls-for-unrestricted-u-s-war-aid-to-is'
  FROM people p WHERE p.name = 'Elise Stefanik' AND p.website = 'https://stefanik.house.gov'
  ON CONFLICT (person_id, criterion_id) DO NOTHING;
INSERT INTO person_criteria (person_id, criterion_id, evidence)
  SELECT p.id, 14, 'Historic address at Israeli Knesset calling for unrestricted U.S. military aid (https://www.npr.org/2024/05/19/1252353096/in-knesset-speech-gops-elise-stefanik-calls-for-unrestricted-u-s-war-aid-to-is'
  FROM people p WHERE p.name = 'Elise Stefanik' AND p.website = 'https://stefanik.house.gov'
  ON CONFLICT (person_id, criterion_id) DO NOTHING;
INSERT INTO person_criteria (person_id, criterion_id, evidence)
  SELECT p.id, 16, 'Historic address at Israeli Knesset calling for unrestricted U.S. military aid (https://www.npr.org/2024/05/19/1252353096/in-knesset-speech-gops-elise-stefanik-calls-for-unrestricted-u-s-war-aid-to-is'
  FROM people p WHERE p.name = 'Elise Stefanik' AND p.website = 'https://stefanik.house.gov'
  ON CONFLICT (person_id, criterion_id) DO NOTHING;

INSERT INTO people (name, party, website) VALUES ('John Mannion', 'Democratic', 'https://mannion.house.gov');
INSERT INTO terms (person_id, seat_id, is_current, start_date, end_date)
  SELECT p.id, s.id, true, '2025-01-03', '2027-01-03'
  FROM people p, seats s
  WHERE p.name = 'John Mannion' AND p.website = 'https://mannion.house.gov'
    AND s.chamber = 'us_house' AND s.district = 22;
INSERT INTO positions (person_id, topic_id, stance, confidence, assessment_type, rationale, summary)
  SELECT p.id, (SELECT id FROM topics WHERE slug = 'israel'), 'support', 'inferred', 'ai', 'Freshman congressman who supports Israel''s right to defend itself, continuing aid to Israel, and a two-state solution. Supported ceasefire during 2024 campaign. Endorsed by J Street. Issued official statement affirming support for Israel while calling for aid to Palestinians and diplomatic peace process.', 'Official statement supporting Israel, continuing aid, and working toward two-state solution (https://mannion.house.gov/media/press-releases/statement-representative-john-mannion-support-israel). Supported bilateral ceasefire during 2024 campaign including hostage release (https://centralcurrent.org/ny-22-candidates-sarah-klee-hood-john-mannion-support-ceasefire-in-gaza/). Endorsed by J Street (https://jstreetpac.org/candidate/john-mannion/). Called Oct 7 "the deadliest attack on Jewish people si'
  FROM people p WHERE p.name = 'John Mannion' AND p.website = 'https://mannion.house.gov'
  ON CONFLICT (person_id, topic_id, assessment_type) DO NOTHING;
INSERT INTO research_log (person_id, topic_id, researched_at, pass_number, result, notes)
  SELECT p.id, (SELECT id FROM topics WHERE slug = 'israel'), NOW(), 1, 'found', 'Federal delegation research'
  FROM people p WHERE p.name = 'John Mannion' AND p.website = 'https://mannion.house.gov'
  ON CONFLICT (person_id, topic_id, pass_number) DO NOTHING;
INSERT INTO person_criteria (person_id, criterion_id, evidence)
  SELECT p.id, 6, 'Official statement supporting Israel, continuing aid, and working toward two-state solution (https://mannion.house.gov/media/press-releases/statement-representative-john-mannion-support-israel). Suppo'
  FROM people p WHERE p.name = 'John Mannion' AND p.website = 'https://mannion.house.gov'
  ON CONFLICT (person_id, criterion_id) DO NOTHING;
INSERT INTO person_criteria (person_id, criterion_id, evidence)
  SELECT p.id, 12, 'Official statement supporting Israel, continuing aid, and working toward two-state solution (https://mannion.house.gov/media/press-releases/statement-representative-john-mannion-support-israel). Suppo'
  FROM people p WHERE p.name = 'John Mannion' AND p.website = 'https://mannion.house.gov'
  ON CONFLICT (person_id, criterion_id) DO NOTHING;

INSERT INTO people (name, party, website) VALUES ('Nick Langworthy', 'Republican', 'https://langworthy.house.gov');
INSERT INTO terms (person_id, seat_id, is_current, start_date, end_date)
  SELECT p.id, s.id, true, '2025-01-03', '2027-01-03'
  FROM people p, seats s
  WHERE p.name = 'Nick Langworthy' AND p.website = 'https://langworthy.house.gov'
    AND s.chamber = 'us_house' AND s.district = 23;
INSERT INTO positions (person_id, topic_id, stance, confidence, assessment_type, rationale, summary)
  SELECT p.id, (SELECT id FROM topics WHERE slug = 'israel'), 'strongly_support', 'inferred', 'ai', 'Consistent and vocal supporter of Israel. Voted for $14.3B Israel Security Supplemental. Voted for additional aid to replenish Israeli air defenses after Iranian attack. Frames support as backing "our strongest ally for freedom in the Middle East." No public statements on Palestinian rights or humanitarian concerns found.', 'Voted for H.R. 6126, $14.3B Israel Security Supplemental (https://langworthy.house.gov/media/press-releases/langworthy-votes-pass-israel-aid-package). Voted for additional Israel aid to replenish air defenses after Iranian attack in April 2024. Statement: "I will always stand with Israel, and they need our support now, more than ever, to defend their freedoms following the brutal terrorist attacks of October 7."'
  FROM people p WHERE p.name = 'Nick Langworthy' AND p.website = 'https://langworthy.house.gov'
  ON CONFLICT (person_id, topic_id, assessment_type) DO NOTHING;
INSERT INTO research_log (person_id, topic_id, researched_at, pass_number, result, notes)
  SELECT p.id, (SELECT id FROM topics WHERE slug = 'israel'), NOW(), 1, 'found', 'Federal delegation research'
  FROM people p WHERE p.name = 'Nick Langworthy' AND p.website = 'https://langworthy.house.gov'
  ON CONFLICT (person_id, topic_id, pass_number) DO NOTHING;
INSERT INTO person_criteria (person_id, criterion_id, evidence)
  SELECT p.id, 6, 'Voted for H.R. 6126, $14.3B Israel Security Supplemental (https://langworthy.house.gov/media/press-releases/langworthy-votes-pass-israel-aid-package). Voted for additional Israel aid to replenish air '
  FROM people p WHERE p.name = 'Nick Langworthy' AND p.website = 'https://langworthy.house.gov'
  ON CONFLICT (person_id, criterion_id) DO NOTHING;
INSERT INTO person_criteria (person_id, criterion_id, evidence)
  SELECT p.id, 12, 'Voted for H.R. 6126, $14.3B Israel Security Supplemental (https://langworthy.house.gov/media/press-releases/langworthy-votes-pass-israel-aid-package). Voted for additional Israel aid to replenish air '
  FROM people p WHERE p.name = 'Nick Langworthy' AND p.website = 'https://langworthy.house.gov'
  ON CONFLICT (person_id, criterion_id) DO NOTHING;

INSERT INTO people (name, party, website) VALUES ('Claudia Tenney', 'Republican', 'https://tenney.house.gov');
INSERT INTO terms (person_id, seat_id, is_current, start_date, end_date)
  SELECT p.id, s.id, true, '2025-01-03', '2027-01-03'
  FROM people p, seats s
  WHERE p.name = 'Claudia Tenney' AND p.website = 'https://tenney.house.gov'
    AND s.chamber = 'us_house' AND s.district = 24;
INSERT INTO positions (person_id, topic_id, stance, confidence, assessment_type, rationale, summary)
  SELECT p.id, (SELECT id FROM topics WHERE slug = 'israel'), 'strongly_support', 'inferred', 'ai', 'Among the most hawkish pro-Israel members of the NY delegation. Released comprehensive "Israel and Iran Plan." Voted for all Israel aid packages. Co-sponsored bill preventing withholding of weapons deliveries to Israel. Created caucus to rename occupied Palestinian territory with biblical names. Honored by Jewish groups for "unwavering" Israel support.', 'Released comprehensive Israel and Iran Plan (https://tenney.house.gov/issues/israel-plan). Voted for $26.4B in Israel aid. Co-sponsored H.R.8369 Israel Security Assistance Support Act preventing weapons withholding (https://tenney.house.gov/media/press-releases/congresswoman-tenney-releases-comprehensive-israel-and-iran-plan). Created caucus to rename occupied territory with biblical names (https://x.com/TrackAIPAC/status/1906393753725927935). Honored by Jewish group for "unwavering" Israel supp'
  FROM people p WHERE p.name = 'Claudia Tenney' AND p.website = 'https://tenney.house.gov'
  ON CONFLICT (person_id, topic_id, assessment_type) DO NOTHING;
INSERT INTO research_log (person_id, topic_id, researched_at, pass_number, result, notes)
  SELECT p.id, (SELECT id FROM topics WHERE slug = 'israel'), NOW(), 1, 'found', 'Federal delegation research'
  FROM people p WHERE p.name = 'Claudia Tenney' AND p.website = 'https://tenney.house.gov'
  ON CONFLICT (person_id, topic_id, pass_number) DO NOTHING;
INSERT INTO person_criteria (person_id, criterion_id, evidence)
  SELECT p.id, 1, 'Released comprehensive Israel and Iran Plan (https://tenney.house.gov/issues/israel-plan). Voted for $26.4B in Israel aid. Co-sponsored H.R.8369 Israel Security Assistance Support Act preventing weapo'
  FROM people p WHERE p.name = 'Claudia Tenney' AND p.website = 'https://tenney.house.gov'
  ON CONFLICT (person_id, criterion_id) DO NOTHING;
INSERT INTO person_criteria (person_id, criterion_id, evidence)
  SELECT p.id, 6, 'Released comprehensive Israel and Iran Plan (https://tenney.house.gov/issues/israel-plan). Voted for $26.4B in Israel aid. Co-sponsored H.R.8369 Israel Security Assistance Support Act preventing weapo'
  FROM people p WHERE p.name = 'Claudia Tenney' AND p.website = 'https://tenney.house.gov'
  ON CONFLICT (person_id, criterion_id) DO NOTHING;
INSERT INTO person_criteria (person_id, criterion_id, evidence)
  SELECT p.id, 12, 'Released comprehensive Israel and Iran Plan (https://tenney.house.gov/issues/israel-plan). Voted for $26.4B in Israel aid. Co-sponsored H.R.8369 Israel Security Assistance Support Act preventing weapo'
  FROM people p WHERE p.name = 'Claudia Tenney' AND p.website = 'https://tenney.house.gov'
  ON CONFLICT (person_id, criterion_id) DO NOTHING;
INSERT INTO person_criteria (person_id, criterion_id, evidence)
  SELECT p.id, 14, 'Released comprehensive Israel and Iran Plan (https://tenney.house.gov/issues/israel-plan). Voted for $26.4B in Israel aid. Co-sponsored H.R.8369 Israel Security Assistance Support Act preventing weapo'
  FROM people p WHERE p.name = 'Claudia Tenney' AND p.website = 'https://tenney.house.gov'
  ON CONFLICT (person_id, criterion_id) DO NOTHING;
INSERT INTO person_criteria (person_id, criterion_id, evidence)
  SELECT p.id, 16, 'Released comprehensive Israel and Iran Plan (https://tenney.house.gov/issues/israel-plan). Voted for $26.4B in Israel aid. Co-sponsored H.R.8369 Israel Security Assistance Support Act preventing weapo'
  FROM people p WHERE p.name = 'Claudia Tenney' AND p.website = 'https://tenney.house.gov'
  ON CONFLICT (person_id, criterion_id) DO NOTHING;

INSERT INTO people (name, party, website) VALUES ('Joseph Morelle', 'Democratic', 'https://morelle.house.gov');
INSERT INTO terms (person_id, seat_id, is_current, start_date, end_date)
  SELECT p.id, s.id, true, '2025-01-03', '2027-01-03'
  FROM people p, seats s
  WHERE p.name = 'Joseph Morelle' AND p.website = 'https://morelle.house.gov'
    AND s.chamber = 'us_house' AND s.district = 25;
INSERT INTO positions (person_id, topic_id, stance, confidence, assessment_type, rationale, summary)
  SELECT p.id, (SELECT id FROM topics WHERE slug = 'israel'), 'support', 'inferred', 'ai', 'Supports Israel''s right to exist and defend itself. Co-sponsored H.Res.768 standing with Israel. Supports two-state solution. Rejects "genocide" characterization of Israel''s actions. Provided resources for U.S. citizens in Israel after Oct 7. Moderate pro-Israel Democrat.', 'Co-sponsored H.Res.768 standing with Israel (https://www.congress.gov/bill/118th-congress/house-resolution/768/text). Provided resources for U.S. citizens in Israel after Oct 7 (https://morelle.house.gov/media/press-releases/congressman-joe-morelle-provides-resources-assist-us-citizens-israel). Rejects "genocide" label, says "Israelis are not trying to eliminate an entire people." Supports two-state solution: "there cannot be stability in the region unless there''s a two-state solution" (https://'
  FROM people p WHERE p.name = 'Joseph Morelle' AND p.website = 'https://morelle.house.gov'
  ON CONFLICT (person_id, topic_id, assessment_type) DO NOTHING;
INSERT INTO research_log (person_id, topic_id, researched_at, pass_number, result, notes)
  SELECT p.id, (SELECT id FROM topics WHERE slug = 'israel'), NOW(), 1, 'found', 'Federal delegation research'
  FROM people p WHERE p.name = 'Joseph Morelle' AND p.website = 'https://morelle.house.gov'
  ON CONFLICT (person_id, topic_id, pass_number) DO NOTHING;
INSERT INTO person_criteria (person_id, criterion_id, evidence)
  SELECT p.id, 6, 'Co-sponsored H.Res.768 standing with Israel (https://www.congress.gov/bill/118th-congress/house-resolution/768/text). Provided resources for U.S. citizens in Israel after Oct 7 (https://morelle.house.'
  FROM people p WHERE p.name = 'Joseph Morelle' AND p.website = 'https://morelle.house.gov'
  ON CONFLICT (person_id, criterion_id) DO NOTHING;
INSERT INTO person_criteria (person_id, criterion_id, evidence)
  SELECT p.id, 12, 'Co-sponsored H.Res.768 standing with Israel (https://www.congress.gov/bill/118th-congress/house-resolution/768/text). Provided resources for U.S. citizens in Israel after Oct 7 (https://morelle.house.'
  FROM people p WHERE p.name = 'Joseph Morelle' AND p.website = 'https://morelle.house.gov'
  ON CONFLICT (person_id, criterion_id) DO NOTHING;
INSERT INTO person_criteria (person_id, criterion_id, evidence)
  SELECT p.id, 16, 'Co-sponsored H.Res.768 standing with Israel (https://www.congress.gov/bill/118th-congress/house-resolution/768/text). Provided resources for U.S. citizens in Israel after Oct 7 (https://morelle.house.'
  FROM people p WHERE p.name = 'Joseph Morelle' AND p.website = 'https://morelle.house.gov'
  ON CONFLICT (person_id, criterion_id) DO NOTHING;

INSERT INTO people (name, party, website) VALUES ('Tim Kennedy', 'Democratic', 'https://kennedy.house.gov');
INSERT INTO terms (person_id, seat_id, is_current, start_date, end_date)
  SELECT p.id, s.id, true, '2025-01-03', '2027-01-03'
  FROM people p, seats s
  WHERE p.name = 'Tim Kennedy' AND p.website = 'https://kennedy.house.gov'
    AND s.chamber = 'us_house' AND s.district = 26;
INSERT INTO positions (person_id, topic_id, stance, confidence, assessment_type, rationale, summary)
  SELECT p.id, (SELECT id FROM topics WHERE slug = 'israel'), 'support', 'inferred', 'ai', 'Freshman congressman who supports Israel, accepted AIPAC endorsement and $17,196 in AIPAC contributions. Visited Israel on AIPAC-affiliated trip. Led bipartisan letter urging Arab League cooperation to end Hamas''s war. Believes aid to Israel should remain unconditional. Also states he is "with the people of Palestine" and wants to end the war.', 'Statement after Iranian attack: "America and its military stand with Israel" (https://kennedy.house.gov/news/documentsingle.aspx?DocumentID=1137). Led letter urging Arab League cooperation against Hamas (https://auchincloss.house.gov/media/press-releases/congressman-jake-auchincloss-leads-democrats-in-letter-urging-regional-cooperation-to-end-hamass-war-against-israel). Accepted AIPAC endorsement, believes aid should be unconditional. Visited Israel on AIPAC-affiliated trip (https://www.wgrz.com'
  FROM people p WHERE p.name = 'Tim Kennedy' AND p.website = 'https://kennedy.house.gov'
  ON CONFLICT (person_id, topic_id, assessment_type) DO NOTHING;
INSERT INTO research_log (person_id, topic_id, researched_at, pass_number, result, notes)
  SELECT p.id, (SELECT id FROM topics WHERE slug = 'israel'), NOW(), 1, 'found', 'Federal delegation research'
  FROM people p WHERE p.name = 'Tim Kennedy' AND p.website = 'https://kennedy.house.gov'
  ON CONFLICT (person_id, topic_id, pass_number) DO NOTHING;
INSERT INTO person_criteria (person_id, criterion_id, evidence)
  SELECT p.id, 6, 'Statement after Iranian attack: "America and its military stand with Israel" (https://kennedy.house.gov/news/documentsingle.aspx?DocumentID=1137). Led letter urging Arab League cooperation against Ham'
  FROM people p WHERE p.name = 'Tim Kennedy' AND p.website = 'https://kennedy.house.gov'
  ON CONFLICT (person_id, criterion_id) DO NOTHING;
INSERT INTO person_criteria (person_id, criterion_id, evidence)
  SELECT p.id, 12, 'Statement after Iranian attack: "America and its military stand with Israel" (https://kennedy.house.gov/news/documentsingle.aspx?DocumentID=1137). Led letter urging Arab League cooperation against Ham'
  FROM people p WHERE p.name = 'Tim Kennedy' AND p.website = 'https://kennedy.house.gov'
  ON CONFLICT (person_id, criterion_id) DO NOTHING;
INSERT INTO person_criteria (person_id, criterion_id, evidence)
  SELECT p.id, 14, 'Statement after Iranian attack: "America and its military stand with Israel" (https://kennedy.house.gov/news/documentsingle.aspx?DocumentID=1137). Led letter urging Arab League cooperation against Ham'
  FROM people p WHERE p.name = 'Tim Kennedy' AND p.website = 'https://kennedy.house.gov'
  ON CONFLICT (person_id, criterion_id) DO NOTHING;

