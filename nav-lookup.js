// Shared nav address lookup — uses NYC GeoClient API via Supabase Edge Function
async function navLookup() {
  const input = document.getElementById('nav-address');
  const address = input.value.trim();
  if (!address) return;

  const btn = input.nextElementSibling;
  const origText = btn.textContent;
  btn.textContent = 'Searching...';
  btn.disabled = true;

  const SUPABASE_URL = 'https://xeknqkxhfxvveeyddokl.supabase.co';
  const SUPABASE_ANON_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inhla25xa3hoZnh2dmVleWRkb2tsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzUyMjc1MzksImV4cCI6MjA5MDgwMzUzOX0.-CO0RkDBljPTRBO5x5JIAIZ23WfhR0A8bLJV3iE_xS0';

  try {
    // Call GeoClient via edge function
    const resp = await fetch(
      `${SUPABASE_URL}/functions/v1/geoclient?input=${encodeURIComponent(address)}`,
      { headers: { Authorization: `Bearer ${SUPABASE_ANON_KEY}` } }
    );
    const data = await resp.json();

    if (data.error) {
      alert('Address not found. Please enter a valid NYC address.');
      btn.textContent = origText; btn.disabled = false;
      return;
    }

    // Fetch legislators
    const legR = await fetch(
      `${SUPABASE_URL}/rest/v1/current_legislators?select=person_id,name,party,chamber,district`,
      { headers: { apikey: SUPABASE_ANON_KEY } }
    ).then(r => r.json());

    const d = data.districts;
    const found = [];

    // US Senators
    legR.filter(l => l.chamber === 'us_senate').forEach(s => found.push(s));

    // US House
    if (d.congress) {
      const rep = legR.find(l => l.chamber === 'us_house' && l.district === d.congress);
      if (rep) found.push(rep);
    }

    // State Senate
    if (d.stateSenate) {
      const rep = legR.find(l => l.chamber === 'senate' && l.district === d.stateSenate);
      if (rep) found.push(rep);
    }

    // Assembly
    if (d.assembly) {
      const rep = legR.find(l => l.chamber === 'assembly' && l.district === d.assembly);
      if (rep) found.push(rep);
    }

    // City Council + Mayor
    if (d.cityCouncil) {
      const rep = legR.find(l => l.chamber === 'city_council' && l.district === d.cityCouncil);
      if (rep) found.push(rep);
      const mayor = legR.find(l => l.chamber === 'nyc_mayor');
      if (mayor) found.push(mayor);
    }

    if (found.length === 0) {
      alert('No representatives found.');
      btn.textContent = origText; btn.disabled = false;
      return;
    }

    const displayAddress = `${data.address.houseNumber} ${data.address.street}, ${data.address.borough}`;
    sessionStorage.setItem('shalomny_reps', JSON.stringify({
      address: displayAddress,
      lat: data.latitude,
      lon: data.longitude,
      reps: found.map(r => ({ person_id: r.person_id, name: r.name, party: r.party, chamber: r.chamber, district: r.district }))
    }));
    window.location = 'reps.html?address=' + encodeURIComponent(address);
  } catch (err) {
    alert('Error: ' + err.message);
    btn.textContent = origText;
    btn.disabled = false;
  }
}
