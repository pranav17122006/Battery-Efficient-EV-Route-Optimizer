
// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// import 'firebase_options.dart';
// import 'screens/home_screen.dart';
// import 'screens/signup_screen.dart';
// import 'screens/login_screen.dart';
// import 'screens/ev_onboarding_screens.dart';
// import 'screens/dashboard_screen.dart';
// import 'screens/route_planning_screen.dart';
// import 'screens/charging_stations_screen.dart';
// import 'screens/trip_history_screen.dart';
// import 'screens/profile_settings_screen.dart';

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   try {
//     await Firebase.initializeApp(
//       options: DefaultFirebaseOptions.currentPlatform,
//     );
//     debugPrint('Firebase initialized successfully!');
//   } catch (e) {
//     debugPrint('Firebase initialization failed: $e');
//   }

//   runApp(const EVNavigationApp());
// }

// class EVNavigationApp extends StatelessWidget {
//   const EVNavigationApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Intelligent EV Navigation',
//       debugShowCheckedModeBanner: false,

//       theme: ThemeData.dark().copyWith(
//         scaffoldBackgroundColor: const Color(0xFF070B16),
//         primaryColor: const Color(0xFF1ECB6B),
//         colorScheme: const ColorScheme.dark(
//           primary: Color(0xFF1ECB6B),
//           surface: Color(0xFF070B16),
//         ),
//       ),

//       initialRoute: '/',

//       routes: {
//         '/': (context) => const HomeScreen(),
//         '/signup': (context) => const SignUpScreen(),
//         '/login': (context) => const LoginScreen(),
//         '/ev-onboarding': (context) => const EVOnboardingScreen(),
//         '/dashboard': (context) => const DashboardScreen(),
//         '/route-planning': (context) => const RoutePlanningScreen(),
//         '/charging': (context) => const ChargingStationsScreen(),
//         '/trips': (context) => const TripHistoryScreen(),
//         '/profile': (context) => const ProfileSettingsScreen(),
//       },
//     );
//   }
// }

// // Firestore helper functions
// class FirestoreService {
//   static final FirebaseFirestore _db = FirebaseFirestore.instance;

//   // Save a document to Firestore
//   static Future<String> addData({
//     required String collection,
//     required Map<String, dynamic> data,
//   }) async {
//     final docRef = await _db.collection(collection).add({
//       ...data,
//       'createdAt': FieldValue.serverTimestamp(),
//     });

//     return docRef.id;
//   }

//   // Read all documents from a collection
//   static Future<List<Map<String, dynamic>>> getData({
//     required String collection,
//   }) async {
//     final snapshot = await _db.collection(collection).get();

//     return snapshot.docs.map((doc) {
//       return {
//         'id': doc.id,
//         ...doc.data(),
//       };
//     }).toList();
//   }

//   // Update an existing document
//   static Future<void> updateData({
//     required String collection,
//     required String documentId,
//     required Map<String, dynamic> data,
//   }) async {
//     await _db.collection(collection).doc(documentId).update(data);
//   }

//   // Delete a document
//   static Future<void> deleteData({
//     required String collection,
//     required String documentId,
//   }) async {
//     await _db.collection(collection).doc(documentId).delete();
//   }

//   // Listen for real-time collection updates
//   static Stream<QuerySnapshot<Map<String, dynamic>>> watchData({
//     required String collection,
//   }) {
//     return _db.collection(collection).snapshots();
//   }
// }






import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'firebase_options.dart';
import 'screens/home_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/login_screen.dart';
import 'screens/ev_onboarding_screens.dart';
import 'screens/dashboard_screen.dart';
import 'screens/route_planning_screen.dart';
import 'screens/charging_stations_screen.dart';
import 'screens/trip_history_screen.dart';
import 'screens/profile_settings_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const EVNavigationApp());
}

