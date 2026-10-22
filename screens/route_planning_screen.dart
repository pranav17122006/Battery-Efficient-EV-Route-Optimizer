// import 'dart:convert';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:http/http.dart' as http;
// import 'package:latlong2/latlong.dart';

// enum PinMode { none, source, destination }

// class RouteModel {
//   final int index;
//   final String name;
//   final double distanceKm;
//   final double durationMin;
//   final List<LatLng> points;
//   final double baseEnergyKwh;
//   final double adjustedEnergyKwh;
//   final double tempC;
//   final double elevationChangeM;
//   final String weatherCondition;
//   final double weatherMultiplier;
//   final double terrainMultiplier;

//   const RouteModel({
//     required this.index,
//     required this.name,
//     required this.distanceKm,
//     required this.durationMin,
//     required this.points,
//     required this.baseEnergyKwh,
//     required this.adjustedEnergyKwh,
//     required this.tempC,
//     required this.elevationChangeM,
//     required this.weatherCondition,
//     required this.weatherMultiplier,
//     required this.terrainMultiplier,
//   });
// }

// // ================= PERSISTENT APP SESSION CACHE =================
// // Lives in memory until the user completely closes/kills the application.
// class RoutePlanningSession {
//   static LatLng? sourcePos;
//   static LatLng? destPos;
//   static String sourceText = 'Coimbatore';
//   static String destText = 'Chennai';
//   static String sourceLabel = 'Coimbatore';
//   static String destLabel = 'Chennai';
//   static List<RouteModel> cachedRoutes = [];
//   static int selectedRouteIndex = 0;
//   static double currentBatteryPercent = 75.0;
//   static LatLng? mapCenter;
//   static double mapZoom = 6.0;
// }

// class RoutePlanningScreen extends StatefulWidget {
//   const RoutePlanningScreen({super.key});

//   @override
//   State<RoutePlanningScreen> createState() => _RoutePlanningScreenState();
// }

// class _RoutePlanningScreenState extends State<RoutePlanningScreen> {
//   static const String apiBase = 'http://192.168.137.1:8000';

//   static const Color bg = Color(0xFF070B16);
//   static const Color panel = Color(0xFF0E1526);
//   static const Color green = Color(0xFF1ECB6B);
//   static const Color muted = Color(0xFF78829D);

//   final int _selectedIndex = 1;
//   final MapController _mapController = MapController();

//   late final TextEditingController _sourceSearchCtrl;
//   late final TextEditingController _destinationSearchCtrl;

//   PinMode _currentPinMode = PinMode.none;

//   LatLng? _sourcePos;
//   LatLng? _destPos;

//   String _sourceLabel = 'Coimbatore';
//   String _destLabel = 'Chennai';

//   bool _isFetchingGps = false;
//   bool _isCalculating = false;
//   bool _isSavingRoute = false;

//   String? _error;

//   List<RouteModel> _routes = [];
//   int _selectedRouteIndex = 0;

//   double _currentBatteryPercent = 75.0;

//   // Fetched dynamically from Firebase Firestore
//   double _batteryCapacityKwh = 75.0;
//   double _baseConsumptionKwh100km = 15.5;
//   String _vehicleName = 'Your EV';

//   final List<Color> _routeColors = const [
//     Color(0xFF1ECB6B),
//     Color(0xFF42B7FF),
//     Color(0xFFFFB74D),
//     Color(0xFFE879F9),
//     Color(0xFFFF6B6B),
//   ];

//   @override
//   void initState() {
//     super.initState();
//     // 1. Restore state from previous visits in this app session
//     _sourcePos = RoutePlanningSession.sourcePos;
//     _destPos = RoutePlanningSession.destPos;
//     _sourceLabel = RoutePlanningSession.sourceLabel;
//     _destLabel = RoutePlanningSession.destLabel;
//     _routes = List.from(RoutePlanningSession.cachedRoutes);
//     _selectedRouteIndex = RoutePlanningSession.selectedRouteIndex;
//     _currentBatteryPercent = RoutePlanningSession.currentBatteryPercent;

//     _sourceSearchCtrl =
//         TextEditingController(text: RoutePlanningSession.sourceText);
//     _destinationSearchCtrl =
//         TextEditingController(text: RoutePlanningSession.destText);

//     _fetchUserVehicleSpecs();

//     // 2. Reposition camera if locations or routes were previously planned
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (!mounted) return;
//       if (_routes.isNotEmpty) {
//         final allPoints = <LatLng>[
//           for (final route in _routes) ...route.points
//         ];
//         if (allPoints.isNotEmpty) {
//           try {
//             _mapController.fitCamera(
//               CameraFit.bounds(
//                 bounds: LatLngBounds.fromPoints(allPoints),
//                 padding: const EdgeInsets.all(40),
//               ),
//             );
//           } catch (_) {}
//         }
//       } else if (RoutePlanningSession.mapCenter != null) {
//         _mapController.move(
//           RoutePlanningSession.mapCenter!,
//           RoutePlanningSession.mapZoom,
//         );
//       }
//     });
//   }

//   @override
//   void dispose() {
//     // Save controller inputs to persistent session
//     RoutePlanningSession.sourceText = _sourceSearchCtrl.text;
//     RoutePlanningSession.destText = _destinationSearchCtrl.text;
//     _sourceSearchCtrl.dispose();
//     _destinationSearchCtrl.dispose();
//     super.dispose();
//   }

//   void _syncToSession() {
//     RoutePlanningSession.sourcePos = _sourcePos;
//     RoutePlanningSession.destPos = _destPos;
//     RoutePlanningSession.sourceLabel = _sourceLabel;
//     RoutePlanningSession.destLabel = _destLabel;
//     RoutePlanningSession.sourceText = _sourceSearchCtrl.text;
//     RoutePlanningSession.destText = _destinationSearchCtrl.text;
//     RoutePlanningSession.cachedRoutes = _routes;
//     RoutePlanningSession.selectedRouteIndex = _selectedRouteIndex;
//     RoutePlanningSession.currentBatteryPercent = _currentBatteryPercent;
//   }

//   Future<void> _fetchUserVehicleSpecs() async {
//     final user = FirebaseAuth.instance.currentUser;
//     if (user == null) return;

//     try {
//       final doc = await FirebaseFirestore.instance
//           .collection('users')
//           .doc(user.uid)
//           .get();

//       if (doc.exists && doc.data() != null) {
//         final data = doc.data()!;
//         if (!mounted) return;
//         setState(() {
//           _batteryCapacityKwh =
//               (data['batteryCapacityKwh'] ?? 75.0).toDouble();
//           _baseConsumptionKwh100km =
//               (data['avgConsumption'] ?? 15.5).toDouble();

//           final brand = data['vehicleBrand'] ?? '';
//           final model = data['vehicleModel'] ?? '';
//           if (brand.isNotEmpty || model.isNotEmpty) {
//             _vehicleName = '$brand $model'.trim();
//           }
//         });
//       }
//     } catch (_) {}
//   }

//   Future<void> _saveRoutePlan(RouteModel route) async {
//     final user = FirebaseAuth.instance.currentUser;
//     if (user == null) {
//       _showMessage('Please login to save this route plan.');
//       return;
//     }

//     setState(() => _isSavingRoute = true);

//     try {
//       final now = DateTime.now();
//       final tripData = {
//         'userId': user.uid,
//         'source': _sourceLabel,
//         'destination': _destLabel,
//         'distanceKm': double.parse(route.distanceKm.toStringAsFixed(2)),
//         'kwhNeeded': double.parse(route.adjustedEnergyKwh.toStringAsFixed(2)),
//         'durationMinutes': double.parse(route.durationMin.toStringAsFixed(1)),
//         'dateTime': now.toIso8601String(),
//         'createdAt': FieldValue.serverTimestamp(),
//       };

//       await FirebaseFirestore.instance
//           .collection('users')
//           .doc(user.uid)
//           .collection('trips')
//           .add(tripData);

//       _showMessage('Route saved to Trip History!');
//     } catch (e) {
//       _showMessage('Failed to save route: $e');
//     } finally {
//       if (mounted) setState(() => _isSavingRoute = false);
//     }
//   }

//   double _number(dynamic value, [double fallback = 0]) {
//     if (value is num) return value.toDouble();
//     return double.tryParse('$value') ?? fallback;
//   }

//   void _showMessage(String message) {
//     if (!mounted) return;
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         backgroundColor: const Color(0xFF202A3D),
//       ),
//     );
//   }

//   void _onBottomNavTapped(int index) {
//     if (index == _selectedIndex) return;
//     _syncToSession();

//     final routes = <int, String>{
//       0: '/dashboard',
//       2: '/charging',
//       3: '/trips',
//       4: '/profile',
//     };
//     final routeName = routes[index];
//     if (routeName != null) {
//       Navigator.pushReplacementNamed(context, routeName);
//     }
//   }

//   // ------------------------------------------------------------
//   // GPS LOCATION
//   // ------------------------------------------------------------

//   Future<void> _useCurrentGpsLocation() async {
//     setState(() {
//       _isFetchingGps = true;
//       _error = null;
//     });

//     try {
//       final serviceEnabled = await Geolocator.isLocationServiceEnabled();
//       if (!serviceEnabled) {
//         throw Exception('Enable location services on your phone.');
//       }

//       var permission = await Geolocator.checkPermission();
//       if (permission == LocationPermission.denied) {
//         permission = await Geolocator.requestPermission();
//       }
//       if (permission == LocationPermission.denied) {
//         throw Exception('Location permission was denied.');
//       }
//       if (permission == LocationPermission.deniedForever) {
//         throw Exception('Enable location permission in your phone settings.');
//       }

//       final position = await Geolocator.getCurrentPosition(
//         locationSettings: const LocationSettings(
//           accuracy: LocationAccuracy.high,
//         ),
//       );

//       final point = LatLng(position.latitude, position.longitude);
//       if (!mounted) return;

//       setState(() {
//         _sourcePos = point;
//         _sourceLabel = 'Current GPS Location';
//         _sourceSearchCtrl.text = '${point.latitude}, ${point.longitude}';
//         _currentPinMode = PinMode.none;
//       });

//       _syncToSession();
//       RoutePlanningSession.mapCenter = point;
//       RoutePlanningSession.mapZoom = 12.0;
//       _mapController.move(point, 12);
//     } catch (e) {
//       _showMessage(e.toString().replaceFirst('Exception: ', ''));
//     } finally {
//       if (mounted) setState(() => _isFetchingGps = false);
//     }
//   }

//   // ------------------------------------------------------------
//   // MAP PINNING
//   // ------------------------------------------------------------

//   void _onMapTap(TapPosition tapPosition, LatLng point) {
//     if (_currentPinMode == PinMode.none) return;

//     final coordinateText =
//         '${point.latitude.toStringAsFixed(6)}, ${point.longitude.toStringAsFixed(6)}';

//     setState(() {
//       if (_currentPinMode == PinMode.source) {
//         _sourcePos = point;
//         _sourceLabel = coordinateText;
//         _sourceSearchCtrl.text = coordinateText;
//       } else {
//         _destPos = point;
//         _destLabel = coordinateText;
//         _destinationSearchCtrl.text = coordinateText;
//       }
//       _currentPinMode = PinMode.none;
//     });

//     _syncToSession();
//   }

//   // ------------------------------------------------------------
//   // SEARCH A LOCATION USING BACKEND /search
//   // ------------------------------------------------------------

//   Future<void> _searchLocation({required bool source}) async {
//     final controller =
//         source ? _sourceSearchCtrl : _destinationSearchCtrl;
//     final query = controller.text.trim();

//     if (query.isEmpty) {
//       _showMessage('Enter a location to search.');
//       return;
//     }

//     FocusScope.of(context).unfocus();

//     try {
//       final uri = Uri.parse('$apiBase/search').replace(
//         queryParameters: {'q': query},
//       );

//       final response =
//           await http.get(uri).timeout(const Duration(seconds: 30));

//       if (response.statusCode != 200) {
//         throw Exception(
//           'Location search failed (${response.statusCode}). Check backend /search.',
//         );
//       }

//       final decoded = jsonDecode(response.body);
//       dynamic result = decoded;

//       if (decoded is List) {
//         if (decoded.isEmpty) {
//           throw Exception('Location not found. Try another name.');
//         }
//         result = decoded.first;
//       }

//       if (result is Map && result['results'] is List) {
//         final results = result['results'] as List;
//         if (results.isEmpty) throw Exception('Location not found.');
//         result = results.first;
//       }

//       if (result is! Map) {
//         throw Exception('Unexpected location search response.');
//       }

//       final lat = _number(result['lat'] ?? result['latitude'], double.nan);
//       final lon = _number(
//         result['lon'] ?? result['lng'] ?? result['longitude'],
//         double.nan,
//       );

//       if (!lat.isFinite ||
//           !lon.isFinite ||
//           lat < -90 ||
//           lat > 90 ||
//           lon < -180 ||
//           lon > 180) {
//         throw Exception('Search response contains invalid coordinates.');
//       }

//       final point = LatLng(lat, lon);
//       if (!mounted) return;

//       setState(() {
//         if (source) {
//           _sourcePos = point;
//           _sourceLabel = query;
//         } else {
//           _destPos = point;
//           _destLabel = query;
//         }
//         _error = null;
//       });

//       _syncToSession();
//       RoutePlanningSession.mapCenter = point;
//       RoutePlanningSession.mapZoom = 11.0;
//       _mapController.move(point, 11);
//     } catch (e) {
//       _showMessage(e.toString().replaceFirst('Exception: ', ''));
//     }
//   }

//   // ------------------------------------------------------------
//   // 3-SEGMENT WEATHER AND TERRAIN CALCULATION
//   // ------------------------------------------------------------

//   Future<Map<String, dynamic>> _processRouteImpact(
//     List<LatLng> points,
//     double totalDistanceKm,
//   ) async {
//     double baseEnergyTotal =
//         totalDistanceKm / 100.0 * _baseConsumptionKwh100km;

//     if (points.length < 4) {
//       return {
//         'adjustedEnergy': baseEnergyTotal,
//         'avgTemp': 30.0,
//         'totalElevationChange': 0.0,
//         'weatherDesc': 'Short route - base calculation used',
//       };
//     }

//     int n = points.length;
//     LatLng p0 = points.first;
//     LatLng p1 = points[n ~/ 3];
//     LatLng p2 = points[2 * n ~/ 3];
//     LatLng p3 = points.last;

//     const Distance distanceCalc = Distance();
//     double d1 = distanceCalc.as(LengthUnit.Meter, p0, p1) / 1000.0;
//     double d2 = distanceCalc.as(LengthUnit.Meter, p1, p2) / 1000.0;
//     double d3 = distanceCalc.as(LengthUnit.Meter, p2, p3) / 1000.0;

//     double sumD = d1 + d2 + d3;
//     if (sumD > 0) {
//       d1 = (d1 / sumD) * totalDistanceKm;
//       d2 = (d2 / sumD) * totalDistanceKm;
//       d3 = (d3 / sumD) * totalDistanceKm;
//     } else {
//       d1 = d2 = d3 = totalDistanceKm / 3.0;
//     }

