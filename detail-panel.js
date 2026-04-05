// Shared detail panel — renders legislator detail in a slide-out overlay
// Requires: #detail-overlay div with #detail-panel-content inside

const DETAIL_SUPABASE_URL = 'https://xeknqkxhfxvveeyddokl.supabase.co';
const DETAIL_SUPABASE_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inhla25xa3hoZnh2dmVleWRkb2tsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzUyMjc1MzksImV4cCI6MjA5MDgwMzUzOX0.-CO0RkDBljPTRBO5x5JIAIZ23WfhR0A8bLJV3iE_xS0';

const DP_CHAMBER_LABELS = { us_senate: 'US Senate', us_house: 'US House', senate: 'State Senate', assembly: 'State Assembly', city_council: 'City Council', nyc_mayor: 'NYC Mayor' };
const DP_STANCE_COLORS = { strongly_support: '#15803d', support: '#4ade80', neutral: '#a1a1aa', oppose: '#fb923c', strongly_oppose: '#c2410c' };
const DP_STANCE_LABELS = { strongly_support: 'Strongly Pro-Israel', support: 'Pro-Israel', neutral: 'Neutral', oppose: 'Anti-Israel', strongly_oppose: 'Strongly Anti-Israel' };

let _dpCache = { legs: null, positions: null, criteria: null };

function _dpPartyColor(p) {
  if (!p) return '#9ca3af';
  p = p.toLowerCase();
  return p.includes('democrat') ? '#3b82f6' : p.includes('republican') ? '#ef4444' : '#9ca3af';
}

async function _dpEnsureData() {
  if (_dpCache.legs) return;
  const [legR, posR, critR] = await Promise.all([
    fetch(`${DETAIL_SUPABASE_URL}/rest/v1/current_legislators?select=person_id,name,party,chamber,district,phone_albany,phone_district,email,website,start_date,end_date&order=name`, { headers: { apikey: DETAIL_SUPABASE_KEY } }),
    fetch(`${DETAIL_SUPABASE_URL}/rest/v1/positions?select=person_id,stance,confidence,rationale&assessment_type=eq.ai&topic_id=eq.1`, { headers: { apikey: DETAIL_SUPABASE_KEY } }),
    fetch(`${DETAIL_SUPABASE_URL}/rest/v1/person_criteria?select=person_id,criterion_id,evidence,source_url,source_date,criteria(label,direction,category,weight)&order=source_date.desc.nullslast,id.desc`, { headers: { apikey: DETAIL_SUPABASE_KEY } }),
  ]);
  _dpCache.legs = await legR.json();
  const pos = await posR.json();
  _dpCache.positions = {};
  for (const p of pos) _dpCache.positions[p.person_id] = p;
  _dpCache.criteria = await critR.json();
}