class EVNavigationApp extends StatelessWidget {
  const EVNavigationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Intelligent EV Navigation',
      debugShowCheckedModeBanner: false,

      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF070B16),
        primaryColor: const Color(0xFF1ECB6B),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF1ECB6B),
          surface: Color(0xFF070B16),
        ),
      ),

      // Authentication state determines the initial screen.
      home: const AuthGate(),

      routes: {
        '/home': (context) => const HomeScreen(),
        '/signup': (context) => const SignUpScreen(),
        '/login': (context) => const LoginScreen(),
        '/ev-onboarding': (context) => const EVOnboardingScreen(),
        '/dashboard': (context) => const DashboardScreen(),
        '/route-planning': (context) => const RoutePlanningScreen(),
        '/charging': (context) => const ChargingStationsScreen(),
        '/trips': (context) => const TripHistoryScreen(),
        '/profile': (context) => const ProfileSettingsScreen(),
      },
    );
  }
}

/// Shows the correct screen according to the Firebase login session.
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: Color(0xFF070B16),
            body: Center(
              child: CircularProgressIndicator(
                color: Color(0xFF1ECB6B),
              ),
            ),
          );
        }

        if (snapshot.hasError) {
          return const Scaffold(
            backgroundColor: Color(0xFF070B16),
            body: Center(
              child: Text(
                'Unable to check login status. Please restart the app.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white),
              ),
            ),
          );
        }

        final User? user = snapshot.data;

        if (user != null) {
          // Already signed in: open the dashboard directly.
          return const DashboardScreen();
        }

        // Not signed in: ask the user to log in.
        return const LoginScreen();
      },
    );
  }
}

/// Firestore helper functions.
class FirestoreService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Save a document to Firestore.
  static Future<String> addData({
    required String collection,
    required Map<String, dynamic> data,
  }) async {
    final docRef = await _db.collection(collection).add({
      ...data,
      'createdAt': FieldValue.serverTimestamp(),
    });

    return docRef.id;
  }

  /// Read all documents from a collection.
  static Future<List<Map<String, dynamic>>> getData({
    required String collection,
  }) async {
    final snapshot = await _db.collection(collection).get();

    return snapshot.docs.map((doc) {
      return {
        'id': doc.id,
        ...doc.data(),
      };
    }).toList();
  }

  /// Update an existing document.
  static Future<void> updateData({
    required String collection,
    required String documentId,
    required Map<String, dynamic> data,
  }) async {
    await _db.collection(collection).doc(documentId).update(data);
  }

  /// Delete a document.
  static Future<void> deleteData({
    required String collection,
    required String documentId,
  }) async {
    await _db.collection(collection).doc(documentId).delete();
  }

  /// Listen for real-time collection updates.
  static Stream<QuerySnapshot<Map<String, dynamic>>> watchData({
    required String collection,
  }) {
    return _db.collection(collection).snapshots();
  }
}

/// Call this function from your logout button.
Future<void> logout(BuildContext context) async {
  try {
    await FirebaseAuth.instance.signOut();

    if (!context.mounted) return;

    Navigator.of(context).pushNamedAndRemoveUntil(
      '/login',
      (route) => false,
    );
  } catch (e) {
    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Logout failed: $e'),
      ),
    );
  }
}




// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:latlong2/latlong.dart';
// import 'package:http/http.dart' as http;

// void main() => runApp(const EVRouteApp());

// class EVRouteApp extends StatelessWidget {
//   const EVRouteApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'EV Route Optimizer',
//       theme: ThemeData(
//         brightness: Brightness.dark,
//         scaffoldBackgroundColor: const Color(0xFF101510),
//         colorScheme: ColorScheme.fromSeed(
//           seedColor: const Color(0xFF45E06F),
//           brightness: Brightness.dark,
//         ),
//         useMaterial3: true,
//       ),
//       home: const RouteScreen(),
//     );
//   }
// }

// class RouteScreen extends StatefulWidget {
//   const RouteScreen({super.key});

//   @override
//   State<RouteScreen> createState() => _RouteScreenState();
// }

// class _RouteScreenState extends State<RouteScreen> {
//   // Android emulator: use 10.0.2.2, not localhost.
//   static const String apiBase = 'http://192.168.137.1:8000';