//     try {
//       String elLat = '${p0.latitude},${p1.latitude},${p2.latitude},${p3.latitude}';
//       String elLon = '${p0.longitude},${p1.longitude},${p2.longitude},${p3.longitude}';
//       final elUri = Uri.parse(
//         'https://api.open-meteo.com/v1/elevation?latitude=$elLat&longitude=$elLon',
//       );

//       String wLat = '${p1.latitude},${p2.latitude},${p3.latitude}';
//       String wLon = '${p1.longitude},${p2.longitude},${p3.longitude}';
//       final wUri = Uri.parse(
//         'https://api.open-meteo.com/v1/forecast?latitude=$wLat&longitude=$wLon&current=temperature_2m,precipitation',
//       );

//       final responses = await Future.wait([
//         http.get(elUri).timeout(const Duration(seconds: 15)),
//         http.get(wUri).timeout(const Duration(seconds: 15)),
//       ]);

//       List<double> elevs = [0, 0, 0, 0];
//       if (responses[0].statusCode == 200) {
//         final data = jsonDecode(responses[0].body);
//         if (data['elevation'] is List) {
//           final elList = data['elevation'] as List;
//           for (int i = 0; i < 4 && i < elList.length; i++) {
//             elevs[i] = _number(elList[i]);
//           }
//         }
//       }
//       double eChange1 = elevs[1] - elevs[0];
//       double eChange2 = elevs[2] - elevs[1];
//       double eChange3 = elevs[3] - elevs[2];

//       List<double> temps = [30.0, 30.0, 30.0];
//       List<double> rains = [0.0, 0.0, 0.0];
//       if (responses[1].statusCode == 200) {
//         final wData = jsonDecode(responses[1].body);
//         if (wData is List) {
//           for (int i = 0; i < 3 && i < wData.length; i++) {
//             final current = wData[i]['current'] ?? {};
//             temps[i] = _number(current['temperature_2m'], 30.0);
//             rains[i] = _number(current['precipitation'], 0.0);
//           }
//         } else if (wData is Map) {
//           final current = wData['current'] ?? {};
//           temps[0] = temps[1] = temps[2] =
//               _number(current['temperature_2m'], 30.0);
//           rains[0] = rains[1] = rains[2] =
//               _number(current['precipitation'], 0.0);
//         }
//       }

//       double totalAdjustedEnergy = 0.0;
//       final segments = [
//         {'dist': d1, 'elev': eChange1, 'temp': temps[0], 'rain': rains[0]},
//         {'dist': d2, 'elev': eChange2, 'temp': temps[1], 'rain': rains[1]},
//         {'dist': d3, 'elev': eChange3, 'temp': temps[2], 'rain': rains[2]},
//       ];

//       for (var seg in segments) {
//         double segBaseEnergy =
//             (seg['dist']! / 100.0) * _baseConsumptionKwh100km;

//         double terrainMult = 1.0;
//         if (seg['elev']! > 100) {
//           terrainMult += 0.12;
//         } else if (seg['elev']! > 40) {
//           terrainMult += 0.06;
//         } else if (seg['elev']! < -80) {
//           terrainMult -= 0.04;
//         }

//         double weatherMult = 1.0;
//         if (seg['temp']! > 32) {
//           weatherMult += 0.12;
//         } else if (seg['temp']! < 15) {
//           weatherMult += 0.18;
//         }
//         if (seg['rain']! > 0) weatherMult += 0.05;

//         totalAdjustedEnergy +=
//             (segBaseEnergy * weatherMult * terrainMult);
//       }

//       double avgTemp = (temps[0] + temps[1] + temps[2]) / 3;
//       double totalElevationChange = eChange1 + eChange2 + eChange3;
//       bool isRainy = rains.any((r) => r > 0);

//       String weatherDesc = 'Avg Temp: ${avgTemp.toStringAsFixed(1)}°C';
//       if (isRainy) weatherDesc += ' · Rain detected';

//       return {
//         'adjustedEnergy': totalAdjustedEnergy,
//         'avgTemp': avgTemp,
//         'totalElevationChange': totalElevationChange,
//         'weatherDesc': weatherDesc,
//       };
//     } catch (_) {
//       return {
//         'adjustedEnergy': baseEnergyTotal,
//         'avgTemp': 30.0,
//         'totalElevationChange': 0.0,
//         'weatherDesc': 'API error - baseline used',
//       };
//     }
//   }

//   // ------------------------------------------------------------
//   // BACKEND ROUTE REQUEST
//   // ------------------------------------------------------------

//   Future<void> _calculateRoutes() async {
//     final from = _sourceSearchCtrl.text.trim();
//     final to = _destinationSearchCtrl.text.trim();

//     if (from.isEmpty || to.isEmpty) {
//       _showMessage('Enter both source and destination.');
//       return;
//     }

//     FocusScope.of(context).unfocus();

//     setState(() {
//       _isCalculating = true;
//       _error = null;
//       _routes = [];
//       _selectedRouteIndex = 0;
//     });

//     try {
//       final response = await http
//           .post(
//             Uri.parse('$apiBase/routes'),
//             headers: {
//               'Content-Type': 'application/json',
//               'Accept': 'application/json',
//             },
//             body: jsonEncode({
//               'source': {'name': from},
//               'destination': {'name': to},
//               'alternatives': 3,
//               'consumption_kwh_per_100km': _baseConsumptionKwh100km,
//             }),
//           )
//           .timeout(const Duration(seconds: 60));

//       if (response.statusCode != 200) {
//         throw Exception(
//           'Backend returned ${response.statusCode}: ${response.body}',
//         );
//       }

//       final data = jsonDecode(response.body) as Map<String, dynamic>;
//       final rawRoutes = data['routes'] as List? ?? [];

//       if (rawRoutes.isEmpty) {
//         throw Exception('No routes returned. Try different locations.');
//       }

//       final routeFutures = <Future<RouteModel>>[];

//       for (int i = 0; i < rawRoutes.length && i < 3; i++) {
//         final route = Map<String, dynamic>.from(rawRoutes[i] as Map);
//         final geometry = route['geometry'];
//         if (geometry is! Map) continue;

//         final coordinates = geometry['coordinates'];
//         if (coordinates is! List) continue;

//         final points = coordinates
//             .whereType<List>()
//             .where((c) => c.length >= 2)
//             .map((c) => LatLng(
//                   _number(c[1], double.nan),
//                   _number(c[0], double.nan),
//                 ))
//             .where((p) =>
//                 p.latitude.isFinite &&
//                 p.longitude.isFinite &&
//                 p.latitude >= -90 &&
//                 p.latitude <= 90 &&
//                 p.longitude >= -180 &&
//                 p.longitude <= 180)
//             .toList();

//         if (points.length < 2) continue;

//         final distanceKm = _number(route['distance_km']);
//         final durationMin = _number(route['duration_minutes']);

//         routeFutures.add(() async {
//           final impact = await _processRouteImpact(points, distanceKm);

//           return RouteModel(
//             index: i,
//             name: i == 0
//                 ? 'Fastest Route'
//                 : (i == 1 ? 'Alternative 1' : 'Alternative 2'),
//             distanceKm: distanceKm,
//             durationMin: durationMin,
//             points: points,
//             baseEnergyKwh:
//                 distanceKm / 100.0 * _baseConsumptionKwh100km,
//             adjustedEnergyKwh: impact['adjustedEnergy'],
//             tempC: impact['avgTemp'],
//             elevationChangeM: impact['totalElevationChange'],
//             weatherCondition: impact['weatherDesc'],
//             weatherMultiplier: 1.0,
//             terrainMultiplier: 1.0,
//           );
//         }());
//       }

//       final parsedRoutes = await Future.wait(routeFutures);
//       if (parsedRoutes.isEmpty) {
//         throw Exception('The backend returned no valid route geometry.');
//       }

//       // Rank routes by lowest battery consumption
//       parsedRoutes.sort(
//         (a, b) => a.adjustedEnergyKwh.compareTo(b.adjustedEnergyKwh),
//       );

//       if (!mounted) return;

//       setState(() {
//         _routes = parsedRoutes;
//         _selectedRouteIndex = 0;
//         _error = null;
//       });

//       _syncToSession();

//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         if (!mounted || _routes.isEmpty) return;
//         final allPoints = <LatLng>[
//           for (final route in _routes) ...route.points
//         ];
//         if (allPoints.isEmpty) return;

//         try {
//           _mapController.fitCamera(
//             CameraFit.bounds(
//               bounds: LatLngBounds.fromPoints(allPoints),
//               padding: const EdgeInsets.all(40),
//             ),
//           );
//         } catch (_) {}
//       });
//     } catch (e) {
//       if (mounted) {
//         setState(() {
//           _error = e.toString().replaceFirst('Exception: ', '');
//         });
//       }
//     } finally {
//       if (mounted) setState(() => _isCalculating = false);
//     }
//   }

//   // ------------------------------------------------------------
//   // UI HELPERS
//   // ------------------------------------------------------------

//   Widget _sectionTitle(String text) {
//     return Text(
//       text,
//       style: const TextStyle(
//         color: Color(0xFF78829D),
//         fontSize: 11,
//         fontWeight: FontWeight.bold,
//         letterSpacing: 1.1,
//       ),
//     );
//   }

//   Widget _buildLocationPanel() {
//     return Container(
//       padding: const EdgeInsets.all(14),
//       decoration: BoxDecoration(
//         color: panel,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: Colors.white.withOpacity(0.05)),
//       ),
//       child: Column(
//         children: [
//           Row(
//             children: [
//               const Icon(Icons.circle, color: green, size: 11),
//               const SizedBox(width: 10),
//               Expanded(
//                 child: TextField(
//                   controller: _sourceSearchCtrl,
//                   style: const TextStyle(color: Colors.white, fontSize: 13),
//                   decoration: const InputDecoration(
//                     hintText: 'Source city or address',
//                     hintStyle: TextStyle(color: muted, fontSize: 12),
//                     border: InputBorder.none,
//                     isDense: true,
//                   ),
//                   onSubmitted: (_) => _searchLocation(source: true),
//                 ),
//               ),
//               IconButton(
//                 tooltip: 'Search source',
//                 onPressed: () => _searchLocation(source: true),
//                 icon: const Icon(Icons.search, color: green, size: 20),
//               ),
//               IconButton(
//                 tooltip: 'Use current GPS location',
//                 onPressed: _isFetchingGps ? null : _useCurrentGpsLocation,
//                 icon: _isFetchingGps
//                     ? const SizedBox(
//                         width: 18,
//                         height: 18,
//                         child: CircularProgressIndicator(
//                           strokeWidth: 2,
//                           color: green,
//                         ),
//                       )
//                     : const Icon(Icons.gps_fixed, color: green, size: 20),
//               ),
//               _pinButton(PinMode.source),
//             ],
//           ),
//           const Divider(color: Colors.white12, height: 12),
//           Row(
//             children: [
//               const Icon(Icons.location_on, color: Colors.redAccent, size: 15),
//               const SizedBox(width: 8),
//               Expanded(
//                 child: TextField(
//                   controller: _destinationSearchCtrl,
//                   style: const TextStyle(color: Colors.white, fontSize: 13),
//                   decoration: const InputDecoration(
//                     hintText: 'Destination city or address',
//                     hintStyle: TextStyle(color: muted, fontSize: 12),
//                     border: InputBorder.none,
//                     isDense: true,
//                   ),
//                   onSubmitted: (_) => _searchLocation(source: false),
//                 ),
//               ),
//               IconButton(
//                 tooltip: 'Search destination',
//                 onPressed: () => _searchLocation(source: false),
//                 icon: const Icon(Icons.search, color: green, size: 20),
//               ),
//               _pinButton(PinMode.destination),
//             ],
//           ),
//           if (_currentPinMode != PinMode.none) ...[
//             const Divider(color: Colors.white12),
//             Row(
//               children: [
//                 const Icon(Icons.touch_app, color: green, size: 18),
//                 const SizedBox(width: 8),
//                 Expanded(
//                   child: Text(
//                     _currentPinMode == PinMode.source
//                         ? 'Tap the map to pin your source'
//                         : 'Tap the map to pin your destination',
//                     style: const TextStyle(color: green, fontSize: 12),
//                   ),
//                 ),
//                 IconButton(
//                   onPressed: () =>
//                       setState(() => _currentPinMode = PinMode.none),
//                   icon: const Icon(Icons.close, size: 18),
//                   color: Colors.white70,
//                 ),
//               ],
//             ),
//           ],
//         ],
//       ),
//     );
//   }

//   Widget _pinButton(PinMode mode) {
//     final active = _currentPinMode == mode;
//     return OutlinedButton(
//       onPressed: () {
//         setState(() => _currentPinMode = active ? PinMode.none : mode);
//       },
//       style: OutlinedButton.styleFrom(
//         padding: const EdgeInsets.symmetric(horizontal: 8),
//         minimumSize: const Size(42, 34),
//         side: BorderSide(color: active ? green : Colors.white24),
//         backgroundColor:
//             active ? green.withOpacity(0.12) : Colors.transparent,
//       ),
//       child: const Icon(Icons.add_location_alt, size: 16, color: Colors.white),
//     );
//   }

