# TODO

## High Priority

### Federal Level
- [x] Add US House of Representatives (26 NY congressional districts) — DONE
- [x] Add US Senate (2 NY senators: Schumer + Gillibrand) — DONE
- [x] Update CHECK constraint on seats.chamber — DONE

### Israel Positions Analysis
- [x] Research and populate `positions` table for Israel topic — DONE (196 classified, 67 unknown after 2 passes)
- [x] Add frontend UI to color districts by position stance (heatmap mode) — DONE
- [x] Add topic selector dropdown (View By: Party / Israel) — DONE
- [ ] Fetch full cosponsor lists for all 6 seeded Israel-related bills
- [ ] Research positions for other seeded topics (finance, housing, education, climate)

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
- [ ] Compact left panel when detail is open: show only stance dot + first 3 letters of name (or initials) so the list takes minimal width and the detail panel gets more space
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