//   final sourceController =
//       TextEditingController(text: 'Coimbatore');
//   final destinationController =
//       TextEditingController(text: 'Chennai');

//   final mapController = MapController();

//   bool loading = false;
//   String? error;
//   List<Map<String, dynamic>> routes = [];
//   Map<String, dynamic>? source;
//   Map<String, dynamic>? destination;
//   int selectedIndex = 0;

//   final List<Color> routeColors = const [
//     Color(0xFF45E06F),
//     Color(0xFF42B7FF),
//     Color(0xFFFFB74D),
//     Color(0xFFE879F9),
//     Color(0xFFFF6B6B),
//   ];

//   @override
//   void dispose() {
//     sourceController.dispose();
//     destinationController.dispose();
//     mapController.dispose();
//     super.dispose();
//   }

//   double number(dynamic value) {
//     if (value is num) return value.toDouble();
//     return double.tryParse('$value') ?? 0;
//   }

//   Future<void> findRoutes() async {
//     final from = sourceController.text.trim();
//     final to = destinationController.text.trim();

//     if (from.isEmpty || to.isEmpty) {
//       setState(() => error = 'Enter both source and destination.');
//       return;
//     }

//     FocusScope.of(context).unfocus();

//     setState(() {
//       loading = true;
//       error = null;
//       routes = [];
//     });

//     try {
//       final response = await http
//           .post(
//             Uri.parse('$apiBase/routes'),
//             headers: {'Content-Type': 'application/json'},
//             body: jsonEncode({
//               'source': {'name': from},
//               'destination': {'name': to},
//               'alternatives': 3,
//               'consumption_kwh_per_100km': 16,
//             }),
//           )
//           .timeout(const Duration(seconds: 60));

//       if (response.statusCode != 200) {
//         throw Exception(
//           'API returned ${response.statusCode}: ${response.body}',
//         );
//       }

//       final data = jsonDecode(response.body)
//           as Map<String, dynamic>;

//       final rawRoutes = data['routes'] as List? ?? [];

//       final parsedRoutes = rawRoutes
//           .whereType<Map>()
//           .map((r) => Map<String, dynamic>.from(r))
//           .where((r) => r['geometry'] is Map)
//           .toList();

//       if (parsedRoutes.isEmpty) {
//         throw Exception('No routes returned. Try another journey.');
//       }

//       parsedRoutes.sort((a, b) => number(
//             a['estimated_energy_kwh'],
//           ).compareTo(number(b['estimated_energy_kwh'])));

//       if (!mounted) return;

//       setState(() {
//         source = data['source'] is Map
//             ? Map<String, dynamic>.from(data['source'])
//             : null;
//         destination = data['destination'] is Map
//             ? Map<String, dynamic>.from(data['destination'])
//             : null;
//         routes = parsedRoutes;
//         selectedIndex = 0;
//       });

//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         if (mounted) fitRoutesOnMap();
//       });
//     } catch (e) {
//       if (mounted) {
//         setState(() => error = e.toString());
//       }
//     } finally {
//       if (mounted) setState(() => loading = false);
//     }
//   }

//   List<LatLng> routePoints(Map<String, dynamic> route) {
//     final geometry = route['geometry'];
//     if (geometry is! Map) return [];

//     final coordinates = geometry['coordinates'];
//     if (coordinates is! List) return [];

//     // GeoJSON uses [longitude, latitude], not [latitude, longitude].
//     return coordinates
//         .whereType<List>()
//         .where((c) => c.length >= 2)
//         .map((c) => LatLng(
//               number(c[1]),
//               number(c[0]),
//             ))
//         .where((p) =>
//             p.latitude.isFinite &&
//             p.longitude.isFinite &&
//             p.latitude >= -90 &&
//             p.latitude <= 90 &&
//             p.longitude >= -180 &&
//             p.longitude <= 180)
//         .toList();
//   }

//   LatLng? placePoint(Map<String, dynamic>? place) {
//     if (place == null) return null;

//     final lat = number(place['lat']);
//     final lon = number(place['lon']);