async function openDetailPanel(personId) {
  const overlay = document.getElementById('detail-overlay');
  const content = document.getElementById('detail-panel-content');
  if (!overlay || !content) return;

  overlay.classList.add('open');
  overlay.scrollTop = 0;
  content.innerHTML = '<div style="padding:40px;text-align:center;color:#94a3b8;">Loading...</div>';

  await _dpEnsureData();

  const leg = _dpCache.legs.find(l => l.person_id === personId);
  if (!leg) { content.innerHTML = '<div style="padding:40px;text-align:center;color:#94a3b8;">Legislator not found.</div>'; return; }

  const pos = _dpCache.positions[personId];
  const criteria = _dpCache.criteria.filter(c => c.person_id === personId);
  const hasStance = pos && pos.confidence !== 'unknown';
  const sColor = hasStance ? (DP_STANCE_COLORS[pos.stance] || '#9ca3af') : '#d1d5db';
  const sLabel = hasStance ? (DP_STANCE_LABELS[pos.stance] || 'Unknown') : 'Unknown';

  // Contact info
  let contactHTML = '';
  if (leg.phone_albany) contactHTML += `<div>Albany: ${leg.phone_albany}</div>`;
  if (leg.phone_district) contactHTML += `<div>District: ${leg.phone_district}</div>`;
  if (leg.email) contactHTML += `<div><a href="mailto:${leg.email}">${leg.email}</a></div>`;
  if (leg.website) contactHTML += `<div><a href="${leg.website}" target="_blank">${leg.website.replace(/^https?:\/\//, '')}</a></div>`;
  if (leg.start_date) contactHTML += `<div>Term: ${leg.start_date} — ${leg.end_date || 'present'}</div>`;

  // Evidence timeline
  let timelineHTML = '';
  if (criteria.length > 0) {
    timelineHTML = '<div class="dp-evidence-title">Evidence Timeline</div>';
    for (const c of criteria) {
      const dir = c.criteria?.direction || 'unknown';
      const isAnti = dir === 'anti';
      const dotColor = isAnti ? '#c2410c' : '#15803d';
      const cardClass = isAnti ? 'anti' : 'pro';
      const catLabel = (c.criteria?.category || 'action').replace('_', ' ').toUpperCase();
      const dateStr = c.source_date || '';
      const dateDisplay = dateStr ? `<span style="color:#999;margin-left:8px">${dateStr}</span>` : '';
      const url = c.source_url || (c.evidence ? (c.evidence.match(/https?:\/\/[^\s),'"]+/) || [])[0] : null);
      const sourceLink = url ? `<a href="${url}" target="_blank" class="dp-tc-source">View source &rarr;</a>` : '';
      const cleanEvidence = (c.evidence || '').replace(/https?:\/\/[^\s),'"]+/g, '').replace(/Sources?:\s*,?\s*$/i, '').trim();
      timelineHTML += `
        <div class="dp-timeline-item">
          <div class="dp-timeline-dot" style="background:${dotColor}"></div>
          <div class="dp-timeline-card ${cardClass}">
            <div class="dp-tc-header">${catLabel}${dateDisplay}</div>
            <div class="dp-tc-title">${c.criteria?.label || ''}</div>
            ${cleanEvidence ? `<div class="dp-tc-desc">${cleanEvidence}</div>` : ''}
            ${sourceLink}
          </div>
        </div>`;
    }
  }

  // AI rationale
  let rationaleHTML = '';
  if (pos && pos.rationale) {
    rationaleHTML = `<div class="dp-rationale"><strong style="color:#444">AI Assessment:</strong> ${pos.rationale}</div>`;
  }

  const chamberLabel = leg.chamber === 'nyc_mayor' ? 'NYC Mayor' : `${DP_CHAMBER_LABELS[leg.chamber] || leg.chamber} District ${leg.district}`;

  content.innerHTML = `
    <div class="dp-header">
      <button class="dp-close" onclick="closeDetailPanel()">&times;</button>
      <h2>${leg.name}</h2>
      <div class="dp-subtitle">${chamberLabel} <span class="dp-party-pill" style="background:${_dpPartyColor(leg.party)}">${leg.party || 'Unknown'}</span></div>
      <a href="legislator.html?id=${personId}" style="display:inline-block;margin-top:8px;font-size:13px;font-weight:600;color:#2563eb;text-decoration:none;">View full profile &rarr;</a>
    </div>
    <div class="dp-body">
      ${contactHTML ? `
        <div class="dp-contact-toggle" onclick="this.nextElementSibling.style.display=this.nextElementSibling.style.display==='none'?'block':'none'; this.querySelector('span').textContent=this.nextElementSibling.style.display==='none'?'\\u25B8':'\\u25BE'">
          <span>&#x25B8;</span> Contact Details
        </div>
        <div class="dp-contact-details" style="display:none">${contactHTML}</div>
      ` : ''}
      <div class="dp-stance-row">
        <span class="dp-stance-badge" style="background:${sColor}">${sLabel}</span>
      </div>
      ${rationaleHTML}
      ${timelineHTML}
    </div>`;
}

function closeDetailPanel() {
  const overlay = document.getElementById('detail-overlay');
  if (overlay) overlay.classList.remove('open');
}

document.addEventListener('keydown', e => { if (e.key === 'Escape') closeDetailPanel(); });