//   Widget _buildBatteryPanel(double availableEnergy) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
//       decoration: BoxDecoration(
//         color: panel,
//         borderRadius: BorderRadius.circular(16),
//       ),
//       child: Column(
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               const Text(
//                 'Vehicle Battery Charge',
//                 style: TextStyle(color: muted, fontSize: 12),
//               ),
//               Text(
//                 '${_currentBatteryPercent.round()}% (${availableEnergy.toStringAsFixed(1)} kWh)',
//                 style: const TextStyle(
//                   color: green,
//                   fontSize: 13,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ],
//           ),
//           Slider(
//             value: _currentBatteryPercent,
//             min: 5,
//             max: 100,
//             activeColor: green,
//             inactiveColor: const Color(0xFF202B40),
//             onChanged: (value) {
//               setState(() => _currentBatteryPercent = value);
//               RoutePlanningSession.currentBatteryPercent = value;
//             },
//           ),
//           Align(
//             alignment: Alignment.centerLeft,
//             child: Text(
//               'Battery capacity: ${_batteryCapacityKwh.toStringAsFixed(1)} kWh ($_vehicleName)',
//               style: const TextStyle(color: muted, fontSize: 10),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildEnvironmentalCard(RouteModel route) {
//     final overallImpactPercent =
//         ((route.adjustedEnergyKwh / route.baseEnergyKwh) - 1.0) * 100;

//     return Container(
//       padding: const EdgeInsets.all(14),
//       decoration: BoxDecoration(
//         color: const Color(0xFF121A2F),
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: Colors.blueAccent.withOpacity(0.2)),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Row(
//             children: [
//               Icon(Icons.cloud_sync, color: Colors.lightBlueAccent, size: 17),
//               SizedBox(width: 8),
//               Expanded(
//                 child: Text(
//                   '3-SEGMENT ENVIRONMENTAL IMPACT',
//                   style: TextStyle(
//                     color: Colors.lightBlueAccent,
//                     fontSize: 10,
//                     fontWeight: FontWeight.bold,
//                     letterSpacing: 1,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 12),
//           Row(
//             children: [
//               Expanded(
//                 child: _infoValue(
//                   'Temperature',
//                   '${route.tempC.toStringAsFixed(1)}°C',
//                   Icons.thermostat,
//                 ),
//               ),
//               Expanded(
//                 child: _infoValue(
//                   'Elevation change',
//                   '${route.elevationChangeM >= 0 ? '+' : ''}${route.elevationChangeM.toStringAsFixed(0)} m',
//                   Icons.terrain,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 10),
//           Text(route.weatherCondition,
//               style: const TextStyle(color: muted, fontSize: 11)),
//           const Divider(color: Colors.white10, height: 22),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               const Expanded(
//                 child: Text(
//                   'Estimated energy required',
//                   style: TextStyle(color: muted, fontSize: 11),
//                 ),
//               ),
//               Text(
//                 '${route.adjustedEnergyKwh.toStringAsFixed(2)} kWh',
//                 style: const TextStyle(
//                   color: green,
//                   fontSize: 13,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 5),
//           Text(
//             'Baseline ${route.baseEnergyKwh.toStringAsFixed(2)} kWh · Environmental adjustment ${overallImpactPercent >= 0 ? '+' : ''}${overallImpactPercent.toStringAsFixed(1)}%',
//             style: const TextStyle(color: muted, fontSize: 10),
//           ),
//           const SizedBox(height: 14),

//           // Save Route Plan to Firebase Button
//           SizedBox(
//             width: double.infinity,
//             height: 44,
//             child: ElevatedButton.icon(
//               onPressed: _isSavingRoute ? null : () => _saveRoutePlan(route),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: green,
//                 foregroundColor: bg,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//               ),
//               icon: _isSavingRoute
//                   ? const SizedBox(
//                       width: 16,
//                       height: 16,
//                       child: CircularProgressIndicator(
//                         strokeWidth: 2,
//                         color: bg,
//                       ),
//                     )
//                   : const Icon(Icons.bookmark_add_outlined, size: 18),
//               label: Text(
//                 _isSavingRoute ? 'Saving...' : 'Save Selected Route Plan',
//                 style: const TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 12,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _infoValue(String label, String value, IconData icon) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Icon(icon, color: muted, size: 18),
//         const SizedBox(width: 7),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(label, style: const TextStyle(color: muted, fontSize: 10)),
//               const SizedBox(height: 4),
//               Text(
//                 value,
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontSize: 12,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildRouteCard({
//     required RouteModel route,
//     required bool selected,
//     required bool enoughBattery,
//     required VoidCallback onTap,
//   }) {
//     final hours = route.durationMin.floor() ~/ 60;
//     final minutes = route.durationMin.floor() % 60;

//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         margin: const EdgeInsets.only(bottom: 10),
//         padding: const EdgeInsets.all(14),
//         decoration: BoxDecoration(
//           color: selected ? const Color(0xFF0F1B2E) : panel,
//           borderRadius: BorderRadius.circular(15),
//           border: Border.all(
//             color: selected ? green : Colors.white12,
//             width: selected ? 1.5 : 1,
//           ),
//         ),
//         child: Column(
//           children: [
//             Row(
//               children: [
//                 Container(
//                   width: 9,
//                   height: 30,
//                   decoration: BoxDecoration(
//                     color: _routeColors[route.index % _routeColors.length],
//                     borderRadius: BorderRadius.circular(6),
//                   ),
//                 ),
//                 const SizedBox(width: 10),
//                 Expanded(
//                   child: Text(
//                     route.name,
//                     style: TextStyle(
//                       color: selected ? green : Colors.white,
//                       fontWeight: FontWeight.bold,
//                       fontSize: 14,
//                     ),
//                   ),
//                 ),
//                 Text(
//                   '${route.distanceKm.toStringAsFixed(1)} km',
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold,
//                     fontSize: 13,
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 12),
//             Row(
//               children: [
//                 const Icon(Icons.access_time, size: 15, color: muted),
//                 const SizedBox(width: 5),
//                 Text(
//                   hours > 0 ? '${hours}h ${minutes}m' : '${minutes}m',
//                   style: const TextStyle(color: muted, fontSize: 11),
//                 ),
//                 const SizedBox(width: 14),
//                 const Icon(Icons.bolt, color: Colors.amber, size: 16),
//                 const SizedBox(width: 4),
//                 Expanded(
//                   child: Text(
//                     '${route.adjustedEnergyKwh.toStringAsFixed(2)} kWh',
//                     style: const TextStyle(color: Colors.white70, fontSize: 11),
//                   ),
//                 ),
//                 if (selected)
//                   const Icon(Icons.check_circle, color: green, size: 19),
//               ],
//             ),
//             const SizedBox(height: 10),
//             Row(
//               children: [
//                 Icon(
//                   enoughBattery
//                       ? Icons.check_circle_outline
//                       : Icons.battery_alert,
//                   color: enoughBattery ? green : Colors.orangeAccent,
//                   size: 15,
//                 ),
//                 const SizedBox(width: 5),
//                 Text(
//                   enoughBattery
//                       ? 'Estimated battery is sufficient'
//                       : 'Charging may be required',
//                   style: TextStyle(
//                     color: enoughBattery ? green : Colors.orangeAccent,
//                     fontSize: 10,
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // ------------------------------------------------------------
//   // MAIN SCREEN
//   // ------------------------------------------------------------

//   @override
//   Widget build(BuildContext context) {
//     final availableEnergy =
//         _batteryCapacityKwh * _currentBatteryPercent / 100;
//     final activeRoute =
//         _routes.isNotEmpty ? _routes[_selectedRouteIndex] : null;

//     return Scaffold(
//       backgroundColor: bg,
//       body: SafeArea(
//         child: Column(
//           children: [
//             // MAP
//             Expanded(
//               flex: 5,
//               child: Stack(
//                 children: [
//                   FlutterMap(
//                     mapController: _mapController,
//                     options: MapOptions(
//                       initialCenter: RoutePlanningSession.mapCenter ??
//                           const LatLng(11.0018, 76.9628),
//                       initialZoom: RoutePlanningSession.mapZoom,
//                       onTap: _onMapTap,
//                       onPositionChanged: (pos, hasGesture) {
//                         if (pos.center != null) {
//                           RoutePlanningSession.mapCenter = pos.center;
//                           RoutePlanningSession.mapZoom = pos.zoom;
//                         }
//                       },
//                     ),
//                     children: [
//                       TileLayer(
//                         urlTemplate:
//                             'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
//                         userAgentPackageName:
//                             'com.example.ev_route_optimizer',
//                       ),
//                       PolylineLayer(
//                         polylines: [
//                           for (int i = 0; i < _routes.length; i++)
//                             if (_routes[i].points.length >= 2)
//                               Polyline(
//                                 points: _routes[i].points,
//                                 color: _routeColors[
//                                         _routes[i].index % _routeColors.length]
//                                     .withOpacity(
//                                         i == _selectedRouteIndex ? 1 : 0.55),
//                                 strokeWidth:
//                                     i == _selectedRouteIndex ? 5.5 : 4,
//                               ),
//                         ],
//                       ),
//                       MarkerLayer(
//                         markers: [
//                           if (_sourcePos != null)
//                             Marker(
//                               point: _sourcePos!,
//                               width: 40,
//                               height: 40,
//                               child: const Icon(
//                                 Icons.trip_origin,
//                                 color: green,
//                                 size: 30,
//                               ),
//                             ),
//                           if (_destPos != null)
//                             Marker(
//                               point: _destPos!,
//                               width: 42,
//                               height: 42,
//                               child: const Icon(
//                                 Icons.location_on,
//                                 color: Colors.redAccent,
//                                 size: 36,
//                               ),
//                             ),
//                         ],
//                       ),
//                       const RichAttributionWidget(
//                         attributions: [
//                           TextSourceAttribution(
//                             '© OpenStreetMap contributors',
//                           )
//                         ],
//                       ),
//                     ],
//                   ),
//                   Positioned(
//                     top: 12,
//                     left: 14,
//                     right: 14,
//                     child: Container(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 14,
//                         vertical: 11,
//                       ),
//                       decoration: BoxDecoration(
//                         color: bg.withOpacity(0.92),
//                         borderRadius: BorderRadius.circular(13),
//                         border: Border.all(color: green.withOpacity(0.35)),
//                       ),
//                       child: Row(
//                         children: [
//                           const Icon(Icons.electric_car, color: green, size: 22),
//                           const SizedBox(width: 10),
//                           const Expanded(
//                             child: Text(
//                               'BATTERY-EFFICIENT ROUTES',
//                               style: TextStyle(
//                                 color: Colors.white,
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 11,
//                                 letterSpacing: 1,
//                               ),
//                             ),
//                           ),
//                           if (_routes.isNotEmpty)
//                             Text(
//                               '${_routes.length} routes',
//                               style: const TextStyle(
//                                 color: green,
//                                 fontSize: 11,
//                               ),
//                             ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   if (_currentPinMode != PinMode.none)
//                     Positioned(
//                       bottom: 12,
//                       left: 12,
//                       right: 12,
//                       child: Container(
//                         padding: const EdgeInsets.all(12),
//                         decoration: BoxDecoration(
//                           color: bg.withOpacity(0.95),
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         child: Text(
//                           _currentPinMode == PinMode.source
//                               ? 'Tap the map to set the source'
//                               : 'Tap the map to set the destination',
//                           textAlign: TextAlign.center,
//                           style: const TextStyle(
//                             color: green,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                     ),
//                 ],
//               ),
//             ),

//             // CONTROLS AND ROUTE RESULTS
//             Expanded(
//               flex: 6,
//               child: Container(
//                 decoration: const BoxDecoration(
//                   color: bg,
//                   borderRadius:
//                       BorderRadius.vertical(top: Radius.circular(20)),
//                 ),
//                 child: ListView(
//                   padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
//                   children: [
//                     _buildLocationPanel(),
//                     const SizedBox(height: 12),
//                     _buildBatteryPanel(availableEnergy),
//                     const SizedBox(height: 12),

//                     SizedBox(
//                       height: 49,
//                       child: ElevatedButton.icon(
//                         onPressed: _isCalculating ? null : _calculateRoutes,
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: green,
//                           foregroundColor: bg,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(13),
//                           ),
//                         ),
//                         icon: _isCalculating
//                             ? const SizedBox(
//                                 width: 18,
//                                 height: 18,
//                                 child: CircularProgressIndicator(
//                                   color: bg,
//                                   strokeWidth: 2,
//                                 ),
//                               )
//                             : const Icon(Icons.alt_route),
//                         label: Text(
//                           _isCalculating
//                               ? 'Analyzing routes & segments...'
//                               : 'Analyze Alternative Routes',
//                           style: const TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 13,
//                           ),
//                         ),
//                       ),
//                     ),

//                     if (_error != null) ...[
//                       const SizedBox(height: 12),
//                       Container(
//                         padding: const EdgeInsets.all(12),
//                         decoration: BoxDecoration(
//                           color: Colors.red.withOpacity(0.10),
//                           borderRadius: BorderRadius.circular(12),
//                           border: Border.all(
//                             color: Colors.redAccent.withOpacity(0.4),
//                           ),
//                         ),
//                         child: Text(
//                           _error!,
//                           style: const TextStyle(
//                             color: Colors.redAccent,
//                             fontSize: 12,
//                           ),
//                         ),
//                       ),
//                     ],

//                     if (activeRoute != null) ...[
//                       const SizedBox(height: 18),
//                       _buildEnvironmentalCard(activeRoute),
//                       const SizedBox(height: 18),
//                       _sectionTitle('AVAILABLE ROUTES'),
//                       const SizedBox(height: 10),
//                       for (int i = 0; i < _routes.length; i++)
//                         _buildRouteCard(
//                           route: _routes[i],
//                           selected: i == _selectedRouteIndex,
//                           enoughBattery: availableEnergy >=
//                               _routes[i].adjustedEnergyKwh,
//                           onTap: () {
//                             setState(() => _selectedRouteIndex = i);
//                             RoutePlanningSession.selectedRouteIndex = i;
//                             final points = _routes[i].points;
//                             if (points.isNotEmpty) {
//                               _mapController.move(
//                                 points[points.length ~/ 2],
//                                 9,
//                               );
//                             }
//                           },
//                         ),
//                     ] else if (!_isCalculating && _error == null) ...[
//                       const SizedBox(height: 20),
//                       const Icon(Icons.route, color: muted, size: 34),
//                       const SizedBox(height: 8),
//                       const Center(
//                         child: Text(
//                           'Enter your journey and analyze routes',
//                           textAlign: TextAlign.center,
//                           style: TextStyle(color: muted, fontSize: 12),
//                         ),
//                       ),
//                     ],
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//       bottomNavigationBar: Container(
//         decoration: const BoxDecoration(
//           color: Color(0xFF0A0F1D),
//           border: Border(top: BorderSide(color: Colors.white10)),
//         ),
//         child: BottomNavigationBar(
//           currentIndex: _selectedIndex,
//           onTap: _onBottomNavTapped,
//           backgroundColor: const Color(0xFF0A0F1D),
//           type: BottomNavigationBarType.fixed,
//           selectedItemColor: green,
//           unselectedItemColor: const Color(0xFF535D75),
//           selectedFontSize: 11,
//           unselectedFontSize: 11,
//           items: const [
//             BottomNavigationBarItem(
//               icon: Icon(Icons.home_outlined),
//               activeIcon: Icon(Icons.home),
//               label: 'Home',
//             ),
//             BottomNavigationBarItem(
//               icon: Icon(Icons.alt_route),
//               label: 'Routes',
//             ),
//             BottomNavigationBarItem(
//               icon: Icon(Icons.bolt),
//               label: 'Charging',
//             ),
//             BottomNavigationBarItem(
//               icon: Icon(Icons.assignment_outlined),
//               activeIcon: Icon(Icons.assignment),
//               label: 'Trips',
//             ),
//             BottomNavigationBarItem(
//               icon: Icon(Icons.person_outline),
//               activeIcon: Icon(Icons.person),
//               label: 'Profile',
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


// import 'dart:convert';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:http/http.dart' as http;
// import 'package:latlong2/latlong.dart';

// enum PinMode { none, source, destination }

// class RouteModel {
//   final int index;
//   final String name;
//   final double distanceKm;
//   final double durationMin;
//   final List<LatLng> points;
//   final double baseEnergyKwh;
//   final double adjustedEnergyKwh;
//   final double tempC;
//   final double elevationChangeM;
//   final String weatherCondition;
//   final double weatherMultiplier;
//   final double terrainMultiplier;

//   const RouteModel({
//     required this.index,
//     required this.name,
//     required this.distanceKm,
//     required this.durationMin,
//     required this.points,
//     required this.baseEnergyKwh,
//     required this.adjustedEnergyKwh,
//     required this.tempC,
//     required this.elevationChangeM,
//     required this.weatherCondition,
//     required this.weatherMultiplier,
//     required this.terrainMultiplier,
//   });
// }

// // ================= PERSISTENT APP SESSION CACHE =================
// class RoutePlanningSession {
//   static LatLng? sourcePos;
//   static LatLng? destPos;
//   static String sourceText = 'Coimbatore';
//   static String destText = 'Chennai';
//   static String sourceLabel = 'Coimbatore';
//   static String destLabel = 'Chennai';
//   static List<RouteModel> cachedRoutes = [];
//   static int selectedRouteIndex = 0;
//   static double currentBatteryPercent = 75.0;
//   static LatLng? mapCenter;
//   static double mapZoom = 6.0;
// }

// class RoutePlanningScreen extends StatefulWidget {
//   const RoutePlanningScreen({super.key});

//   @override
//   State<RoutePlanningScreen> createState() => _RoutePlanningScreenState();
// }

// class _RoutePlanningScreenState extends State<RoutePlanningScreen> {
//   static const String apiBase = 'http://192.168.137.1:8000';

//   static const Color bg = Color(0xFF070B16);
//   static const Color panel = Color(0xFF0E1526);
//   static const Color green = Color(0xFF1ECB6B);
//   static const Color muted = Color(0xFF78829D);

//   final int _selectedIndex = 1;
//   final MapController _mapController = MapController();

//   late final TextEditingController _sourceSearchCtrl;
//   late final TextEditingController _destinationSearchCtrl;

//   PinMode _currentPinMode = PinMode.none;

//   LatLng? _sourcePos;
//   LatLng? _destPos;

//   String _sourceLabel = 'Coimbatore';
//   String _destLabel = 'Chennai';

//   bool _isFetchingGps = false;
//   bool _isCalculating = false;
//   bool _isSavingRoute = false;
//   bool _handledArgs = false;

//   String? _error;

//   List<RouteModel> _routes = [];
//   int _selectedRouteIndex = 0;

//   double _currentBatteryPercent = 75.0;
//   double _batteryCapacityKwh = 75.0;
//   double _baseConsumptionKwh100km = 15.5;
//   String _vehicleName = 'Your EV';

//   final List<Color> _routeColors = const [
//     Color(0xFF1ECB6B),
//     Color(0xFF42B7FF),
//     Color(0xFFFFB74D),
//     Color(0xFFE879F9),
//     Color(0xFFFF6B6B),
//   ];

//   @override
//   void initState() {
//     super.initState();
//     // 1. Restore state from previous visits in this app session
//     _sourcePos = RoutePlanningSession.sourcePos;
//     _destPos = RoutePlanningSession.destPos;
//     _sourceLabel = RoutePlanningSession.sourceLabel;
//     _destLabel = RoutePlanningSession.destLabel;
//     _routes = List.from(RoutePlanningSession.cachedRoutes);
//     _selectedRouteIndex = RoutePlanningSession.selectedRouteIndex;
//     _currentBatteryPercent = RoutePlanningSession.currentBatteryPercent;

//     _sourceSearchCtrl = TextEditingController(text: RoutePlanningSession.sourceText);
//     _destinationSearchCtrl = TextEditingController(text: RoutePlanningSession.destText);

//     _fetchUserVehicleSpecs();

//     // 2. Reposition camera if locations or routes were previously planned
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (!mounted) return;
//       if (_routes.isNotEmpty) {
//         final allPoints = <LatLng>[
//           for (final route in _routes) ...route.points
//         ];
//         if (allPoints.isNotEmpty) {
//           try {
//             _mapController.fitCamera(CameraFit.bounds(bounds: LatLngBounds.fromPoints(allPoints), padding: const EdgeInsets.all(40)));
//           } catch (_) {}
//         }
//       } else if (RoutePlanningSession.mapCenter != null) {
//         _mapController.move(RoutePlanningSession.mapCenter!, RoutePlanningSession.mapZoom);
//       }
//     });
//   }

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
    
//     // Intercept Auto-Calculate instructions from ChargingStationsScreen
//     if (!_handledArgs) {
//       final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
//       if (args != null && args['autoCalculate'] == true) {
//         _handledArgs = true;

//         final sPos = args['sourcePos'] as LatLng?;
//         final dPos = args['destPos'] as LatLng?;
//         final dName = args['destName'] as String?;

//         if (sPos != null && dPos != null) {
//           // Send exact coordinates to the backend instead of names for precision
//           final sCoord = '${sPos.latitude}, ${sPos.longitude}';
//           final dCoord = '${dPos.latitude}, ${dPos.longitude}';

//           setState(() {
//             _sourcePos = sPos;
//             _destPos = dPos;
            
//             _sourceSearchCtrl.text = sCoord;
//             _destinationSearchCtrl.text = dCoord;

//             // Override memory session immediately
//             RoutePlanningSession.sourcePos = sPos;
//             RoutePlanningSession.destPos = dPos;
//             RoutePlanningSession.sourceText = sCoord;
//             RoutePlanningSession.destText = dCoord;
//             RoutePlanningSession.sourceLabel = 'Current Location';
//             RoutePlanningSession.destLabel = dName ?? 'Charging Station';
//           });

//           // Wait a split second for UI to update, then auto calculate
//           WidgetsBinding.instance.addPostFrameCallback((_) {
//             _calculateRoutes(
//               overrideSourceLabel: 'Current Location', 
//               overrideDestLabel: dName
//             );
//           });
//         }
//       }
//     }
//   }

//   @override
//   void dispose() {
//     RoutePlanningSession.sourceText = _sourceSearchCtrl.text;
//     RoutePlanningSession.destText = _destinationSearchCtrl.text;
//     _sourceSearchCtrl.dispose();
//     _destinationSearchCtrl.dispose();
//     super.dispose();
//   }

//   void _syncToSession() {
//     RoutePlanningSession.sourcePos = _sourcePos;
//     RoutePlanningSession.destPos = _destPos;
//     RoutePlanningSession.sourceLabel = _sourceLabel;
//     RoutePlanningSession.destLabel = _destLabel;
//     RoutePlanningSession.sourceText = _sourceSearchCtrl.text;
//     RoutePlanningSession.destText = _destinationSearchCtrl.text;
//     RoutePlanningSession.cachedRoutes = _routes;
//     RoutePlanningSession.selectedRouteIndex = _selectedRouteIndex;
//     RoutePlanningSession.currentBatteryPercent = _currentBatteryPercent;
//   }

//   Future<void> _fetchUserVehicleSpecs() async {
//     final user = FirebaseAuth.instance.currentUser;
//     if (user == null) return;
//     try {
//       final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
//       if (doc.exists && doc.data() != null) {
//         final data = doc.data()!;
//         if (!mounted) return;
//         setState(() {
//           _batteryCapacityKwh = (data['batteryCapacityKwh'] ?? 75.0).toDouble();
//           _baseConsumptionKwh100km = (data['avgConsumption'] ?? 15.5).toDouble();
//           final brand = data['vehicleBrand'] ?? '';
//           final model = data['vehicleModel'] ?? '';
//           if (brand.isNotEmpty || model.isNotEmpty) _vehicleName = '$brand $model'.trim();
//         });
//       }
//     } catch (_) {}
//   }

//   Future<void> _saveRoutePlan(RouteModel route) async {
//     final user = FirebaseAuth.instance.currentUser;
//     if (user == null) {
//       _showMessage('Please login to save this route plan.');
//       return;
//     }

//     setState(() => _isSavingRoute = true);

//     try {
//       final tripData = {
//         'userId': user.uid,
//         'source': _sourceLabel,
//         'destination': _destLabel,
//         'distanceKm': double.parse(route.distanceKm.toStringAsFixed(2)),
//         'kwhNeeded': double.parse(route.adjustedEnergyKwh.toStringAsFixed(2)),
//         'durationMinutes': double.parse(route.durationMin.toStringAsFixed(1)),
//         'dateTime': DateTime.now().toIso8601String(),
//         'createdAt': FieldValue.serverTimestamp(),
//       };

//       await FirebaseFirestore.instance.collection('users').doc(user.uid).collection('trips').add(tripData);
//       _showMessage('Route saved to Trip History!');
//     } catch (e) {
//       _showMessage('Failed to save route: $e');
//     } finally {
//       if (mounted) setState(() => _isSavingRoute = false);
//     }
//   }

//   double _number(dynamic value, [double fallback = 0]) {
//     if (value is num) return value.toDouble();
//     return double.tryParse('$value') ?? fallback;
//   }

//   void _showMessage(String message) {
//     if (!mounted) return;
//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), backgroundColor: const Color(0xFF202A3D)));
//   }

//   void _onBottomNavTapped(int index) {
//     if (index == _selectedIndex) return;
//     _syncToSession();

//     final routes = <int, String>{
//       0: '/dashboard',
//       2: '/charging',
//       3: '/trips',
//       4: '/profile',
//     };
//     final routeName = routes[index];
//     if (routeName != null) Navigator.pushReplacementNamed(context, routeName);
//   }

//   Future<void> _useCurrentGpsLocation() async {
//     setState(() { _isFetchingGps = true; _error = null; });
//     try {
//       if (!await Geolocator.isLocationServiceEnabled()) throw Exception('Enable location services on your phone.');
//       var permission = await Geolocator.checkPermission();
//       if (permission == LocationPermission.denied) permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.deniedForever) throw Exception('Enable location permission in your phone settings.');

//       final position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
//       final point = LatLng(position.latitude, position.longitude);
      
//       if (!mounted) return;
//       setState(() {
//         _sourcePos = point;
//         _sourceLabel = 'Current GPS Location';
//         _sourceSearchCtrl.text = '${point.latitude}, ${point.longitude}';
//         _currentPinMode = PinMode.none;
//       });

//       _syncToSession();
//       RoutePlanningSession.mapCenter = point;
//       RoutePlanningSession.mapZoom = 12.0;
//       _mapController.move(point, 12);
//     } catch (e) {
//       _showMessage(e.toString().replaceFirst('Exception: ', ''));
//     } finally {
//       if (mounted) setState(() => _isFetchingGps = false);
//     }
//   }

//   void _onMapTap(TapPosition tapPosition, LatLng point) {
//     if (_currentPinMode == PinMode.none) return;
//     final coordinateText = '${point.latitude.toStringAsFixed(6)}, ${point.longitude.toStringAsFixed(6)}';
    
//     setState(() {
//       if (_currentPinMode == PinMode.source) {
//         _sourcePos = point;
//         _sourceLabel = coordinateText;
//         _sourceSearchCtrl.text = coordinateText;
//       } else {
//         _destPos = point;
//         _destLabel = coordinateText;
//         _destinationSearchCtrl.text = coordinateText;
//       }
//       _currentPinMode = PinMode.none;
//     });
//     _syncToSession();
//   }

//   Future<void> _searchLocation({required bool source}) async {
//     final controller = source ? _sourceSearchCtrl : _destinationSearchCtrl;
//     final query = controller.text.trim();
//     if (query.isEmpty) return _showMessage('Enter a location to search.');
//     FocusScope.of(context).unfocus();

//     try {
//       final response = await http.get(Uri.parse('$apiBase/search').replace(queryParameters: {'q': query})).timeout(const Duration(seconds: 30));
//       if (response.statusCode != 200) throw Exception('Location search failed.');

//       final decoded = jsonDecode(response.body);
//       dynamic result = (decoded is List && decoded.isNotEmpty) ? decoded.first : ((decoded is Map && decoded['results'] is List && decoded['results'].isNotEmpty) ? decoded['results'].first : decoded);
      
//       final lat = _number(result['lat'] ?? result['latitude'], double.nan);
//       final lon = _number(result['lon'] ?? result['lng'] ?? result['longitude'], double.nan);
//       if (!lat.isFinite || !lon.isFinite) throw Exception('Search response contains invalid coordinates.');

//       final point = LatLng(lat, lon);
//       if (!mounted) return;

//       setState(() {
//         if (source) {
//           _sourcePos = point;
//           _sourceLabel = query;
//         } else {
//           _destPos = point;
//           _destLabel = query;
//         }
//         _error = null;
//       });

//       _syncToSession();
//       RoutePlanningSession.mapCenter = point;
//       RoutePlanningSession.mapZoom = 11.0;
//       _mapController.move(point, 11);
//     } catch (e) {
//       _showMessage(e.toString().replaceFirst('Exception: ', ''));
//     }
//   }

//   Future<Map<String, dynamic>> _processRouteImpact(List<LatLng> points, double totalDistanceKm) async {
//     double baseEnergyTotal = totalDistanceKm / 100.0 * _baseConsumptionKwh100km;
//     if (points.length < 4) return {'adjustedEnergy': baseEnergyTotal, 'avgTemp': 30.0, 'totalElevationChange': 0.0, 'weatherDesc': 'Short route - base calculation used'};

//     int n = points.length;
//     LatLng p0 = points.first;
//     LatLng p1 = points[n ~/ 3];
//     LatLng p2 = points[2 * n ~/ 3];
//     LatLng p3 = points.last;

//     const distanceCalc = Distance();
//     double d1 = distanceCalc.as(LengthUnit.Meter, p0, p1) / 1000.0;
//     double d2 = distanceCalc.as(LengthUnit.Meter, p1, p2) / 1000.0;
//     double d3 = distanceCalc.as(LengthUnit.Meter, p2, p3) / 1000.0;

//     double sumD = d1 + d2 + d3;
//     if (sumD > 0) {
//       d1 = (d1 / sumD) * totalDistanceKm;
//       d2 = (d2 / sumD) * totalDistanceKm;
//       d3 = (d3 / sumD) * totalDistanceKm;
//     } else {
//       d1 = d2 = d3 = totalDistanceKm / 3.0;
//     }

//     try {
//       final responses = await Future.wait([
//         http.get(Uri.parse('https://api.open-meteo.com/v1/elevation?latitude=${p0.latitude},${p1.latitude},${p2.latitude},${p3.latitude}&longitude=${p0.longitude},${p1.longitude},${p2.longitude},${p3.longitude}')).timeout(const Duration(seconds: 15)),
//         http.get(Uri.parse('https://api.open-meteo.com/v1/forecast?latitude=${p1.latitude},${p2.latitude},${p3.latitude}&longitude=${p1.longitude},${p2.longitude},${p3.longitude}&current=temperature_2m,precipitation')).timeout(const Duration(seconds: 15)),
//       ]);

//       List<double> elevs = [0, 0, 0, 0];
//       if (responses[0].statusCode == 200) {
//         final data = jsonDecode(responses[0].body);
//         if (data['elevation'] is List) {
//           for (int i = 0; i < 4 && i < data['elevation'].length; i++) elevs[i] = _number(data['elevation'][i]);
//         }
//       }
      
//       List<double> temps = [30.0, 30.0, 30.0];
//       List<double> rains = [0.0, 0.0, 0.0];
//       if (responses[1].statusCode == 200) {
//         final wData = jsonDecode(responses[1].body);
//         if (wData is List) {
//           for (int i = 0; i < 3 && i < wData.length; i++) {
//             temps[i] = _number(wData[i]['current']?['temperature_2m'], 30.0);
//             rains[i] = _number(wData[i]['current']?['precipitation'], 0.0);
//           }
//         } else if (wData is Map) {
//           temps[0] = temps[1] = temps[2] = _number(wData['current']?['temperature_2m'], 30.0);
//           rains[0] = rains[1] = rains[2] = _number(wData['current']?['precipitation'], 0.0);
//         }
//       }

//       double totalAdjustedEnergy = 0.0;
//       final segments = [
//         {'dist': d1, 'elev': elevs[1] - elevs[0], 'temp': temps[0], 'rain': rains[0]},
//         {'dist': d2, 'elev': elevs[2] - elevs[1], 'temp': temps[1], 'rain': rains[1]},
//         {'dist': d3, 'elev': elevs[3] - elevs[2], 'temp': temps[2], 'rain': rains[2]},
//       ];

//       for (var seg in segments) {
//         double segBaseEnergy = (seg['dist']! / 100.0) * _baseConsumptionKwh100km;
//         double terrainMult = 1.0;
//         if (seg['elev']! > 100) terrainMult += 0.12; else if (seg['elev']! > 40) terrainMult += 0.06; else if (seg['elev']! < -80) terrainMult -= 0.04;
        
//         double weatherMult = 1.0;
//         if (seg['temp']! > 32) weatherMult += 0.12; else if (seg['temp']! < 15) weatherMult += 0.18;
//         if (seg['rain']! > 0) weatherMult += 0.05;

//         totalAdjustedEnergy += (segBaseEnergy * weatherMult * terrainMult);
//       }

//       return {
//         'adjustedEnergy': totalAdjustedEnergy,
//         'avgTemp': (temps[0] + temps[1] + temps[2]) / 3,
//         'totalElevationChange': elevs[3] - elevs[0],
//         'weatherDesc': 'Avg Temp: ${((temps[0] + temps[1] + temps[2]) / 3).toStringAsFixed(1)}°C${rains.any((r) => r > 0) ? ' · Rain detected' : ''}',
//       };
//     } catch (_) {
//       return {'adjustedEnergy': baseEnergyTotal, 'avgTemp': 30.0, 'totalElevationChange': 0.0, 'weatherDesc': 'API error - baseline used'};
//     }
//   }

//   Future<void> _calculateRoutes({String? overrideSourceLabel, String? overrideDestLabel}) async {
//     final from = _sourceSearchCtrl.text.trim();
//     final to = _destinationSearchCtrl.text.trim();

//     if (from.isEmpty || to.isEmpty) return _showMessage('Enter both source and destination.');
//     FocusScope.of(context).unfocus();

//     setState(() {
//       _isCalculating = true;
//       _error = null;
//       _routes = [];
//       _selectedRouteIndex = 0;
//     });

//     try {
//       final response = await http.post(
//         Uri.parse('$apiBase/routes'),
//         headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
//         body: jsonEncode({
//           'source': {'name': from},
//           'destination': {'name': to},
//           'alternatives': 3,
//           'consumption_kwh_per_100km': _baseConsumptionKwh100km,
//         }),
//       ).timeout(const Duration(seconds: 60));

//       if (response.statusCode != 200) throw Exception('Backend returned ${response.statusCode}');

//       final data = jsonDecode(response.body) as Map<String, dynamic>;
//       final rawRoutes = data['routes'] as List? ?? [];
//       if (rawRoutes.isEmpty) throw Exception('No routes returned. Try different locations.');

//       // Safely apply the nice labels instead of overriding them with raw coordinate numbers
//       setState(() {
//         _sourceLabel = overrideSourceLabel ?? from;
//         _destLabel = overrideDestLabel ?? to;
//       });

//       final routeFutures = <Future<RouteModel>>[];

//       for (int i = 0; i < rawRoutes.length && i < 3; i++) {
//         final route = Map<String, dynamic>.from(rawRoutes[i] as Map);
//         final geometry = route['geometry'];
//         if (geometry is! Map) continue;

//         final coordinates = geometry['coordinates'];
//         if (coordinates is! List) continue;

//         final points = coordinates.whereType<List>().where((c) => c.length >= 2)
//             .map((c) => LatLng(_number(c[1], double.nan), _number(c[0], double.nan)))
//             .where((p) => p.latitude.isFinite && p.longitude.isFinite).toList();

//         if (points.length < 2) continue;
//         final distanceKm = _number(route['distance_km']);
//         final durationMin = _number(route['duration_minutes']);

//         routeFutures.add(() async {
//           final impact = await _processRouteImpact(points, distanceKm);
//           return RouteModel(
//             index: i,
//             name: i == 0 ? 'Fastest Route' : (i == 1 ? 'Alternative 1' : 'Alternative 2'),
//             distanceKm: distanceKm,
//             durationMin: durationMin,
//             points: points,
//             baseEnergyKwh: distanceKm / 100.0 * _baseConsumptionKwh100km,
//             adjustedEnergyKwh: impact['adjustedEnergy'],
//             tempC: impact['avgTemp'],
//             elevationChangeM: impact['totalElevationChange'],
//             weatherCondition: impact['weatherDesc'],
//             weatherMultiplier: 1.0,
//             terrainMultiplier: 1.0,
//           );
//         }());
//       }

//       final parsedRoutes = await Future.wait(routeFutures);
//       if (parsedRoutes.isEmpty) throw Exception('The backend returned no valid route geometry.');

//       parsedRoutes.sort((a, b) => a.adjustedEnergyKwh.compareTo(b.adjustedEnergyKwh));

//       if (!mounted) return;
//       setState(() {
//         _routes = parsedRoutes;
//         _selectedRouteIndex = 0;
//         _error = null;
//       });

//       _syncToSession();

//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         if (!mounted || _routes.isEmpty) return;
//         final allPoints = <LatLng>[for (final route in _routes) ...route.points];
//         if (allPoints.isNotEmpty) {
//           try {
//             _mapController.fitCamera(CameraFit.bounds(bounds: LatLngBounds.fromPoints(allPoints), padding: const EdgeInsets.all(40)));
//           } catch (_) {}
//         }
//       });
//     } catch (e) {
//       if (mounted) setState(() => _error = e.toString().replaceFirst('Exception: ', ''));
//     } finally {
//       if (mounted) setState(() => _isCalculating = false);
//     }
//   }

//   Widget _sectionTitle(String text) {
//     return Text(text, style: const TextStyle(color: Color(0xFF78829D), fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.1));
//   }

//   Widget _buildLocationPanel() {
//     return Container(
//       padding: const EdgeInsets.all(14),
//       decoration: BoxDecoration(color: panel, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.white.withOpacity(0.05))),
//       child: Column(
//         children: [
//           Row(
//             children: [
//               const Icon(Icons.circle, color: green, size: 11),
//               const SizedBox(width: 10),
//               Expanded(
//                 child: TextField(
//                   controller: _sourceSearchCtrl,
//                   style: const TextStyle(color: Colors.white, fontSize: 13),
//                   decoration: const InputDecoration(hintText: 'Source city or address', hintStyle: TextStyle(color: muted, fontSize: 12), border: InputBorder.none, isDense: true),
//                   onSubmitted: (_) => _searchLocation(source: true),
//                 ),
//               ),
//               IconButton(tooltip: 'Search source', onPressed: () => _searchLocation(source: true), icon: const Icon(Icons.search, color: green, size: 20)),
//               IconButton(tooltip: 'Use current GPS location', onPressed: _isFetchingGps ? null : _useCurrentGpsLocation, icon: _isFetchingGps ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: green)) : const Icon(Icons.gps_fixed, color: green, size: 20)),
//               _pinButton(PinMode.source),
//             ],
//           ),
//           const Divider(color: Colors.white12, height: 12),
//           Row(
//             children: [
//               const Icon(Icons.location_on, color: Colors.redAccent, size: 15),
//               const SizedBox(width: 8),
//               Expanded(
//                 child: TextField(
//                   controller: _destinationSearchCtrl,
//                   style: const TextStyle(color: Colors.white, fontSize: 13),
//                   decoration: const InputDecoration(hintText: 'Destination city or address', hintStyle: TextStyle(color: muted, fontSize: 12), border: InputBorder.none, isDense: true),
//                   onSubmitted: (_) => _searchLocation(source: false),
//                 ),
//               ),
//               IconButton(tooltip: 'Search destination', onPressed: () => _searchLocation(source: false), icon: const Icon(Icons.search, color: green, size: 20)),
//               _pinButton(PinMode.destination),
//             ],
//           ),
//           if (_currentPinMode != PinMode.none) ...[
//             const Divider(color: Colors.white12),
//             Row(
//               children: [
//                 const Icon(Icons.touch_app, color: green, size: 18),
//                 const SizedBox(width: 8),
//                 Expanded(child: Text(_currentPinMode == PinMode.source ? 'Tap the map to pin your source' : 'Tap the map to pin your destination', style: const TextStyle(color: green, fontSize: 12))),
//                 IconButton(onPressed: () => setState(() => _currentPinMode = PinMode.none), icon: const Icon(Icons.close, size: 18), color: Colors.white70),
//               ],
//             ),
//           ],
//         ],
//       ),
//     );
//   }

//   Widget _pinButton(PinMode mode) {
//     final active = _currentPinMode == mode;
//     return OutlinedButton(
//       onPressed: () => setState(() => _currentPinMode = active ? PinMode.none : mode),
//       style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 8), minimumSize: const Size(42, 34), side: BorderSide(color: active ? green : Colors.white24), backgroundColor: active ? green.withOpacity(0.12) : Colors.transparent),
//       child: const Icon(Icons.add_location_alt, size: 16, color: Colors.white),
//     );
//   }

//   Widget _buildBatteryPanel(double availableEnergy) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
//       decoration: BoxDecoration(color: panel, borderRadius: BorderRadius.circular(16)),
//       child: Column(
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               const Text('Vehicle Battery Charge', style: TextStyle(color: muted, fontSize: 12)),
//               Text('${_currentBatteryPercent.round()}% (${availableEnergy.toStringAsFixed(1)} kWh)', style: const TextStyle(color: green, fontSize: 13, fontWeight: FontWeight.bold)),
//             ],
//           ),
//           Slider(value: _currentBatteryPercent, min: 5, max: 100, activeColor: green, inactiveColor: const Color(0xFF202B40), onChanged: (value) { setState(() => _currentBatteryPercent = value); RoutePlanningSession.currentBatteryPercent = value; }),
//           Align(alignment: Alignment.centerLeft, child: Text('Battery capacity: ${_batteryCapacityKwh.toStringAsFixed(1)} kWh ($_vehicleName)', style: const TextStyle(color: muted, fontSize: 10))),
//         ],
//       ),
//     );
//   }

//   Widget _buildEnvironmentalCard(RouteModel route) {
//     final overallImpactPercent = ((route.adjustedEnergyKwh / route.baseEnergyKwh) - 1.0) * 100;
//     return Container(
//       padding: const EdgeInsets.all(14),
//       decoration: BoxDecoration(color: const Color(0xFF121A2F), borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.blueAccent.withOpacity(0.2))),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Row(children: [Icon(Icons.cloud_sync, color: Colors.lightBlueAccent, size: 17), SizedBox(width: 8), Expanded(child: Text('3-SEGMENT ENVIRONMENTAL IMPACT', style: TextStyle(color: Colors.lightBlueAccent, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1)))]),
//           const SizedBox(height: 12),
//           Row(children: [Expanded(child: _infoValue('Temperature', '${route.tempC.toStringAsFixed(1)}°C', Icons.thermostat)), Expanded(child: _infoValue('Elevation change', '${route.elevationChangeM >= 0 ? '+' : ''}${route.elevationChangeM.toStringAsFixed(0)} m', Icons.terrain))]),
//           const SizedBox(height: 10),
//           Text(route.weatherCondition, style: const TextStyle(color: muted, fontSize: 11)),
//           const Divider(color: Colors.white10, height: 22),
//           Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Expanded(child: Text('Estimated energy required', style: TextStyle(color: muted, fontSize: 11))), Text('${route.adjustedEnergyKwh.toStringAsFixed(2)} kWh', style: const TextStyle(color: green, fontSize: 13, fontWeight: FontWeight.bold))]),
//           const SizedBox(height: 5),
//           Text('Baseline ${route.baseEnergyKwh.toStringAsFixed(2)} kWh · Environmental adjustment ${overallImpactPercent >= 0 ? '+' : ''}${overallImpactPercent.toStringAsFixed(1)}%', style: const TextStyle(color: muted, fontSize: 10)),
//           const SizedBox(height: 14),
//           SizedBox(width: double.infinity, height: 44, child: ElevatedButton.icon(onPressed: _isSavingRoute ? null : () => _saveRoutePlan(route), style: ElevatedButton.styleFrom(backgroundColor: green, foregroundColor: bg, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))), icon: _isSavingRoute ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: bg)) : const Icon(Icons.bookmark_add_outlined, size: 18), label: Text(_isSavingRoute ? 'Saving...' : 'Save Selected Route Plan', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)))),
//         ],
//       ),
//     );
//   }

//   Widget _infoValue(String label, String value, IconData icon) {
//     return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Icon(icon, color: muted, size: 18), const SizedBox(width: 7), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(label, style: const TextStyle(color: muted, fontSize: 10)), const SizedBox(height: 4), Text(value, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600))]))]);
//   }

//   Widget _buildRouteCard({required RouteModel route, required bool selected, required bool enoughBattery, required VoidCallback onTap}) {
//     final hours = route.durationMin.floor() ~/ 60;
//     final minutes = route.durationMin.floor() % 60;
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         margin: const EdgeInsets.only(bottom: 10),
//         padding: const EdgeInsets.all(14),
//         decoration: BoxDecoration(color: selected ? const Color(0xFF0F1B2E) : panel, borderRadius: BorderRadius.circular(15), border: Border.all(color: selected ? green : Colors.white12, width: selected ? 1.5 : 1)),
//         child: Column(
//           children: [
//             Row(children: [Container(width: 9, height: 30, decoration: BoxDecoration(color: _routeColors[route.index % _routeColors.length], borderRadius: BorderRadius.circular(6))), const SizedBox(width: 10), Expanded(child: Text(route.name, style: TextStyle(color: selected ? green : Colors.white, fontWeight: FontWeight.bold, fontSize: 14))), Text('${route.distanceKm.toStringAsFixed(1)} km', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13))]),
//             const SizedBox(height: 12),
//             Row(children: [const Icon(Icons.access_time, size: 15, color: muted), const SizedBox(width: 5), Text(hours > 0 ? '${hours}h ${minutes}m' : '${minutes}m', style: const TextStyle(color: muted, fontSize: 11)), const SizedBox(width: 14), const Icon(Icons.bolt, color: Colors.amber, size: 16), const SizedBox(width: 4), Expanded(child: Text('${route.adjustedEnergyKwh.toStringAsFixed(2)} kWh', style: const TextStyle(color: Colors.white70, fontSize: 11))), if (selected) const Icon(Icons.check_circle, color: green, size: 19)]),
//             const SizedBox(height: 10),
//             Row(children: [Icon(enoughBattery ? Icons.check_circle_outline : Icons.battery_alert, color: enoughBattery ? green : Colors.orangeAccent, size: 15), const SizedBox(width: 5), Text(enoughBattery ? 'Estimated battery is sufficient' : 'Charging may be required', style: TextStyle(color: enoughBattery ? green : Colors.orangeAccent, fontSize: 10))]),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final availableEnergy = _batteryCapacityKwh * _currentBatteryPercent / 100;
//     final activeRoute = _routes.isNotEmpty ? _routes[_selectedRouteIndex] : null;
//     return Scaffold(
//       backgroundColor: bg,
//       body: SafeArea(
//         child: Column(
//           children: [
//             Expanded(
//               flex: 5,
//               child: Stack(
//                 children: [
//                   FlutterMap(
//                     mapController: _mapController,
//                     options: MapOptions(
//                       initialCenter: RoutePlanningSession.mapCenter ?? const LatLng(11.0018, 76.9628),
//                       initialZoom: RoutePlanningSession.mapZoom,
//                       onTap: _onMapTap,
//                       onPositionChanged: (pos, hasGesture) {
//                         if (pos.center != null) {
//                           RoutePlanningSession.mapCenter = pos.center;
//                           RoutePlanningSession.mapZoom = pos.zoom;
//                         }
//                       },
//                     ),
//                     children: [
//                       TileLayer(urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png', userAgentPackageName: 'com.example.ev_route_optimizer'),
//                       PolylineLayer(polylines: [for (int i = 0; i < _routes.length; i++) if (_routes[i].points.length >= 2) Polyline(points: _routes[i].points, color: _routeColors[_routes[i].index % _routeColors.length].withOpacity(i == _selectedRouteIndex ? 1 : 0.55), strokeWidth: i == _selectedRouteIndex ? 5.5 : 4)]),
//                       MarkerLayer(markers: [if (_sourcePos != null) Marker(point: _sourcePos!, width: 40, height: 40, child: const Icon(Icons.trip_origin, color: green, size: 30)), if (_destPos != null) Marker(point: _destPos!, width: 42, height: 42, child: const Icon(Icons.location_on, color: Colors.redAccent, size: 36))]),
//                       const RichAttributionWidget(attributions: [TextSourceAttribution('© OpenStreetMap contributors')]),
//                     ],
//                   ),
//                   Positioned(top: 12, left: 14, right: 14, child: Container(padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11), decoration: BoxDecoration(color: bg.withOpacity(0.92), borderRadius: BorderRadius.circular(13), border: Border.all(color: green.withOpacity(0.35))), child: Row(children: [const Icon(Icons.electric_car, color: green, size: 22), const SizedBox(width: 10), const Expanded(child: Text('BATTERY-EFFICIENT ROUTES', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11, letterSpacing: 1))), if (_routes.isNotEmpty) Text('${_routes.length} routes', style: const TextStyle(color: green, fontSize: 11))]))),
//                   if (_currentPinMode != PinMode.none) Positioned(bottom: 12, left: 12, right: 12, child: Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: bg.withOpacity(0.95), borderRadius: BorderRadius.circular(12)), child: Text(_currentPinMode == PinMode.source ? 'Tap the map to set the source' : 'Tap the map to set the destination', textAlign: TextAlign.center, style: const TextStyle(color: green, fontWeight: FontWeight.bold)))),
//                 ],
//               ),
//             ),
//             Expanded(
//               flex: 6,
//               child: Container(
//                 decoration: const BoxDecoration(color: bg, borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
//                 child: ListView(
//                   padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
//                   children: [
//                     _buildLocationPanel(),
//                     const SizedBox(height: 12),
//                     _buildBatteryPanel(availableEnergy),
//                     const SizedBox(height: 12),
//                     SizedBox(height: 49, child: ElevatedButton.icon(onPressed: _isCalculating ? null : () => _calculateRoutes(), style: ElevatedButton.styleFrom(backgroundColor: green, foregroundColor: bg, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13))), icon: _isCalculating ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(color: bg, strokeWidth: 2)) : const Icon(Icons.alt_route), label: Text(_isCalculating ? 'Analyzing routes & segments...' : 'Analyze Alternative Routes', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)))),
//                     if (_error != null) ...[const SizedBox(height: 12), Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: Colors.red.withOpacity(0.10), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.redAccent.withOpacity(0.4))), child: Text(_error!, style: const TextStyle(color: Colors.redAccent, fontSize: 12)))],
//                     if (activeRoute != null) ...[
//                       const SizedBox(height: 18), _buildEnvironmentalCard(activeRoute), const SizedBox(height: 18), _sectionTitle('AVAILABLE ROUTES'), const SizedBox(height: 10),
//                       for (int i = 0; i < _routes.length; i++) _buildRouteCard(route: _routes[i], selected: i == _selectedRouteIndex, enoughBattery: availableEnergy >= _routes[i].adjustedEnergyKwh, onTap: () { setState(() => _selectedRouteIndex = i); RoutePlanningSession.selectedRouteIndex = i; final points = _routes[i].points; if (points.isNotEmpty) { _mapController.move(points[points.length ~/ 2], 9); } }),
//                     ] else if (!_isCalculating && _error == null) ...[const SizedBox(height: 20), const Icon(Icons.route, color: muted, size: 34), const SizedBox(height: 8), const Center(child: Text('Enter your journey and analyze routes', textAlign: TextAlign.center, style: TextStyle(color: muted, fontSize: 12)))],
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//       bottomNavigationBar: Container(
//         decoration: const BoxDecoration(color: Color(0xFF0A0F1D), border: Border(top: BorderSide(color: Colors.white10))),
//         child: BottomNavigationBar(
//           currentIndex: _selectedIndex, onTap: _onBottomNavTapped, backgroundColor: const Color(0xFF0A0F1D), type: BottomNavigationBarType.fixed, selectedItemColor: green, unselectedItemColor: const Color(0xFF535D75), selectedFontSize: 11, unselectedFontSize: 11,
//           items: const [BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'Home'), BottomNavigationBarItem(icon: Icon(Icons.alt_route), label: 'Routes'), BottomNavigationBarItem(icon: Icon(Icons.bolt), label: 'Charging'), BottomNavigationBarItem(icon: Icon(Icons.assignment_outlined), activeIcon: Icon(Icons.assignment), label: 'Trips'), BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: 'Profile')],
//         ),
//       ),
//     );
//   }
// }


import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

enum PinMode { none, source, destination }

class RouteModel {
  final int index;
  final String name;
  final double distanceKm;
  final double durationMin;
  final List<LatLng> points;
  final double baseEnergyKwh;
  final double adjustedEnergyKwh;
  final double tempC;
  final double elevationChangeM;
  final String weatherCondition;
  final double weatherMultiplier;
  final double terrainMultiplier;
  final int numSegments;

  const RouteModel({
    required this.index,
    required this.name,
    required this.distanceKm,
    required this.durationMin,
    required this.points,
    required this.baseEnergyKwh,
    required this.adjustedEnergyKwh,
    required this.tempC,
    required this.elevationChangeM,
    required this.weatherCondition,
    required this.weatherMultiplier,
    required this.terrainMultiplier,
    required this.numSegments,
  });
}

class SuggestedCharger {
  final String id;
  final String name;
  final LatLng location;
  final double distanceKm;
  final String capacity;
  final String powerInfo;

  SuggestedCharger({
    required this.id,
    required this.name,
    required this.location,
    required this.distanceKm,
    required this.capacity,
    required this.powerInfo,
  });
}

// ================= PERSISTENT APP SESSION CACHE =================
class RoutePlanningSession {
  static LatLng? sourcePos;
  static LatLng? destPos;
  static String sourceText = 'Coimbatore';
  static String destText = 'Chennai';
  static String sourceLabel = 'Coimbatore';
  static String destLabel = 'Chennai';
  static List<RouteModel> cachedRoutes = [];
  static int selectedRouteIndex = 0;
  static double currentBatteryPercent = 75.0;
  static LatLng? mapCenter;
  static double mapZoom = 6.0;
}

class RoutePlanningScreen extends StatefulWidget {
  const RoutePlanningScreen({super.key});

  @override
  State<RoutePlanningScreen> createState() => _RoutePlanningScreenState();
}

class _RoutePlanningScreenState extends State<RoutePlanningScreen> {
  // ===========================================================================
  // IMPORTANT: PASTE YOUR OPEN CHARGE MAP API KEY HERE
  // ===========================================================================
  static const String ocmApiKey = 'YOUR_OPEN_CHARGE_MAP_API_KEY';
  
  static const String apiBase = 'http://192.168.137.1:8000';

  static const Color bg = Color(0xFF070B16);
  static const Color panel = Color(0xFF0E1526);
  static const Color green = Color(0xFF1ECB6B);
  static const Color muted = Color(0xFF78829D);

  final int _selectedIndex = 1;
  final MapController _mapController = MapController();

  late final TextEditingController _sourceSearchCtrl;
  late final TextEditingController _destinationSearchCtrl;

  PinMode _currentPinMode = PinMode.none;

  LatLng? _sourcePos;
  LatLng? _destPos;

  String _sourceLabel = 'Coimbatore';
  String _destLabel = 'Chennai';

  bool _isFetchingGps = false;
  bool _isCalculating = false;
  bool _isSavingRoute = false;
  bool _handledArgs = false;

  String? _error;

  List<RouteModel> _routes = [];
  int _selectedRouteIndex = 0;

  // Charger Suggestion States
  bool _isFetchingChargers = false;
  List<SuggestedCharger> _suggestedChargers = [];

  double _currentBatteryPercent = 75.0;
  double _batteryCapacityKwh = 75.0;
  double _baseConsumptionKwh100km = 15.5;
  String _vehicleName = 'Your EV';

  final List<Color> _routeColors = const [
    Color(0xFF1ECB6B),
    Color(0xFF42B7FF),
    Color(0xFFFFB74D),
    Color(0xFFE879F9),
    Color(0xFFFF6B6B),
  ];

  @override
  void initState() {
    super.initState();
    _sourcePos = RoutePlanningSession.sourcePos;
    _destPos = RoutePlanningSession.destPos;
    _sourceLabel = RoutePlanningSession.sourceLabel;
    _destLabel = RoutePlanningSession.destLabel;
    _routes = List.from(RoutePlanningSession.cachedRoutes);
    _selectedRouteIndex = RoutePlanningSession.selectedRouteIndex;
    _currentBatteryPercent = RoutePlanningSession.currentBatteryPercent;

    _sourceSearchCtrl = TextEditingController(text: RoutePlanningSession.sourceText);
    _destinationSearchCtrl = TextEditingController(text: RoutePlanningSession.destText);

    _fetchUserVehicleSpecs();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (_routes.isNotEmpty) {
        _checkBatteryAndSuggestChargers(_routes[_selectedRouteIndex]);
        final allPoints = <LatLng>[for (final route in _routes) ...route.points];
        if (allPoints.isNotEmpty) {
          try {
            _mapController.fitCamera(CameraFit.bounds(bounds: LatLngBounds.fromPoints(allPoints), padding: const EdgeInsets.all(40)));
          } catch (_) {}
        }
      } else if (RoutePlanningSession.mapCenter != null) {
        _mapController.move(RoutePlanningSession.mapCenter!, RoutePlanningSession.mapZoom);
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_handledArgs) {
      final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      if (args != null && args['autoCalculate'] == true) {
        _handledArgs = true;

        final sPos = args['sourcePos'] as LatLng?;
        final dPos = args['destPos'] as LatLng?;
        final dName = args['destName'] as String?;

        if (sPos != null && dPos != null) {
          final sCoord = '${sPos.latitude}, ${sPos.longitude}';
          final dCoord = '${dPos.latitude}, ${dPos.longitude}';

          setState(() {
            _sourcePos = sPos;
            _destPos = dPos;
            _sourceSearchCtrl.text = sCoord;
            _destinationSearchCtrl.text = dCoord;

            RoutePlanningSession.sourcePos = sPos;
            RoutePlanningSession.destPos = dPos;
            RoutePlanningSession.sourceText = sCoord;
            RoutePlanningSession.destText = dCoord;
            RoutePlanningSession.sourceLabel = 'Current Location';
            RoutePlanningSession.destLabel = dName ?? 'Charging Station';
          });

          WidgetsBinding.instance.addPostFrameCallback((_) {
            _calculateRoutes(overrideSourceLabel: 'Current Location', overrideDestLabel: dName);
          });
        }
      }
    }
  }

  @override
  void dispose() {
    RoutePlanningSession.sourceText = _sourceSearchCtrl.text;
    RoutePlanningSession.destText = _destinationSearchCtrl.text;
    _sourceSearchCtrl.dispose();
    _destinationSearchCtrl.dispose();
    super.dispose();
  }

  void _syncToSession() {
    RoutePlanningSession.sourcePos = _sourcePos;
    RoutePlanningSession.destPos = _destPos;
    RoutePlanningSession.sourceLabel = _sourceLabel;
    RoutePlanningSession.destLabel = _destLabel;
    RoutePlanningSession.sourceText = _sourceSearchCtrl.text;
    RoutePlanningSession.destText = _destinationSearchCtrl.text;
    RoutePlanningSession.cachedRoutes = _routes;
    RoutePlanningSession.selectedRouteIndex = _selectedRouteIndex;
    RoutePlanningSession.currentBatteryPercent = _currentBatteryPercent;
  }

  Future<void> _fetchUserVehicleSpecs() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    try {
      final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (doc.exists && doc.data() != null) {
        final data = doc.data()!;
        if (!mounted) return;
        setState(() {
          _batteryCapacityKwh = (data['batteryCapacityKwh'] ?? 75.0).toDouble();
          _baseConsumptionKwh100km = (data['avgConsumption'] ?? 15.5).toDouble();
          final brand = data['vehicleBrand'] ?? '';
          final model = data['vehicleModel'] ?? '';
          if (brand.isNotEmpty || model.isNotEmpty) _vehicleName = '$brand $model'.trim();
        });
      }
    } catch (_) {}
  }

  // ================= DYNAMIC 50KM CHARGER SUGGESTION LOGIC =================
  Future<void> _checkBatteryAndSuggestChargers(RouteModel route) async {
    if (ocmApiKey == 'YOUR_OPEN_CHARGE_MAP_API_KEY') return;

    double availableEnergy = _batteryCapacityKwh * _currentBatteryPercent / 100;
    double remainingEnergy = availableEnergy - route.adjustedEnergyKwh;
    double remainingPercent = (remainingEnergy / _batteryCapacityKwh) * 100;

    if (remainingPercent >= 20.0) {
      if (mounted) setState(() => _suggestedChargers.clear());
      return;
    }

    if (mounted) {
      setState(() {
        _isFetchingChargers = true;
        _suggestedChargers.clear();
      });
    }

    try {
      // Find coordinates at every 50km interval along the route
      int numChecks = (route.distanceKm / 50.0).floor();
      List<LatLng> checkPoints = [];
      
      for (int i = 1; i <= numChecks; i++) {
        double targetKm = i * 50.0;
        int idx = ((route.points.length - 1) * (targetKm / route.distanceKm)).floor();
        checkPoints.add(route.points[idx]);
      }
      
      // If route is under 50km but still drains battery (e.g. tiny battery), grab the midpoint
      if (checkPoints.isEmpty) {
        checkPoints.add(route.points[route.points.length ~/ 2]);
      }

      // Fire concurrent OpenChargeMap searches for all 50km intervals
      List<Future<http.Response>> requests = [];
      for (var pt in checkPoints) {
        final url = Uri.parse('https://api.openchargemap.io/v3/poi?key=$ocmApiKey&latitude=${pt.latitude}&longitude=${pt.longitude}&distance=15&distanceunit=KM&maxresults=4&compact=true&verbose=false');
        requests.add(http.get(url, headers: {'User-Agent': 'EVRouteOptimizerApp/1.0'}));
      }

      final responses = await Future.wait(requests.map((r) => r.timeout(const Duration(seconds: 15))));
      Map<String, SuggestedCharger> uniqueChargers = {};

      for (int i = 0; i < responses.length; i++) {
        if (responses[i].statusCode == 200) {
          final List<dynamic> data = json.decode(responses[i].body);
          for (var el in data) {
            final address = el['AddressInfo'];
            if (address == null) continue;

            final double? lat = (address['Latitude'] as num?)?.toDouble();
            final double? lon = (address['Longitude'] as num?)?.toDouble();
            if (lat == null || lon == null) continue;

            final String id = el['ID'].toString();
            if (uniqueChargers.containsKey(id)) continue; // Prevent duplicates

            // Calculate distance from the route's starting point
            final double distanceMeters = Geolocator.distanceBetween(route.points.first.latitude, route.points.first.longitude, lat, lon);

            int plugCount = 0;
            double maxPowerKw = 0.0;
            if (el['Connections'] != null) {
              for (var conn in el['Connections']) {
                plugCount += (conn['Quantity'] as num?)?.toInt() ?? 1;
                final power = (conn['PowerKW'] as num?)?.toDouble() ?? 0.0;
                if (power > maxPowerKw) maxPowerKw = power;
              }
            }

            uniqueChargers[id] = SuggestedCharger(
              id: id,
              name: address['Title'] ?? 'Charging Station',
              location: LatLng(lat, lon),
              distanceKm: distanceMeters / 1000.0,
              capacity: plugCount > 0 ? '$plugCount Plugs' : 'Port Available',
              powerInfo: maxPowerKw > 0 ? 'Max ${maxPowerKw.toStringAsFixed(0)} kW' : 'Power Unknown',
            );
          }
        }
      }

      List<SuggestedCharger> fetched = uniqueChargers.values.toList();
      fetched.sort((a, b) => a.distanceKm.compareTo(b.distanceKm)); // Closest to start first
      
      if (fetched.length > 5) fetched = fetched.sublist(0, 5); // Limit UI clutter

      if (mounted) {
        setState(() {
          _suggestedChargers = fetched;
          _isFetchingChargers = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isFetchingChargers = false);
    }
  }
  // ======================================================================

  Future<void> _saveRoutePlan(RouteModel route) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      _showMessage('Please login to save this route plan.');
      return;
    }

    setState(() => _isSavingRoute = true);

    try {
      final tripData = {
        'userId': user.uid,
        'source': _sourceLabel,
        'destination': _destLabel,
        'distanceKm': double.parse(route.distanceKm.toStringAsFixed(2)),
        'kwhNeeded': double.parse(route.adjustedEnergyKwh.toStringAsFixed(2)),
        'durationMinutes': double.parse(route.durationMin.toStringAsFixed(1)),
        'dateTime': DateTime.now().toIso8601String(),
        'createdAt': FieldValue.serverTimestamp(),
      };

      await FirebaseFirestore.instance.collection('users').doc(user.uid).collection('trips').add(tripData);
      _showMessage('Route saved to Trip History!');
    } catch (e) {
      _showMessage('Failed to save route: $e');
    } finally {
      if (mounted) setState(() => _isSavingRoute = false);
    }
  }

  double _number(dynamic value, [double fallback = 0]) {
    if (value is num) return value.toDouble();
    return double.tryParse('$value') ?? fallback;
  }

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), backgroundColor: const Color(0xFF202A3D)));
  }

  void _onBottomNavTapped(int index) {
    if (index == _selectedIndex) return;
    _syncToSession();

    final routes = <int, String>{
      0: '/dashboard',
      2: '/charging',
      3: '/trips',
      4: '/profile',
    };
    final routeName = routes[index];
    if (routeName != null) Navigator.pushReplacementNamed(context, routeName);
  }

  Future<void> _useCurrentGpsLocation() async {
    setState(() { _isFetchingGps = true; _error = null; });
    try {
      if (!await Geolocator.isLocationServiceEnabled()) throw Exception('Enable location services on your phone.');
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) throw Exception('Enable location permission in your phone settings.');

      final position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      final point = LatLng(position.latitude, position.longitude);
      
      if (!mounted) return;
      setState(() {
        _sourcePos = point;
        _sourceLabel = 'Current GPS Location';
        _sourceSearchCtrl.text = '${point.latitude}, ${point.longitude}';
        _currentPinMode = PinMode.none;
      });

      _syncToSession();
      RoutePlanningSession.mapCenter = point;
      RoutePlanningSession.mapZoom = 12.0;
      _mapController.move(point, 12);
    } catch (e) {
      _showMessage(e.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _isFetchingGps = false);
    }
  }

  void _onMapTap(TapPosition tapPosition, LatLng point) {
    if (_currentPinMode == PinMode.none) return;
    final coordinateText = '${point.latitude.toStringAsFixed(6)}, ${point.longitude.toStringAsFixed(6)}';
    
    setState(() {
      if (_currentPinMode == PinMode.source) {
        _sourcePos = point;
        _sourceLabel = coordinateText;
        _sourceSearchCtrl.text = coordinateText;
      } else {
        _destPos = point;
        _destLabel = coordinateText;
        _destinationSearchCtrl.text = coordinateText;
      }
      _currentPinMode = PinMode.none;
    });
    _syncToSession();
  }

  Future<void> _searchLocation({required bool source}) async {
    final controller = source ? _sourceSearchCtrl : _destinationSearchCtrl;
    final query = controller.text.trim();
    if (query.isEmpty) return _showMessage('Enter a location to search.');
    FocusScope.of(context).unfocus();

    try {
      final response = await http.get(Uri.parse('$apiBase/search').replace(queryParameters: {'q': query})).timeout(const Duration(seconds: 30));
      if (response.statusCode != 200) throw Exception('Location search failed.');

      final decoded = jsonDecode(response.body);
      dynamic result = (decoded is List && decoded.isNotEmpty) ? decoded.first : ((decoded is Map && decoded['results'] is List && decoded['results'].isNotEmpty) ? decoded['results'].first : decoded);
      
      final lat = _number(result['lat'] ?? result['latitude'], double.nan);
      final lon = _number(result['lon'] ?? result['lng'] ?? result['longitude'], double.nan);
      if (!lat.isFinite || !lon.isFinite) throw Exception('Search response contains invalid coordinates.');

      final point = LatLng(lat, lon);
      if (!mounted) return;

      setState(() {
        if (source) {
          _sourcePos = point;
          _sourceLabel = query;
        } else {
          _destPos = point;
          _destLabel = query;
        }
        _error = null;
      });

      _syncToSession();
      RoutePlanningSession.mapCenter = point;
      RoutePlanningSession.mapZoom = 11.0;
      _mapController.move(point, 11);
    } catch (e) {
      _showMessage(e.toString().replaceFirst('Exception: ', ''));
    }
  }

  // ================= DYNAMIC 20KM WEATHER & TERRAIN LOGIC =================
  Future<Map<String, dynamic>> _processRouteImpact(List<LatLng> points, double totalDistanceKm) async {
    double baseEnergyTotal = totalDistanceKm / 100.0 * _baseConsumptionKwh100km;
    
    // Safety check for very short paths
    if (points.length < 4) {
      return {'adjustedEnergy': baseEnergyTotal, 'avgTemp': 30.0, 'totalElevationChange': 0.0, 'weatherDesc': 'Short route - base calculation used', 'numSegments': 3};
    }

    // Determine segments: < 100km = 3 segments. >= 100km = 1 segment per 20km.
    int numSegments = totalDistanceKm < 100 ? 3 : (totalDistanceKm / 20.0).ceil();
    if (numSegments > 40) numSegments = 40; // Hard cap at 40 (800km) to avoid URL length limit errors

    List<LatLng> elPoints = [];
    for (int i = 0; i <= numSegments; i++) {
      elPoints.add(points[(points.length - 1) * i ~/ numSegments]);
    }

    List<LatLng> wPoints = [];
    for (int i = 0; i < numSegments; i++) {
      wPoints.add(points[(points.length - 1) * i ~/ numSegments]);
    }

    double segmentDistance = totalDistanceKm / numSegments;

    try {
      String elLat = elPoints.map((p) => p.latitude.toStringAsFixed(4)).join(',');
      String elLon = elPoints.map((p) => p.longitude.toStringAsFixed(4)).join(',');
      final elUri = Uri.parse('https://api.open-meteo.com/v1/elevation?latitude=$elLat&longitude=$elLon');

      String wLat = wPoints.map((p) => p.latitude.toStringAsFixed(4)).join(',');
      String wLon = wPoints.map((p) => p.longitude.toStringAsFixed(4)).join(',');
      final wUri = Uri.parse('https://api.open-meteo.com/v1/forecast?latitude=$wLat&longitude=$wLon&current=temperature_2m,precipitation');

      final responses = await Future.wait([
        http.get(elUri).timeout(const Duration(seconds: 15)),
        http.get(wUri).timeout(const Duration(seconds: 15)),
      ]);

      List<double> elevs = List.filled(numSegments + 1, 0.0);
      if (responses[0].statusCode == 200) {
        final data = jsonDecode(responses[0].body);
        if (data['elevation'] is List) {
          for (int i = 0; i < (numSegments + 1) && i < data['elevation'].length; i++) elevs[i] = _number(data['elevation'][i]);
        }
      }
      
      List<double> temps = List.filled(numSegments, 30.0);
      List<double> rains = List.filled(numSegments, 0.0);
      if (responses[1].statusCode == 200) {
        final wData = jsonDecode(responses[1].body);
        if (wData is List) {
          for (int i = 0; i < numSegments && i < wData.length; i++) {
            temps[i] = _number(wData[i]['current']?['temperature_2m'], 30.0);
            rains[i] = _number(wData[i]['current']?['precipitation'], 0.0);
          }
        } else if (wData is Map) { // API falls back to single object if coordinates are tightly clustered
          double t = _number(wData['current']?['temperature_2m'], 30.0);
          double r = _number(wData['current']?['precipitation'], 0.0);
          for(int i=0; i<numSegments; i++) { temps[i] = t; rains[i] = r; }
        }
      }

      double totalAdjustedEnergy = 0.0;
      double sumTemp = 0.0;

      for (int i = 0; i < numSegments; i++) {
        double segBaseEnergy = (segmentDistance / 100.0) * _baseConsumptionKwh100km;
        
        double elevChange = elevs[i+1] - elevs[i];
        double terrainMult = 1.0;
        if (elevChange > 100) terrainMult += 0.12; else if (elevChange > 40) terrainMult += 0.06; else if (elevChange < -80) terrainMult -= 0.04;
        
        double weatherMult = 1.0;
        if (temps[i] > 32) weatherMult += 0.12; else if (temps[i] < 15) weatherMult += 0.18;
        if (rains[i] > 0) weatherMult += 0.05;

        totalAdjustedEnergy += (segBaseEnergy * weatherMult * terrainMult);
        sumTemp += temps[i];
      }

      double avgTemp = sumTemp / numSegments;

      return {
        'adjustedEnergy': totalAdjustedEnergy,
        'avgTemp': avgTemp,
        'totalElevationChange': elevs.last - elevs.first,
        'weatherDesc': 'Avg Temp: ${avgTemp.toStringAsFixed(1)}°C${rains.any((r) => r > 0) ? ' · Rain detected' : ''}',
        'numSegments': numSegments
      };
    } catch (_) {
      return {'adjustedEnergy': baseEnergyTotal, 'avgTemp': 30.0, 'totalElevationChange': 0.0, 'weatherDesc': 'API error - baseline used', 'numSegments': numSegments};
    }
  }

  Future<void> _calculateRoutes({String? overrideSourceLabel, String? overrideDestLabel}) async {
    final from = _sourceSearchCtrl.text.trim();
    final to = _destinationSearchCtrl.text.trim();

    if (from.isEmpty || to.isEmpty) return _showMessage('Enter both source and destination.');
    FocusScope.of(context).unfocus();

    setState(() {
      _isCalculating = true;
      _error = null;
      _routes = [];
      _selectedRouteIndex = 0;
      _suggestedChargers.clear();
    });

    try {
      final response = await http.post(
        Uri.parse('$apiBase/routes'),
        headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
        body: jsonEncode({
          'source': {'name': from},
          'destination': {'name': to},
          'alternatives': 3,
          'consumption_kwh_per_100km': _baseConsumptionKwh100km,
        }),
      ).timeout(const Duration(seconds: 60));

      if (response.statusCode != 200) throw Exception('Backend returned ${response.statusCode}');

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final rawRoutes = data['routes'] as List? ?? [];
      if (rawRoutes.isEmpty) throw Exception('No routes returned. Try different locations.');

      setState(() {
        _sourceLabel = overrideSourceLabel ?? from;
        _destLabel = overrideDestLabel ?? to;
      });

      final routeFutures = <Future<RouteModel>>[];

      for (int i = 0; i < rawRoutes.length && i < 3; i++) {
        final route = Map<String, dynamic>.from(rawRoutes[i] as Map);
        final geometry = route['geometry'];
        if (geometry is! Map) continue;

        final coordinates = geometry['coordinates'];
        if (coordinates is! List) continue;

        final points = coordinates.whereType<List>().where((c) => c.length >= 2)
            .map((c) => LatLng(_number(c[1], double.nan), _number(c[0], double.nan)))
            .where((p) => p.latitude.isFinite && p.longitude.isFinite).toList();

        if (points.length < 2) continue;
        final distanceKm = _number(route['distance_km']);
        final durationMin = _number(route['duration_minutes']);

        routeFutures.add(() async {
          final impact = await _processRouteImpact(points, distanceKm);
          return RouteModel(
            index: i,
            name: i == 0 ? 'Fastest Route' : (i == 1 ? 'Alternative 1' : 'Alternative 2'),
            distanceKm: distanceKm,
            durationMin: durationMin,
            points: points,
            baseEnergyKwh: distanceKm / 100.0 * _baseConsumptionKwh100km,
            adjustedEnergyKwh: impact['adjustedEnergy'],
            tempC: impact['avgTemp'],
            elevationChangeM: impact['totalElevationChange'],
            weatherCondition: impact['weatherDesc'],
            weatherMultiplier: 1.0,
            terrainMultiplier: 1.0,
            numSegments: impact['numSegments'] ?? 3,
          );
        }());
      }

      final parsedRoutes = await Future.wait(routeFutures);
      if (parsedRoutes.isEmpty) throw Exception('The backend returned no valid route geometry.');

      parsedRoutes.sort((a, b) => a.adjustedEnergyKwh.compareTo(b.adjustedEnergyKwh));

      if (!mounted) return;
      setState(() {
        _routes = parsedRoutes;
        _selectedRouteIndex = 0;
        _error = null;
      });

      _syncToSession();
      
      _checkBatteryAndSuggestChargers(_routes[0]);

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted || _routes.isEmpty) return;
        final allPoints = <LatLng>[for (final route in _routes) ...route.points];
        if (allPoints.isNotEmpty) {
          try {
            _mapController.fitCamera(CameraFit.bounds(bounds: LatLngBounds.fromPoints(allPoints), padding: const EdgeInsets.all(40)));
          } catch (_) {}
        }
      });
    } catch (e) {
      if (mounted) setState(() => _error = e.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _isCalculating = false);
    }
  }

  // ================= UI BUILDERS =================
  Widget _sectionTitle(String text) {
    return Text(text, style: const TextStyle(color: Color(0xFF78829D), fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.1));
  }

  Widget _buildLocationPanel() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: panel, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.white.withOpacity(0.05))),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.circle, color: green, size: 11),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: _sourceSearchCtrl,
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                  decoration: const InputDecoration(hintText: 'Source city or address', hintStyle: TextStyle(color: muted, fontSize: 12), border: InputBorder.none, isDense: true),
                  onSubmitted: (_) => _searchLocation(source: true),
                ),
              ),
              IconButton(tooltip: 'Search source', onPressed: () => _searchLocation(source: true), icon: const Icon(Icons.search, color: green, size: 20)),
              IconButton(tooltip: 'Use current GPS location', onPressed: _isFetchingGps ? null : _useCurrentGpsLocation, icon: _isFetchingGps ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: green)) : const Icon(Icons.gps_fixed, color: green, size: 20)),
              _pinButton(PinMode.source),
            ],
          ),
          const Divider(color: Colors.white12, height: 12),
          Row(
            children: [
              const Icon(Icons.location_on, color: Colors.redAccent, size: 15),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _destinationSearchCtrl,
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                  decoration: const InputDecoration(hintText: 'Destination city or address', hintStyle: TextStyle(color: muted, fontSize: 12), border: InputBorder.none, isDense: true),
                  onSubmitted: (_) => _searchLocation(source: false),
                ),
              ),
              IconButton(tooltip: 'Search destination', onPressed: () => _searchLocation(source: false), icon: const Icon(Icons.search, color: green, size: 20)),
              _pinButton(PinMode.destination),
            ],
          ),
          if (_currentPinMode != PinMode.none) ...[
            const Divider(color: Colors.white12),
            Row(
              children: [
                const Icon(Icons.touch_app, color: green, size: 18),
                const SizedBox(width: 8),
                Expanded(child: Text(_currentPinMode == PinMode.source ? 'Tap the map to pin your source' : 'Tap the map to pin your destination', style: const TextStyle(color: green, fontSize: 12))),
                IconButton(onPressed: () => setState(() => _currentPinMode = PinMode.none), icon: const Icon(Icons.close, size: 18), color: Colors.white70),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _pinButton(PinMode mode) {
    final active = _currentPinMode == mode;
    return OutlinedButton(
      onPressed: () => setState(() => _currentPinMode = active ? PinMode.none : mode),
      style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 8), minimumSize: const Size(42, 34), side: BorderSide(color: active ? green : Colors.white24), backgroundColor: active ? green.withOpacity(0.12) : Colors.transparent),
      child: const Icon(Icons.add_location_alt, size: 16, color: Colors.white),
    );
  }

  Widget _buildBatteryPanel(double availableEnergy) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(color: panel, borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Vehicle Battery Charge', style: TextStyle(color: muted, fontSize: 12)),
              Text('${_currentBatteryPercent.round()}% (${availableEnergy.toStringAsFixed(1)} kWh)', style: const TextStyle(color: green, fontSize: 13, fontWeight: FontWeight.bold)),
            ],
          ),
          Slider(
            value: _currentBatteryPercent, min: 5, max: 100, activeColor: green, inactiveColor: const Color(0xFF202B40), 
            onChanged: (value) { 
              setState(() => _currentBatteryPercent = value); 
              RoutePlanningSession.currentBatteryPercent = value; 
            },
            onChangeEnd: (value) {
              if (_routes.isNotEmpty) _checkBatteryAndSuggestChargers(_routes[_selectedRouteIndex]);
            },
          ),
          Align(alignment: Alignment.centerLeft, child: Text('Battery capacity: ${_batteryCapacityKwh.toStringAsFixed(1)} kWh ($_vehicleName)', style: const TextStyle(color: muted, fontSize: 10))),
        ],
      ),
    );
  }

  Widget _buildChargingSuggestions() {
    if (_isFetchingChargers) {
      return Container(
        margin: const EdgeInsets.only(top: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: const Color(0xFF1E1610), borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.orangeAccent.withOpacity(0.3))),
        child: const Row(
          children: [
            SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.orangeAccent, strokeWidth: 2)),
            SizedBox(width: 12),
            Text('Scanning 50km intervals for chargers...', style: TextStyle(color: Colors.orangeAccent, fontSize: 12)),
          ],
        ),
      );
    }

    if (_suggestedChargers.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: const Color(0xFF1E1610), borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.orangeAccent.withOpacity(0.3))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.battery_alert, color: Colors.orangeAccent, size: 18),
              SizedBox(width: 8),
              Expanded(child: Text('LOW BATTERY WARNING', style: TextStyle(color: Colors.orangeAccent, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 0.5))),
            ],
          ),
          const SizedBox(height: 6),
          const Text('Charge drops below 20% on this route. Suggested stops along the way:', style: TextStyle(color: Colors.white70, fontSize: 12)),
          const SizedBox(height: 12),
          
          ..._suggestedChargers.map((station) => Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: const Color(0xFF2D2018), borderRadius: BorderRadius.circular(12)),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(station.name, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 4),
                      Text('${station.capacity} • ${station.powerInfo}', style: const TextStyle(color: Colors.white54, fontSize: 11)),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _destPos = station.location;
                      _destinationSearchCtrl.text = '${station.location.latitude}, ${station.location.longitude}';
                    });
                    _calculateRoutes(overrideDestLabel: station.name);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orangeAccent,
                    foregroundColor: const Color(0xFF1E1610),
                    minimumSize: const Size(60, 32),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Re-Route', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildEnvironmentalCard(RouteModel route) {
    final overallImpactPercent = ((route.adjustedEnergyKwh / route.baseEnergyKwh) - 1.0) * 100;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: const Color(0xFF121A2F), borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.blueAccent.withOpacity(0.2))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [const Icon(Icons.cloud_sync, color: Colors.lightBlueAccent, size: 17), const SizedBox(width: 8), Expanded(child: Text('${route.numSegments}-SEGMENT ENVIRONMENTAL IMPACT', style: const TextStyle(color: Colors.lightBlueAccent, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1)))]),
          const SizedBox(height: 12),
          Row(children: [Expanded(child: _infoValue('Avg Temperature', '${route.tempC.toStringAsFixed(1)}°C', Icons.thermostat)), Expanded(child: _infoValue('Elevation net', '${route.elevationChangeM >= 0 ? '+' : ''}${route.elevationChangeM.toStringAsFixed(0)} m', Icons.terrain))]),
          const SizedBox(height: 10),
          Text(route.weatherCondition, style: const TextStyle(color: muted, fontSize: 11)),
          const Divider(color: Colors.white10, height: 22),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Expanded(child: Text('Estimated energy required', style: TextStyle(color: muted, fontSize: 11))), Text('${route.adjustedEnergyKwh.toStringAsFixed(2)} kWh', style: const TextStyle(color: green, fontSize: 13, fontWeight: FontWeight.bold))]),
          const SizedBox(height: 5),
          Text('Baseline ${route.baseEnergyKwh.toStringAsFixed(2)} kWh · Environmental adjustment ${overallImpactPercent >= 0 ? '+' : ''}${overallImpactPercent.toStringAsFixed(1)}%', style: const TextStyle(color: muted, fontSize: 10)),
          const SizedBox(height: 14),
          SizedBox(width: double.infinity, height: 44, child: ElevatedButton.icon(onPressed: _isSavingRoute ? null : () => _saveRoutePlan(route), style: ElevatedButton.styleFrom(backgroundColor: green, foregroundColor: bg, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))), icon: _isSavingRoute ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: bg)) : const Icon(Icons.bookmark_add_outlined, size: 18), label: Text(_isSavingRoute ? 'Saving...' : 'Save Selected Route Plan', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)))),
        ],
      ),
    );
  }

  Widget _infoValue(String label, String value, IconData icon) {
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Icon(icon, color: muted, size: 18), const SizedBox(width: 7), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(label, style: const TextStyle(color: muted, fontSize: 10)), const SizedBox(height: 4), Text(value, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600))]))]);
  }

  Widget _buildRouteCard({required RouteModel route, required bool selected, required bool enoughBattery, required VoidCallback onTap}) {
    final hours = route.durationMin.floor() ~/ 60;
    final minutes = route.durationMin.floor() % 60;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: selected ? const Color(0xFF0F1B2E) : panel, borderRadius: BorderRadius.circular(15), border: Border.all(color: selected ? green : Colors.white12, width: selected ? 1.5 : 1)),
        child: Column(
          children: [
            Row(children: [Container(width: 9, height: 30, decoration: BoxDecoration(color: _routeColors[route.index % _routeColors.length], borderRadius: BorderRadius.circular(6))), const SizedBox(width: 10), Expanded(child: Text(route.name, style: TextStyle(color: selected ? green : Colors.white, fontWeight: FontWeight.bold, fontSize: 14))), Text('${route.distanceKm.toStringAsFixed(1)} km', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13))]),
            const SizedBox(height: 12),
            Row(children: [const Icon(Icons.access_time, size: 15, color: muted), const SizedBox(width: 5), Text(hours > 0 ? '${hours}h ${minutes}m' : '${minutes}m', style: const TextStyle(color: muted, fontSize: 11)), const SizedBox(width: 14), const Icon(Icons.bolt, color: Colors.amber, size: 16), const SizedBox(width: 4), Expanded(child: Text('${route.adjustedEnergyKwh.toStringAsFixed(2)} kWh', style: const TextStyle(color: Colors.white70, fontSize: 11))), if (selected) const Icon(Icons.check_circle, color: green, size: 19)]),
            const SizedBox(height: 10),
            Row(children: [Icon(enoughBattery ? Icons.check_circle_outline : Icons.battery_alert, color: enoughBattery ? green : Colors.orangeAccent, size: 15), const SizedBox(width: 5), Text(enoughBattery ? 'Estimated battery is sufficient' : 'Charging may be required', style: TextStyle(color: enoughBattery ? green : Colors.orangeAccent, fontSize: 10))]),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final availableEnergy = _batteryCapacityKwh * _currentBatteryPercent / 100;
    final activeRoute = _routes.isNotEmpty ? _routes[_selectedRouteIndex] : null;
    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 5,
              child: Stack(
                children: [
                  FlutterMap(
                    mapController: _mapController,
                    options: MapOptions(
                      initialCenter: RoutePlanningSession.mapCenter ?? const LatLng(11.0018, 76.9628),
                      initialZoom: RoutePlanningSession.mapZoom,
                      onTap: _onMapTap,
                      onPositionChanged: (pos, hasGesture) {
                        if (pos.center != null) {
                          RoutePlanningSession.mapCenter = pos.center;
                          RoutePlanningSession.mapZoom = pos.zoom;
                        }
                      },
                    ),
                    children: [
                      TileLayer(urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png', userAgentPackageName: 'com.example.ev_route_optimizer'),
                      PolylineLayer(polylines: [for (int i = 0; i < _routes.length; i++) if (_routes[i].points.length >= 2) Polyline(points: _routes[i].points, color: _routeColors[_routes[i].index % _routeColors.length].withOpacity(i == _selectedRouteIndex ? 1 : 0.55), strokeWidth: i == _selectedRouteIndex ? 5.5 : 4)]),
                      MarkerLayer(markers: [
                        if (_sourcePos != null) Marker(point: _sourcePos!, width: 40, height: 40, child: const Icon(Icons.trip_origin, color: green, size: 30)), 
                        if (_destPos != null) Marker(point: _destPos!, width: 42, height: 42, child: const Icon(Icons.location_on, color: Colors.redAccent, size: 36)),
                        ..._suggestedChargers.map((station) => Marker(point: station.location, width: 30, height: 30, child: const Icon(Icons.bolt, color: Colors.orangeAccent, size: 26))),
                      ]),
                      const RichAttributionWidget(attributions: [TextSourceAttribution('© OpenStreetMap contributors')]),
                    ],
                  ),
                  Positioned(top: 12, left: 14, right: 14, child: Container(padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11), decoration: BoxDecoration(color: bg.withOpacity(0.92), borderRadius: BorderRadius.circular(13), border: Border.all(color: green.withOpacity(0.35))), child: Row(children: [const Icon(Icons.electric_car, color: green, size: 22), const SizedBox(width: 10), const Expanded(child: Text('BATTERY-EFFICIENT ROUTES', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11, letterSpacing: 1))), if (_routes.isNotEmpty) Text('${_routes.length} routes', style: const TextStyle(color: green, fontSize: 11))]))),
                  if (_currentPinMode != PinMode.none) Positioned(bottom: 12, left: 12, right: 12, child: Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: bg.withOpacity(0.95), borderRadius: BorderRadius.circular(12)), child: Text(_currentPinMode == PinMode.source ? 'Tap the map to set the source' : 'Tap the map to set the destination', textAlign: TextAlign.center, style: const TextStyle(color: green, fontWeight: FontWeight.bold)))),
                ],
              ),
            ),
            Expanded(
              flex: 6,
              child: Container(
                decoration: const BoxDecoration(color: bg, borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
                  children: [
                    _buildLocationPanel(),
                    const SizedBox(height: 12),
                    _buildBatteryPanel(availableEnergy),
                    const SizedBox(height: 12),
                    SizedBox(height: 49, child: ElevatedButton.icon(onPressed: _isCalculating ? null : () => _calculateRoutes(), style: ElevatedButton.styleFrom(backgroundColor: green, foregroundColor: bg, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13))), icon: _isCalculating ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(color: bg, strokeWidth: 2)) : const Icon(Icons.alt_route), label: Text(_isCalculating ? 'Analyzing routes & segments...' : 'Analyze Alternative Routes', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)))),
                    
                    if (_error != null) ...[const SizedBox(height: 12), Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: Colors.red.withOpacity(0.10), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.redAccent.withOpacity(0.4))), child: Text(_error!, style: const TextStyle(color: Colors.redAccent, fontSize: 12)))],
                    
                    _buildChargingSuggestions(),

                    if (activeRoute != null) ...[
                      const SizedBox(height: 18), _buildEnvironmentalCard(activeRoute), const SizedBox(height: 18), _sectionTitle('AVAILABLE ROUTES'), const SizedBox(height: 10),
                      for (int i = 0; i < _routes.length; i++) _buildRouteCard(route: _routes[i], selected: i == _selectedRouteIndex, enoughBattery: availableEnergy >= _routes[i].adjustedEnergyKwh, onTap: () { 
                        setState(() => _selectedRouteIndex = i); 
                        RoutePlanningSession.selectedRouteIndex = i; 
                        _checkBatteryAndSuggestChargers(_routes[i]); 
                        final points = _routes[i].points; 
                        if (points.isNotEmpty) { _mapController.move(points[points.length ~/ 2], 9); } 
                      }),
                    ] else if (!_isCalculating && _error == null) ...[const SizedBox(height: 20), const Icon(Icons.route, color: muted, size: 34), const SizedBox(height: 8), const Center(child: Text('Enter your journey and analyze routes', textAlign: TextAlign.center, style: TextStyle(color: muted, fontSize: 12)))],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(color: Color(0xFF0A0F1D), border: Border(top: BorderSide(color: Colors.white10))),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex, onTap: _onBottomNavTapped, backgroundColor: const Color(0xFF0A0F1D), type: BottomNavigationBarType.fixed, selectedItemColor: green, unselectedItemColor: const Color(0xFF535D75), selectedFontSize: 11, unselectedFontSize: 11,
          items: const [BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'Home'), BottomNavigationBarItem(icon: Icon(Icons.alt_route), label: 'Routes'), BottomNavigationBarItem(icon: Icon(Icons.bolt), label: 'Charging'), BottomNavigationBarItem(icon: Icon(Icons.assignment_outlined), activeIcon: Icon(Icons.assignment), label: 'Trips'), BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: 'Profile')],
        ),
      ),
    );
  }
}