//     if (!lat.isFinite ||
//         !lon.isFinite ||
//         lat < -90 || lat > 90 ||
//         lon < -180 || lon > 180 ||
//         (lat == 0 && lon == 0)) {
//       return null;
//     }

//     return LatLng(lat, lon);
//   }

//   void fitRoutesOnMap() {
//     final allPoints = <LatLng>[
//       for (final route in routes) ...routePoints(route),
//     ];

//     if (allPoints.isEmpty) return;

//     var minLat = allPoints.first.latitude;
//     var maxLat = minLat;
//     var minLon = allPoints.first.longitude;
//     var maxLon = minLon;

//     for (final p in allPoints) {
//       if (p.latitude < minLat) minLat = p.latitude;
//       if (p.latitude > maxLat) maxLat = p.latitude;
//       if (p.longitude < minLon) minLon = p.longitude;
//       if (p.longitude > maxLon) maxLon = p.longitude;
//     }

//     // Avoid zero-size bounds for a very short route.
//     if (minLat == maxLat) {
//       minLat -= 0.005;
//       maxLat += 0.005;
//     }
//     if (minLon == maxLon) {
//       minLon -= 0.005;
//       maxLon += 0.005;
//     }

//     try {
//       mapController.fitCamera(
//         CameraFit.bounds(
//           bounds: LatLngBounds(
//             LatLng(minLat, minLon),
//             LatLng(maxLat, maxLon),
//           ),
//           padding: const EdgeInsets.all(36),
//         ),
//       );
//     } catch (_) {
//       // The map may not be ready yet; the default view remains usable.
//     }
//   }

//   String fmt(dynamic value, int decimals) =>
//       number(value).toStringAsFixed(decimals);

