import { serve } from "https://deno.land/std@0.168.0/http/server.ts";

const GEOCLIENT_KEY = Deno.env.get("GEOCLIENT_API_KEY") || "";
const GEOCLIENT_URL = "https://api.nyc.gov/geoclient/v2/search";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Methods": "GET, OPTIONS",
  "Access-Control-Allow-Headers": "Content-Type, Authorization, apikey",
};

serve(async (req) => {
  if (req.method === "OPTIONS") {
    return new Response(null, { headers: corsHeaders });
  }

  const url = new URL(req.url);
  const input = url.searchParams.get("input");

  if (!input) {
    return new Response(JSON.stringify({ error: "Missing 'input' parameter" }), {
      status: 400,
      headers: { ...corsHeaders, "Content-Type": "application/json" },
    });
  }

  // Normalize abbreviations for GeoClient
  const normalized = input
    .replace(/\bW\.?\s+/gi, "West ")
    .replace(/\bE\.?\s+/gi, "East ")
    .replace(/\bN\.?\s+/gi, "North ")
    .replace(/\bS\.?\s+/gi, "South ")
    .replace(/\bSt\.?\b/gi, "Street")
    .replace(/\bAve\.?\b/gi, "Avenue")
    .replace(/\bBlvd\.?\b/gi, "Boulevard")
    .replace(/\bPl\.?\b/gi, "Place")
    .replace(/\bDr\.?\b/gi, "Drive")
    .replace(/\bRd\.?\b/gi, "Road")
    .replace(/\bCt\.?\b/gi, "Court")
    .replace(/\bLn\.?\b/gi, "Lane")
    .replace(/\bPkwy\.?\b/gi, "Parkway")
    .replace(/\bBrooklyn\b/gi, "Brooklyn")
    .replace(/\bQueens\b/gi, "Queens")
    .replace(/\bBronx\b/gi, "Bronx")
    .replace(/\bManhattan\b/gi, "Manhattan")
    .replace(/\bStaten Island\b/gi, "Staten Island")
    .replace(/\bNY\s*\d{5}\b/, "") // strip zip
    .replace(/\bNew York,?\s*(NY)?\s*$/i, "Manhattan")
    .trim();

  try {
    const geoclientResp = await fetch(
      `${GEOCLIENT_URL}?input=${encodeURIComponent(normalized)}`,
      { headers: { "Ocp-Apim-Subscription-Key": GEOCLIENT_KEY } }
    );

    const data = await geoclientResp.json();

    if (data.status !== "OK" || !data.results?.length) {
      return new Response(JSON.stringify({ error: "Address not found", raw: data }), {
        status: 404,
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      });
    }

    const r = data.results[0].response;

    const result = {
      status: "OK",
      input: data.input,
      address: {
        houseNumber: r.houseNumber || r.giLowHouseNumber1,
        street: r.firstStreetNameNormalized || r.boePreferredStreetName,
        borough: r.firstBoroughName,
        zip: r.zipCode,
      },
      districts: {
        cityCouncil: r.cityCouncilDistrict ? parseInt(r.cityCouncilDistrict) : null,
        assembly: r.assemblyDistrict ? parseInt(r.assemblyDistrict) : null,
        stateSenate: r.stateSenatorialDistrict ? parseInt(r.stateSenatorialDistrict) : null,
        congress: r.congressionalDistrict ? parseInt(r.congressionalDistrict) : null,
      },
      communityDistrict: r.communityDistrict,
      censusTract: r.censusTract2020?.trim(),
      latitude: r.latitude,
      longitude: r.longitude,
    };

    return new Response(JSON.stringify(result), {
      headers: { ...corsHeaders, "Content-Type": "application/json" },
    });
  } catch (err) {
    return new Response(JSON.stringify({ error: err.message }), {
      status: 500,
      headers: { ...corsHeaders, "Content-Type": "application/json" },
    });
  }
});
