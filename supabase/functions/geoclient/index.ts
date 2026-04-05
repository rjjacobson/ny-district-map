import { serve } from "https://deno.land/std@0.168.0/http/server.ts";

const GEOCLIENT_KEY = Deno.env.get("GEOCLIENT_API_KEY") || "";
const GEOCLIENT_URL = "https://api.nyc.gov/geoclient/v2/search";
const CENSUS_URL = "https://geocoding.geo.census.gov/geocoder/geographies/onelineaddress";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Methods": "GET, OPTIONS",
  "Access-Control-Allow-Headers": "Content-Type, Authorization, apikey",
};

// Normalize abbreviations for better geocoding
function normalizeAddress(input: string): string {
  return input
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
    .trim();
}

// Check if address looks like it's in NYC
function looksLikeNYC(input: string): boolean {
  const nyc = /\b(manhattan|brooklyn|queens|bronx|staten island|new york|nyc)\b/i;
  const nycZips = /\b(100\d{2}|101\d{2}|102\d{2}|103\d{2}|104\d{2}|110\d{2}|112\d{2}|113\d{2}|114\d{2}|116\d{2})\b/;
  return nyc.test(input) || nycZips.test(input);
}

// Try NYC GeoClient API
async function tryGeoClient(input: string) {
  const normalized = normalizeAddress(input)
    .replace(/\bBrooklyn\b/gi, "Brooklyn")
    .replace(/\bQueens\b/gi, "Queens")
    .replace(/\bBronx\b/gi, "Bronx")
    .replace(/\bManhattan\b/gi, "Manhattan")
    .replace(/\bStaten Island\b/gi, "Staten Island")
    .replace(/\bNY\s*\d{5}\b/, "")
    .replace(/\bNew York,?\s*(NY)?\s*$/i, "Manhattan")
    .trim();

  const resp = await fetch(
    `${GEOCLIENT_URL}?input=${encodeURIComponent(normalized)}`,
    { headers: { "Ocp-Apim-Subscription-Key": GEOCLIENT_KEY } }
  );
  const data = await resp.json();

  if (data.status !== "OK" || !data.results?.length) return null;

  const r = data.results[0].response;
  return {
    status: "OK",
    source: "geoclient",
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
    latitude: r.latitude,
    longitude: r.longitude,
  };
}

// Try Census Geocoder (works for all US addresses, returns state legislative districts)
async function tryCensus(input: string) {
  const resp = await fetch(
    `${CENSUS_URL}?address=${encodeURIComponent(input)}&benchmark=Public_AR_Current&vintage=Current_Current&format=json`
  );
  const data = await resp.json();
  const matches = data?.result?.addressMatches;
  if (!matches?.length) return null;

  const match = matches[0];
  const geo = match.geographies || {};

  // Helper to find a geography layer by partial key match
  function findGeo(keyword: string, keyword2?: string): Record<string, string> | null {
    for (const [k, v] of Object.entries(geo)) {
      if (k.includes(keyword) && (!keyword2 || k.includes(keyword2))) {
        const arr = v as Record<string, string>[];
        return arr?.[0] || null;
      }
    }
    return null;
  }

  // Check if in New York State (FIPS 36)
  const stateGeo = findGeo("States");
  const countyGeo = findGeo("Counties");
  const stateCode = stateGeo?.STATEFP || countyGeo?.STATEFP;
  if (stateCode && stateCode !== "36") {
    return { status: "ERROR", error: "Address is not in New York State" };
  }

  const congress = findGeo("Congressional");
  const upper = findGeo("Legislative", "Upper");
  const lower = findGeo("Legislative", "Lower");

  const ac = match.addressComponents || {};
  const street = [ac.preQualifier, ac.preDirection, ac.streetName, ac.suffixType, ac.suffixDirection]
    .filter(Boolean).join(" ").trim();

  return {
    status: "OK",
    source: "census",
    input: match.matchedAddress,
    address: {
      houseNumber: ac.fromAddress,
      street: street,
      borough: ac.city,
      zip: ac.zip,
    },
    districts: {
      cityCouncil: null, // Census doesn't have city council
      assembly: lower?.BASENAME ? parseInt(lower.BASENAME) : null,
      stateSenate: upper?.BASENAME ? parseInt(upper.BASENAME) : null,
      congress: congress?.BASENAME ? parseInt(congress.BASENAME) : null,
    },
    latitude: match.coordinates?.y,
    longitude: match.coordinates?.x,
  };
}

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

  try {
    let result = null;

    // Try NYC GeoClient first for NYC-looking addresses
    if (looksLikeNYC(input)) {
      result = await tryGeoClient(input);
    }

    // If GeoClient didn't work (or not NYC), try Census Geocoder
    if (!result) {
      result = await tryCensus(input);
    }

    // If still nothing, try GeoClient as last resort (sometimes works without borough)
    if (!result) {
      result = await tryGeoClient(input);
    }

    if (!result || result.status === "ERROR") {
      return new Response(
        JSON.stringify({ error: result?.error || "Address not found. Please include a street address and city/borough." }),
        { status: 404, headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    }

    return new Response(JSON.stringify(result), {
      headers: { ...corsHeaders, "Content-Type": "application/json" },
    });
  } catch (err) {
    return new Response(JSON.stringify({ error: (err as Error).message }), {
      status: 500,
      headers: { ...corsHeaders, "Content-Type": "application/json" },
    });
  }
});
