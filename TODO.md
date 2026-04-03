# TODO

## High Priority

### Federal Level
- [ ] Add US House of Representatives (26 NY congressional districts)
  - Source boundaries from Census Bureau TIGER/Line shapefiles
  - Populate all 26 current NY House members into people/seats/terms
  - Add as `us_house` chamber with new map tab
- [ ] Add US Senate (2 NY senators: Schumer + Gillibrand)
  - Statewide overlay approach: entire state lights up as one region
  - Show both senators in sidebar panel
  - Add as `us_senate` chamber
- [ ] Update CHECK constraint on seats.chamber to include `us_house` and `us_senate`

### Israel Positions Analysis
- [ ] Research and populate `positions` table for Israel topic across all legislators
  - Bill sponsorship/cosponsorship data (S1255, S606, A4434, A6101, S531, S7034A)
  - Public statements, press releases, social media
  - Voting records on relevant resolutions
- [ ] Fetch full cosponsor lists for all 6 seeded Israel-related bills
- [ ] Add frontend UI to color districts by position stance (heatmap mode)
- [ ] Add topic selector dropdown to switch between party coloring and position coloring

### Data Enrichment
- [ ] Backfill phone numbers for City Council members (scrape individual district pages)
- [ ] Add photos for all legislators (photo_url in people table)
- [ ] Verify all website URLs actually resolve (some assembly slugs may be wrong)
- [ ] Research and populate positions for other seeded topics (finance, housing, education, climate)

## Medium Priority

### Historical Data
- [ ] Add previous term holders for each seat (is_current = false terms)
- [ ] Track people who moved between seats (e.g., Bottcher: CC 3 → Senate 47)
- [ ] Add historical bill voting records

### UI Improvements
- [ ] Add "color by topic" dropdown next to chamber toggle (party vs. stance heatmap)
- [ ] Show position stance badges in sidebar list when a topic is selected
- [ ] Add position detail to the detail card (stance, confidence, summary, source link)
- [ ] Mobile responsive layout (collapse sidebar into bottom sheet)
- [ ] Add address lookup ("find my representatives") using Google Civic API or similar

### Infrastructure
- [ ] Move from single HTML file to Next.js app (if complexity warrants it)
- [ ] Add Supabase Edge Function for address → district lookup
- [ ] Set up automated data refresh (check for new legislators, resignations, etc.)

## Low Priority / Future Ideas
- [ ] Embed bill tracker: show active Israel-related bills with status timeline
- [ ] Committee assignments for each legislator
- [ ] Campaign finance data integration
- [ ] Election results history per district
- [ ] Comparison view: select 2+ legislators side by side
- [ ] Export functionality (CSV of filtered results, share link with map state)
