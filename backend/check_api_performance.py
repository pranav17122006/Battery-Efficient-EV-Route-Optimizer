import requests
import time

API_KEY = "api key"

url = "https://api.openchargemap.io/v3/poi/"

params = {
    "output": "json",
    "countrycode": "IN",
    "latitude": 11.0168,
    "longitude": 76.9558,
    "distance": 150,
    "distanceunit": "KM",
    "maxresults": 100,
    "compact": "true",
    "verbose": "false",
    "key": API_KEY,
}

try:
    start = time.perf_counter()
    response = requests.get(url, params=params, timeout=20)
    elapsed = time.perf_counter() - start

    print("HTTP status:", response.status_code)
    print(f"Response time: {elapsed:.2f} seconds")
    response.raise_for_status()

    stations = response.json()
    print("Stations found:", len(stations))

    for station in stations[:10]:
        address = station.get("AddressInfo") or {}
        print({
            "name": station.get("AddressInfo", {}).get("Title"),
            "latitude": address.get("Latitude"),
            "longitude": address.get("Longitude"),
            "address": address.get("AddressLine1"),
        })

except requests.RequestException as error:
    print("API request failed:", error)

except ValueError:
    print("The API returned invalid JSON.")
