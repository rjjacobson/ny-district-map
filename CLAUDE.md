# NY District Map

Interactive map of New York State and NYC legislators with a Supabase-backed database of positions, terms, and bill tracking.

## Live URLs
- **Production**: https://ny-district-map.vercel.app
- **GitHub**: https://github.com/rjjacobson/ny-district-map
- **Supabase Dashboard**: https://supabase.com/dashboard/project/xeknqkxhfxvveeyddokl

## Stack
- **Frontend**: Single `index.html` — Leaflet.js map + vanilla JS sidebar
- **Backend**: Supabase (project ref: `xeknqkxhfxvveeyddokl`)
- **Deployment**: Vercel (static site, scope: `ron-jacobsons-projects`)
- **Map boundaries**: NYS GIS Clearinghouse (Senate/Assembly), NYC Open Data (City Council)

## Supabase Anon Key
```
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inhla25xa3hoZnh2dmVleWRkb2tsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzUyMjc1MzksImV4cCI6MjA5MDgwMzUzOX0.-CO0RkDBljPTRBO5x5JIAIZ23WfhR0A8bLJV3iE_xS0
```

## Database Schema

### Core Tables
- **`people`** — The humans (name, party, website, photo_url, bio, born_year)
- **`seats`** — Structural positions (chamber + district). Chambers: `senate`, `assembly`, `city_council`
- **`terms`** — Who holds which seat, when (person_id, seat_id, start_date, end_date, is_current, contact info)

### Positions System
- **`topics`** — Issues being tracked (slug, category). Seeded: israel, financial-regulation, housing, education, climate
- **`positions`** — Person's stance on a topic (stance enum: strongly_support/support/neutral/oppose/strongly_oppose, confidence: verified/inferred/unknown)
- **`bills`** — Specific legislation linked to topics
- **`bill_actions`** — What a person did on a bill (sponsor, cosponsor, vote_yes, vote_no, vote_abstain)

### Key View
- **`current_legislators`** — Joins people + seats + terms WHERE is_current = true. This is what the frontend queries.

## Data Sources
- **Senate/Assembly boundaries**: `gisservices.its.ny.gov/arcgis/rest/services/NYS_{Senate,Assembly}_Districts/MapServer/0/query`
- **City Council boundaries**: `data.cityofnewyork.us/resource/872g-cjhh.geojson`
- **Senate legislator data**: Originally from NYS GIS Clearinghouse (has name, party, phone, email per district)
- **Assembly legislator data**: Same source
- **City Council members**: Scraped from council.nyc.gov/districts/
- **Website URLs**: Generated from patterns (nysenate.gov/senators/{slug}, nyassembly.gov/mem/{Name}, council.nyc.gov/district-{N}/)
- **Bill sponsors**: Manually researched from nysenate.gov bill pages

## Deploy Workflow
```bash
# Push DB changes
cd ~/claude-projects/ny-district-map
supabase db push

# Deploy frontend
vercel --prod --yes --scope ron-jacobsons-projects

# Or just push to GitHub + deploy in one shot
git push origin main && vercel --prod --yes --scope ron-jacobsons-projects
```

## Current Data (as of 2026-04-03)
- 264 legislators: 63 Senate + 150 Assembly + 51 City Council (1 vacant: CC District 3)
- 5 topics seeded
- 6 Israel-related bills with 5 known sponsor actions
- Term dates and websites backfilled for all non-vacant seats
- Special election start dates for: Bottcher (Senate 47), Sutton (Senate 22), Zellner (Senate 61), Powers (Assembly 74)

## Frontend Architecture
- Single HTML file with inline CSS and JS
- Split layout: Leaflet map (left) + sidebar with search + legislator list (right)
- Search is cross-chamber (searches all 3 chambers at once, grouped by section headers)
- Click map district or sidebar row to select; click again to deselect
- Toggling to City Council auto-zooms to NYC; Senate/Assembly zoom to full state
- GeoJSON boundaries merged with Supabase data at load time (boundaries have geometry, Supabase has metadata)
