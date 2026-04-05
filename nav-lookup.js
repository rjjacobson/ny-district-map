// Shared nav address lookup — goes directly to reps.html
async function navLookup() {
  const input = document.getElementById('nav-address');
  const address = input.value.trim();
  if (!address) return;

  const btn = input.nextElementSibling;
  const origText = btn.textContent;
  btn.textContent = 'Searching...';
  btn.disabled = true;

  try {
    const geoResp = await fetch('https://nominatim.openstreetmap.org/search?q=' + encodeURIComponent(address) + '&format=json&limit=1&countrycodes=us');
    const geoData = await geoResp.json();
    if (!geoData.length) { alert('Address not found.'); btn.textContent = origText; btn.disabled = false; return; }

    const lat = parseFloat(geoData[0].lat), lon = parseFloat(geoData[0].lon);
    if (lat < 40.4 || lat > 45.1 || lon < -80 || lon > -71.5) { alert('Address not in New York State.'); btn.textContent = origText; btn.disabled = false; return; }

    const SUPABASE_URL = 'https://xeknqkxhfxvveeyddokl.supabase.co';
    const SUPABASE_ANON_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inhla25xa3hoZnh2dmVleWRkb2tsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzUyMjc1MzksImV4cCI6MjA5MDgwMzUzOX0.-CO0RkDBljPTRBO5x5JIAIZ23WfhR0A8bLJV3iE_xS0';

    const [legR, senGeo, asmGeo, uhGeo, ccGeo] = await Promise.all([
      fetch(SUPABASE_URL + '/rest/v1/current_legislators?select=person_id,name,party,chamber,district', { headers: { apikey: SUPABASE_ANON_KEY } }).then(r => r.json()),
      fetch('geo/senate.geojson').then(r => r.json()),
      fetch('geo/assembly.geojson').then(r => r.json()),
      fetch('geo/us_house.geojson').then(r => r.json()),
      fetch('geo/city_council.geojson').then(r => r.json()),
    ]);

    function pip(pt, ring) { let inside = false; for (let i = 0, j = ring.length - 1; i < ring.length; j = i++) { const [xi, yi] = ring[i], [xj, yj] = ring[j]; if (((yi > pt[1]) !== (yj > pt[1])) && (pt[0] < (xj - xi) * (pt[1] - yi) / (yj - yi) + xi)) inside = !inside; } return inside; }
    function findDist(geo, pt) { for (const f of geo.features) { const rings = f.geometry.type === 'MultiPolygon' ? f.geometry.coordinates.flatMap(p => p) : f.geometry.coordinates; for (const r of rings) { if (pip(pt, r)) return f; } } return null; }

    const pt = [lon, lat], found = [];
    legR.filter(l => l.chamber === 'us_senate').forEach(s => found.push(s));
    const uh = findDist(uhGeo, pt); if (uh) { const d = parseInt(uh.properties.BASENAME || uh.properties.DISTRICT); const r = legR.find(l => l.chamber === 'us_house' && l.district === d); if (r) found.push(r); }
    const sn = findDist(senGeo, pt); if (sn) { const d = parseInt(sn.properties.DISTRICT); const r = legR.find(l => l.chamber === 'senate' && l.district === d); if (r) found.push(r); }
    const as = findDist(asmGeo, pt); if (as) { const d = parseInt(as.properties.DISTRICT); const r = legR.find(l => l.chamber === 'assembly' && l.district === d); if (r) found.push(r); }
    const cc = findDist(ccGeo, pt); if (cc) { const d = parseInt(cc.properties.coundist || cc.properties.CounDist || cc.properties.DISTRICT); const r = legR.find(l => l.chamber === 'city_council' && l.district === d); if (r) found.push(r); const m = legR.find(l => l.chamber === 'nyc_mayor'); if (m) found.push(m); }

    if (found.length === 0) { alert('No representatives found.'); btn.textContent = origText; btn.disabled = false; return; }

    sessionStorage.setItem('shalomny_reps', JSON.stringify({
      address: geoData[0].display_name.split(',').slice(0, 3).join(','),
      lat, lon,
      reps: found.map(r => ({ person_id: r.person_id, name: r.name, party: r.party, chamber: r.chamber, district: r.district }))
    }));
    window.location = 'reps.html';
  } catch (err) {
    alert('Error: ' + err.message);
    btn.textContent = origText;
    btn.disabled = false;
  }
}