//   @override
//   Widget build(BuildContext context) {
//     final bestEnergy = routes.isEmpty
//         ? 0.0
//         : routes.map((r) => number(r['estimated_energy_kwh']))
//             .reduce((a, b) => a < b ? a : b);

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'EV Route Optimizer',
//           style: TextStyle(fontWeight: FontWeight.bold),
//         ),
//         actions: const [
//           Padding(
//             padding: EdgeInsets.only(right: 16),
//             child: Icon(Icons.electric_car, color: Color(0xFF45E06F)),
//           ),
//         ],
//       ),
//       body: SafeArea(
//         child: Column(
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(12),
//               child: Column(
//                 children: [
//                   TextField(
//                     controller: sourceController,
//                     textInputAction: TextInputAction.next,
//                     decoration: const InputDecoration(
//                       labelText: 'Source location',
//                       prefixIcon: Icon(Icons.trip_origin),
//                       border: OutlineInputBorder(),
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   TextField(
//                     controller: destinationController,
//                     textInputAction: TextInputAction.done,
//                     onSubmitted: (_) => findRoutes(),
//                     decoration: const InputDecoration(
//                       labelText: 'Destination',
//                       prefixIcon: Icon(Icons.location_on),
//                       border: OutlineInputBorder(),
//                     ),
//                   ),
//                   const SizedBox(height: 10),
//                   SizedBox(
//                     width: double.infinity,
//                     child: FilledButton.icon(
//                       onPressed: loading ? null : findRoutes,
//                       icon: loading
//                           ? const SizedBox(
//                               width: 18,
//                               height: 18,
//                               child: CircularProgressIndicator(
//                                 strokeWidth: 2,
//                               ),
//                             )
//                           : const Icon(Icons.alt_route),
//                       label: Text(
//                         loading ? 'Finding routes...' : 'Find Best Routes',
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             if (error != null)
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 12),
//                 child: Text(
//                   error!,
//                   style: const TextStyle(color: Colors.redAccent),
//                 ),
//               ),
//             Expanded(
//               child: FlutterMap(
//                 mapController: mapController,
//                 options: const MapOptions(
//                   initialCenter: LatLng(11.0018, 76.9628),
//                   initialZoom: 6,
//                 ),
//                 children: [
//                   TileLayer(
//                     urlTemplate:
//                         'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
//                     userAgentPackageName: 'com.example.ev_route_optimizer',
//                   ),
//                   PolylineLayer(
//                     polylines: [
//                       for (var i = 0; i < routes.length; i++)
//                         if (routePoints(routes[i]).length >= 2)
//                           Polyline(
//                             points: routePoints(routes[i]),
//                             color: routeColors[i % routeColors.length]
//                                 .withValues(
//                                   alpha: i == selectedIndex ? 1 : 0.55,
//                                 ),
//                             strokeWidth: i == selectedIndex ? 6 : 4,
//                           ),
//                     ],
//                   ),
//                   MarkerLayer(
//                     markers: [
//                       if (placePoint(source) != null)
//                         Marker(
//                           point: placePoint(source)!,
//                           width: 42,
//                           height: 42,
//                           child: const Icon(
//                             Icons.trip_origin,
//                             color: Color(0xFF45E06F),
//                             size: 34,
//                           ),
//                         ),
//                       if (placePoint(destination) != null)
//                         Marker(
//                           point: placePoint(destination)!,
//                           width: 42,
//                           height: 42,
//                           child: const Icon(
//                             Icons.location_on,
//                             color: Colors.redAccent,
//                             size: 38,
//                           ),
//                         ),
//                     ],
//                   ),
//                   RichAttributionWidget(
//                     attributions: [
//                       TextSourceAttribution('© OpenStreetMap contributors'),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             Container(
//               height: 245,
//               padding: const EdgeInsets.fromLTRB(12, 10, 12, 6),
//               child: routes.isEmpty
//                   ? const Center(
//                       child: Text(
//                         'Enter locations and tap Find Best Routes',
//                         textAlign: TextAlign.center,
//                       ),
//                     )
//                   : Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           children: [
//                             const Expanded(
//                               child: Text(
//                                 'Alternative Routes',
//                                 style: TextStyle(
//                                   fontSize: 18,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ),
//                             Text('${routes.length} found'),
//                           ],
//                         ),
//                         const SizedBox(height: 8),
//                         Expanded(
//                           child: ListView.builder(
//                             itemCount: routes.length,
//                             itemBuilder: (context, index) {
//                               final r = routes[index];
//                               final energy =
//                                   number(r['estimated_energy_kwh']);
//                               final distance = number(r['distance_km']);
//                               final duration =
//                                   number(r['duration_minutes']);
//                               final best = energy == bestEnergy;

//                               return Card(
//                                 color: index == selectedIndex
//                                     ? const Color(0xFF203323)
//                                     : const Color(0xFF1A201A),
//                                 child: ListTile(
//                                   onTap: () {
//                                     setState(() => selectedIndex = index);
//                                   },
//                                   leading: Icon(
//                                     Icons.route,
//                                     color: routeColors[
//                                         index % routeColors.length],
//                                     size: 30,
//                                   ),
//                                   title: Row(
//                                     children: [
//                                       Expanded(
//                                         child: Text(
//                                           'Route ${index + 1}',
//                                           style: const TextStyle(
//                                             fontWeight: FontWeight.bold,
//                                           ),
//                                         ),
//                                       ),
//                                       if (best)
//                                         const Text(
//                                           'LOWEST ENERGY',
//                                           style: TextStyle(
//                                             color: Color(0xFF45E06F),
//                                             fontSize: 10,
//                                             fontWeight: FontWeight.bold,
//                                           ),
//                                         ),
//                                     ],
//                                   ),
//                                   subtitle: Text(
//                                     '${fmt(distance, 1)} km  •  '
//                                     '${(duration / 60).floor()}h '
//                                     '${(duration % 60).round()}m\n'
//                                     '${fmt(energy, 2)} kWh estimated',
//                                   ),
//                                   isThreeLine: true,
//                                   trailing: index == selectedIndex
//                                       ? const Icon(
//                                           Icons.check_circle,
//                                           color: Color(0xFF45E06F),
//                                         )
//                                       : null,
//                                 ),
//                               );
//                             },
//                           ),
//                         ),
//                       ],
//                     ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
