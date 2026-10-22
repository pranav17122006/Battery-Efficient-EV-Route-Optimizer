

import os
import requests

from fastapi import FastAPI, HTTPException, Query
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel, Field

app = FastAPI(
    title="Battery-Efficient EV Route Optimizer",
    description="OpenStreetMap geocoding and alternative driving routes",
    version="1.0.0",
)

# For local development. Restrict origins when deploying.
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=False,
    allow_methods=["GET", "POST"],
    allow_headers=["*"],
)

NOMINATIM_URL = "https://nominatim.openstreetmap.org/search"
OSRM_URL = os.getenv(
    "OSRM_URL",
    "https://router.project-osrm.org"
)

# Identify your app when using public Nominatim.
HEADERS = {
    "User-Agent": "BatteryEfficientEVRouteOptimizer/1.0 (student project)"
}

session = requests.Session()
session.headers.update(HEADERS)


class Location(BaseModel):
    name: str = Field(min_length=2, max_length=250)


class RouteRequest(BaseModel):
    source: Location
    destination: Location
    alternatives: int = Field(default=3, ge=0, le=5)

    # Estimated usable battery capacity is not required here;
    # this value represents consumption in kWh per 100 km.
    consumption_kwh_per_100km: float = Field(
        default=16.0, gt=0, le=100
    )


def geocode(place: str) -> dict:
    """Convert a place name or address to OSM coordinates."""
    try:
        response = session.get(
            NOMINATIM_URL,
            params={
                "q": place,
                "format": "jsonv2",
                "limit": 1,
            },
            timeout=15,
        )
        response.raise_for_status()
        results = response.json()

    except requests.RequestException as exc:
        raise HTTPException(
            status_code=502,
            detail=f"Geocoding service error: {exc}",
        ) from exc

    if not results:
        raise HTTPException(
            status_code=404,
            detail=f"Location not found: {place}",
        )

    result = results[0]

    return {
        "name": result.get("display_name", place),
        "latitude": float(result["lat"]),
        "longitude": float(result["lon"]),
    }


@app.get("/")
def home():
    return {
        "message": "EV Route Optimizer API is running",
        "docs": "/docs",
    }


@app.get("/search")
def search_location(
    q: str = Query(min_length=2, max_length=250)
):
    """Search for a location and return its coordinates."""
    return geocode(q)


@app.post("/routes")
def calculate_routes(request: RouteRequest):
    """Return alternative routes and rank them by estimated energy."""

    source = geocode(request.source.name)
    destination = geocode(request.destination.name)

    # OSRM coordinate order is longitude,latitude.
    coordinates = (
        f"{source['longitude']},{source['latitude']};"
        f"{destination['longitude']},{destination['latitude']}"
    )

    url = f"{OSRM_URL.rstrip('/')}/route/v1/driving/{coordinates}"

    try:
        response = session.get(
            url,
            params={
                "alternatives": request.alternatives,
                "overview": "full",
                "geometries": "geojson",
                "steps": "true",
            },
            timeout=45,
        )
        response.raise_for_status()
        data = response.json()

    except requests.RequestException as exc:
        raise HTTPException(
            status_code=502,
            detail=f"Routing service error: {exc}",
        ) from exc

    if data.get("code") != "Ok" or not data.get("routes"):
        raise HTTPException(
            status_code=404,
            detail="No driving route found for these locations.",
        )

    routes = []

    for index, route in enumerate(data["routes"], start=1):
        distance_m = float(route["distance"])
        duration_s = float(route["duration"])

        distance_km = distance_m / 1000.0

        # Simple baseline energy estimate, not a vehicle simulation.
        energy_kwh = (
            distance_km
            * request.consumption_kwh_per_100km
            / 100.0
        )

        routes.append({
            "route_id": index,
            "distance_km": round(distance_km, 2),
            "duration_minutes": round(duration_s / 60.0, 1),
            "estimated_energy_kwh": round(energy_kwh, 2),
            "estimated_wh_per_km": round(
                energy_kwh * 1000 / distance_km, 1
            ) if distance_km > 0 else 0,
            "geometry": route["geometry"],
            "steps": [
                {
                    "instruction": step.get("name", ""),
                    "distance_m": round(step.get("distance", 0), 1),
                    "duration_s": round(step.get("duration", 0), 1),
                    "maneuver": step.get("maneuver", {}),
                }
                for leg in route.get("legs", [])
                for step in leg.get("steps", [])
            ],
        })

    # Lowest estimated energy first.
    routes.sort(key=lambda item: item["estimated_energy_kwh"])

    for rank, route in enumerate(routes, start=1):
        route["energy_rank"] = rank

    return {
        "source": source,
        "destination": destination,
        "routes_found": len(routes),
        "requested_alternatives": request.alternatives,
        "energy_model": (
            "Distance-based estimate; does not account for "
            "elevation, traffic, weather, or regenerative braking."
        ),
        "routes": routes,
    }




#D:\projects\ev_route_optimizer\lib\backend>uvicorn app:app --host 0.0.0.0 --port 8000
