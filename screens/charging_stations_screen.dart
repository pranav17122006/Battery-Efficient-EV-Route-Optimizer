

// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:geolocator/geolocator.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:latlong2/latlong.dart';

// class ChargingStation {
//   final String id;
//   final String name;
//   final LatLng location;
//   final double distanceKm;
//   final String operator;
//   final String capacity;
//   final String powerInfo;

//   ChargingStation({
//     required this.id,
//     required this.name,
//     required this.location,
//     required this.distanceKm,
//     required this.operator,
//     required this.capacity,
//     required this.powerInfo,
//   });
// }

// class ChargingStationsScreen extends StatefulWidget {
//   const ChargingStationsScreen({super.key});

//   @override
//   State<ChargingStationsScreen> createState() => _ChargingStationsScreenState();
// }

// class _ChargingStationsScreenState extends State<ChargingStationsScreen> {
//   // ===========================================================================
//   // IMPORTANT: PASTE YOUR OPEN CHARGE MAP API KEY HERE
//   // ===========================================================================
//   static const String ocmApiKey = '5934eb89-eb4b-4884-85ba-71732e01b3ff';
  
//   final int _selectedIndex = 2; // Charging tab
//   final MapController _mapController = MapController();
//   final PageController _pageController = PageController(viewportFraction: 0.85);

//   // Locations & Search State
//   LatLng? _userGpsPosition;
//   LatLng? _searchCenterPosition;
//   bool _isPinningMode = false;
//   String _centerLabel = 'Locating GPS...';

//   // API & Data States
//   bool _isLoading = true;
//   String _statusMessage = 'Initializing map...';
//   List<ChargingStation> _stations = [];
//   int _selectedCardIndex = 0;

//   @override
//   void initState() {
//     super.initState();
//     _initCurrentLocation();
//   }

//   @override
//   void dispose() {
//     _pageController.dispose();
//     super.dispose();
//   }

//   void _onBottomNavTapped(int index) {
//     if (index == _selectedIndex) return;
//     switch (index) {
//       case 0:
//         Navigator.pushReplacementNamed(context, '/dashboard');
//         break;
//       case 1:
//         Navigator.pushReplacementNamed(context, '/route-planning');
//         break;
//       case 3:
//         Navigator.pushReplacementNamed(context, '/trips');
//         break;
//       case 4:
//         Navigator.pushReplacementNamed(context, '/profile');
//         break;
//     }
//   }

//   // 1. Acquire Device GPS Location
//   Future<void> _initCurrentLocation() async {
//     setState(() {
//       _isLoading = true;
//       _isPinningMode = false;
//       _statusMessage = 'Acquiring GPS location...';
//     });

//     try {
//       bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//       if (!serviceEnabled) {
//         throw Exception('Location services are turned off.');
//       }

//       LocationPermission permission = await Geolocator.checkPermission();
//       if (permission == LocationPermission.denied) {
//         permission = await Geolocator.requestPermission();
//         if (permission == LocationPermission.denied) {
//           throw Exception('Location permission was denied.');
//         }
//       }
//       if (permission == LocationPermission.deniedForever) {
//         await Geolocator.openAppSettings();
//         throw Exception('Location permission is permanently denied. Please enable it in Settings.');
//       }

//       Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high,
//       );

//       final gpsLocation = LatLng(position.latitude, position.longitude);

//       setState(() {
//         _userGpsPosition = gpsLocation;
//         _searchCenterPosition = gpsLocation;
//         _centerLabel = 'Near Current Location';
//       });

//       _mapController.move(gpsLocation, 12.0);
//       await _fetchStationsFromOCM(gpsLocation);
//     } catch (e) {
//       setState(() {
//         _isLoading = false;
//         _statusMessage = e.toString().replaceAll('Exception: ', '');
//       });
//     }
//   }

//   // 2. Fetch Stations from OpenChargeMap API (25 km Radius)
//   Future<void> _fetchStationsFromOCM(LatLng center) async {
//     if (ocmApiKey == 'YOUR_OPEN_CHARGE_MAP_API_KEY') {
//       setState(() {
//         _isLoading = false;
//         _statusMessage = 'Please enter your OpenChargeMap API Key in the code.';
//       });
//       return;
//     }

//     setState(() {
//       _isLoading = true;
//       _statusMessage = 'Searching stations within 25 km...';
//       _stations.clear();
//       _selectedCardIndex = 0;
//     });

//     try {
//       // OpenChargeMap POI endpoint
//       final url = Uri.parse(
//         'https://api.openchargemap.io/v3/poi?key=$ocmApiKey&latitude=${center.latitude}&longitude=${center.longitude}&distance=25&distanceunit=KM&maxresults=50&compact=true&verbose=false'
//       );

//       final response = await http.get(url, headers: {
//         'User-Agent': 'EVRouteOptimizerApp/1.0',
//       }).timeout(const Duration(seconds: 20));

//       if (response.statusCode != 200) {
//         throw Exception('API Error: ${response.statusCode}');
//       }

//       final List<dynamic> data = json.decode(response.body);
//       List<ChargingStation> parsedStations = [];

//       for (var el in data) {
//         final address = el['AddressInfo'];
//         if (address == null) continue;

//         final double? lat = (address['Latitude'] as num?)?.toDouble();
//         final double? lon = (address['Longitude'] as num?)?.toDouble();
        
//         if (lat == null || lon == null) continue;

//         // Calculate direct distance
//         final double distanceMeters = Geolocator.distanceBetween(
//           center.latitude, center.longitude, lat, lon,
//         );

//         // Parse Connector Info
//         int plugCount = 0;
//         double maxPowerKw = 0.0;
        
//         if (el['Connections'] != null) {
//           for (var conn in el['Connections']) {
//             plugCount += (conn['Quantity'] as num?)?.toInt() ?? 1;
//             final power = (conn['PowerKW'] as num?)?.toDouble() ?? 0.0;
//             if (power > maxPowerKw) maxPowerKw = power;
//           }
//         }

//         parsedStations.add(
//           ChargingStation(
//             id: el['ID'].toString(),
//             name: address['Title'] ?? 'EV Charging Station',
//             location: LatLng(lat, lon),
//             distanceKm: distanceMeters / 1000.0,
//             operator: el['OperatorInfo']?['Title'] ?? 'Unknown Operator',
//             capacity: plugCount > 0 ? '$plugCount Plugs' : 'Standard Port',
//             powerInfo: maxPowerKw > 0 ? 'Max ${maxPowerKw.toStringAsFixed(0)} kW' : 'Power Unknown',
//           ),
//         );
//       }

//       // Sort nearest to furthest
//       parsedStations.sort((a, b) => a.distanceKm.compareTo(b.distanceKm));

//       setState(() {
//         _stations = parsedStations;
//         _isLoading = false;
//         if (_stations.isEmpty) {
//           _statusMessage = 'No charging stations found within 25 km.';
//         }
//       });

//       // Fit map bounds
//       if (_stations.isNotEmpty) {
//         final boundsPoints = [
//           center,
//           ..._stations.take(6).map((s) => s.location),
//         ];
//         final bounds = LatLngBounds.fromPoints(boundsPoints);
//         _mapController.fitCamera(
//           CameraFit.bounds(bounds: bounds, padding: const EdgeInsets.all(60)),
//         );
//       }
//     } catch (e) {
//       setState(() {
//         _isLoading = false;
//         _statusMessage = 'Failed to load OpenChargeMap data. Check connection or API key.';
//       });
//     }
//   }

//   // 3. Map Tap Event Handler for Pin Placement
//   void _onMapTap(TapPosition tapPosition, LatLng point) {
//     if (!_isPinningMode) return;

//     setState(() {
//       _isPinningMode = false;
//       _searchCenterPosition = point;
//       _centerLabel = 'Pinned: ${point.latitude.toStringAsFixed(3)}, ${point.longitude.toStringAsFixed(3)}';
//     });

//     _mapController.move(point, 12.0);
//     _fetchStationsFromOCM(point);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF070B16),
//       body: SafeArea(
//         child: Stack(
//           children: [
//             // ================= 1. NATIVE MAP VIEW =================
//             FlutterMap(
//               mapController: _mapController,
//               options: MapOptions(
//                 initialCenter: _searchCenterPosition ?? const LatLng(20.5937, 78.9629),
//                 initialZoom: 11.0,
//                 onTap: _onMapTap,
//               ),
//               children: [
//                 TileLayer(
//                   urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
//                   userAgentPackageName: 'com.example.ev_route_optimizer',
//                 ),

//                 MarkerLayer(
//                   markers: [
//                     // A. Blue Pulse Marker for True Device GPS
//                     if (_userGpsPosition != null)
//                       Marker(
//                         point: _userGpsPosition!,
//                         width: 44,
//                         height: 44,
//                         child: Stack(
//                           alignment: Alignment.center,
//                           children: [
//                             Container(width: 36, height: 36, decoration: BoxDecoration(color: Colors.blueAccent.withOpacity(0.25), shape: BoxShape.circle)),
//                             Container(width: 16, height: 16, decoration: BoxDecoration(color: Colors.blueAccent, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2.5))),
//                           ],
//                         ),
//                       ),

//                     // B. Custom Placed Pin Marker (Orange Ring Marker)
//                     if (_searchCenterPosition != null && _searchCenterPosition != _userGpsPosition)
//                       Marker(
//                         point: _searchCenterPosition!,
//                         width: 48,
//                         height: 48,
//                         child: const Icon(Icons.location_pin, color: Colors.deepOrangeAccent, size: 42),
//                       ),

//                     // C. EV Station Pins (Green Lightning)
//                     for (int i = 0; i < _stations.length; i++)
//                       Marker(
//                         point: _stations[i].location,
//                         width: 44,
//                         height: 44,
//                         child: GestureDetector(
//                           onTap: () {
//                             setState(() => _selectedCardIndex = i);
//                             _pageController.animateToPage(
//                               i, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut,
//                             );
//                             _mapController.move(_stations[i].location, 14.5);
//                           },
//                           child: Container(
//                             decoration: BoxDecoration(
//                               color: _selectedCardIndex == i ? const Color(0xFF1ECB6B) : const Color(0xFF101728),
//                               shape: BoxShape.circle,
//                               border: Border.all(
//                                 color: _selectedCardIndex == i ? Colors.white : const Color(0xFF1ECB6B), width: 2.5,
//                               ),
//                               boxShadow: const [BoxShadow(color: Colors.black54, blurRadius: 6, offset: Offset(0, 3))],
//                             ),
//                             child: Icon(
//                               Icons.bolt,
//                               color: _selectedCardIndex == i ? const Color(0xFF070B16) : const Color(0xFF1ECB6B), size: 22,
//                             ),
//                           ),
//                         ),
//                       ),
//                   ],
//                 ),
//               ],
//             ),

//             // ================= 2. TOP ACTION BAR =================
//             Positioned(
//               top: 14,
//               left: 16,
//               right: 16,
//               child: Column(
//                 children: [
//                   Row(
//                     children: [
//                       // Back Button
//                       Container(
//                         decoration: BoxDecoration(
//                           color: const Color(0xFF070B16).withOpacity(0.9),
//                           borderRadius: BorderRadius.circular(14),
//                           border: Border.all(color: Colors.white.withOpacity(0.08)),
//                         ),
//                         child: IconButton(
//                           icon: const Icon(Icons.arrow_back_ios_new, size: 18, color: Colors.white),
//                           onPressed: () => Navigator.pushReplacementNamed(context, '/dashboard'),
//                         ),
//                       ),
//                       const SizedBox(width: 10),

//                       // Location & Status Pill
//                       Expanded(
//                         child: Container(
//                           height: 48,
//                           padding: const EdgeInsets.symmetric(horizontal: 14),
//                           decoration: BoxDecoration(
//                             color: const Color(0xFF0E1526).withOpacity(0.95),
//                             borderRadius: BorderRadius.circular(14),
//                             border: Border.all(color: Colors.white.withOpacity(0.08)),
//                           ),
//                           child: Row(
//                             children: [
//                               Icon(
//                                 _searchCenterPosition == _userGpsPosition ? Icons.my_location : Icons.pin_drop,
//                                 color: const Color(0xFF1ECB6B), size: 18,
//                               ),
//                               const SizedBox(width: 10),
//                               Expanded(
//                                 child: Text(
//                                   _isLoading ? 'Scanning 25 km radius...' : '$_centerLabel (${_stations.length} found)',
//                                   style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600),
//                                   overflow: TextOverflow.ellipsis,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 10),

//                   // Mode Selector: "Place Pin on Map" vs "Use My GPS"
//                   Row(
//                     children: [
//                       Expanded(
//                         child: ElevatedButton.icon(
//                           onPressed: () => setState(() => _isPinningMode = !_isPinningMode),
//                           icon: Icon(Icons.add_location_alt_outlined, size: 16, color: _isPinningMode ? const Color(0xFF070B16) : Colors.white),
//                           label: Text(
//                             _isPinningMode ? 'Tap Map to Place' : 'Drop Pin on Map',
//                             style: TextStyle(color: _isPinningMode ? const Color(0xFF070B16) : Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
//                           ),
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: _isPinningMode ? const Color(0xFF1ECB6B) : const Color(0xFF0E1526).withOpacity(0.9),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(12),
//                               side: BorderSide(color: _isPinningMode ? const Color(0xFF1ECB6B) : Colors.white.withOpacity(0.08)),
//                             ),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(width: 8),
//                       Expanded(
//                         child: OutlinedButton.icon(
//                           onPressed: _initCurrentLocation,
//                           icon: const Icon(Icons.gps_fixed, size: 16, color: Color(0xFF1ECB6B)),
//                           label: const Text('Use My GPS', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
//                           style: OutlinedButton.styleFrom(
//                             backgroundColor: const Color(0xFF0E1526).withOpacity(0.9),
//                             side: BorderSide(color: Colors.white.withOpacity(0.08)),
//                             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),

//             // ================= 3. PINNING INSTRUCTION TOAST =================
//             if (_isPinningMode)
//               Positioned(
//                 top: 130,
//                 left: 24,
//                 right: 24,
//                 child: Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//                   decoration: BoxDecoration(
//                     color: const Color(0xFF1ECB6B),
//                     borderRadius: BorderRadius.circular(30),
//                     boxShadow: const [BoxShadow(color: Colors.black45, blurRadius: 10, offset: Offset(0, 4))],
//                   ),
//                   child: const Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(Icons.touch_app, color: Color(0xFF070B16), size: 18),
//                       SizedBox(width: 8),
//                       Text('Tap anywhere on the map to search 25 km around it', style: TextStyle(color: Color(0xFF070B16), fontSize: 12, fontWeight: FontWeight.bold)),
//                     ],
//                   ),
//                 ),
//               ),

//             // ================= 4. LOADING / EMPTY OVERLAY =================
//             if (_isLoading || _stations.isEmpty)
//               Positioned(
//                 bottom: 30,
//                 left: 20,
//                 right: 20,
//                 child: Container(
//                   padding: const EdgeInsets.all(20),
//                   decoration: BoxDecoration(
//                     color: const Color(0xFF0E1526).withOpacity(0.95),
//                     borderRadius: BorderRadius.circular(18),
//                     border: Border.all(color: Colors.white.withOpacity(0.08)),
//                   ),
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       if (_isLoading) const CircularProgressIndicator(color: Color(0xFF1ECB6B))
//                       else const Icon(Icons.bolt, color: Colors.amber, size: 38),
//                       const SizedBox(height: 14),
//                       Text(
//                         _statusMessage,
//                         textAlign: TextAlign.center,
//                         style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
//                       ),
//                       if (!_isLoading) ...[
//                         const SizedBox(height: 14),
//                         ElevatedButton.icon(
//                           onPressed: () {
//                             if (_searchCenterPosition != null) {
//                               _fetchStationsFromOCM(_searchCenterPosition!);
//                             } else {
//                               _initCurrentLocation();
//                             }
//                           },
//                           icon: const Icon(Icons.refresh, size: 16, color: Color(0xFF070B16)),
//                           label: const Text('Try Again', style: TextStyle(color: Color(0xFF070B16), fontWeight: FontWeight.bold)),
//                           style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1ECB6B)),
//                         )
//                       ],
//                     ],
//                   ),
//                 ),
//               ),

//             // ================= 5. SWIPEABLE CHARGING STATION CARDS =================
//             if (!_isLoading && _stations.isNotEmpty)
//               Positioned(
//                 bottom: 20,
//                 left: 0,
//                 right: 0,
//                 height: 154,
//                 child: PageView.builder(
//                   controller: _pageController,
//                   itemCount: _stations.length,
//                   onPageChanged: (index) {
//                     setState(() => _selectedCardIndex = index);
//                     _mapController.move(_stations[index].location, 14.5);
//                   },
//                   itemBuilder: (context, index) {
//                     final station = _stations[index];
//                     final isSelected = _selectedCardIndex == index;

//                     return Container(
//                       margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                       padding: const EdgeInsets.all(16),
//                       decoration: BoxDecoration(
//                         color: const Color(0xFF0E1526).withOpacity(0.95),
//                         borderRadius: BorderRadius.circular(20),
//                         border: Border.all(
//                           color: isSelected ? const Color(0xFF1ECB6B) : Colors.white.withOpacity(0.08),
//                           width: isSelected ? 1.5 : 1,
//                         ),
//                         boxShadow: const [BoxShadow(color: Colors.black45, blurRadius: 10, offset: Offset(0, 4))],
//                       ),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Expanded(
//                                 child: Text(
//                                   station.name,
//                                   style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
//                                   maxLines: 1, overflow: TextOverflow.ellipsis,
//                                 ),
//                               ),
//                               Container(
//                                 padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
//                                 decoration: BoxDecoration(color: const Color(0xFF102E20), borderRadius: BorderRadius.circular(8)),
//                                 child: Text(
//                                   '${station.distanceKm.toStringAsFixed(1)} km away',
//                                   style: const TextStyle(color: Color(0xFF1ECB6B), fontSize: 11, fontWeight: FontWeight.bold),
//                                 ),
//                               ),
//                             ],
//                           ),
//                           const SizedBox(height: 6),
//                           Text(station.operator, style: const TextStyle(color: Color(0xFF676E84), fontSize: 13)),
//                           const Spacer(),
//                           const Divider(color: Colors.white12, height: 1),
//                           const Spacer(),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Row(
//                                 children: [
//                                   const Icon(Icons.ev_station, color: Colors.amber, size: 16),
//                                   const SizedBox(width: 6),
//                                   Text('${station.capacity} • ${station.powerInfo}', style: const TextStyle(color: Colors.white70, fontSize: 11)),
//                                 ],
//                               ),
//                               GestureDetector(
//                                 onTap: () => Navigator.pushReplacementNamed(context, '/route-planning'),
//                                 child: const Row(
//                                   children: [
//                                     Text('Plan Route', style: TextStyle(color: Color(0xFF1ECB6B), fontWeight: FontWeight.bold, fontSize: 13)),
//                                     SizedBox(width: 4),
//                                     Icon(Icons.arrow_forward_ios, size: 12, color: Color(0xFF1ECB6B)),
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     );
//                   },
//                 ),
//               ),
//           ],
//         ),
//       ),

//       // Bottom Navigation Bar
//       bottomNavigationBar: Container(
//         decoration: BoxDecoration(color: const Color(0xFF0A0F1D), border: Border(top: BorderSide(color: Colors.white.withOpacity(0.04)))),
//         child: BottomNavigationBar(
//           currentIndex: _selectedIndex,
//           onTap: _onBottomNavTapped,
//           backgroundColor: const Color(0xFF0A0F1D),
//           type: BottomNavigationBarType.fixed,
//           selectedItemColor: const Color(0xFF1ECB6B),
//           unselectedItemColor: const Color(0xFF535D75),
//           selectedFontSize: 11,
//           unselectedFontSize: 11,
//           items: const [
//             BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'Home'),
//             BottomNavigationBarItem(icon: Icon(Icons.alt_route), label: 'Routes'),
//             BottomNavigationBarItem(icon: Icon(Icons.bolt), label: 'Charging'),
//             BottomNavigationBarItem(icon: Icon(Icons.assignment_outlined), activeIcon: Icon(Icons.assignment), label: 'Trips'),
//             BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: 'Profile'),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class ChargingStation {
  final String id;
  final String name;
  final LatLng location;
  final double distanceKm;
  final String operator;
  final String capacity;
  final String powerInfo;

  ChargingStation({
    required this.id,
    required this.name,
    required this.location,
    required this.distanceKm,
    required this.operator,
    required this.capacity,
    required this.powerInfo,
  });
}

// ================= PERSISTENT APP SESSION CACHE =================
// Lives in memory to prevent the page from resetting when changing tabs.
class ChargingSession {
  static bool hasInitialized = false;
  static LatLng? userGpsPosition;
  static LatLng? searchCenterPosition;
  static String centerLabel = 'Locating GPS...';
  static List<ChargingStation> stations = [];
  static int selectedCardIndex = 0;
  static LatLng? mapCenter;
  static double mapZoom = 11.0;
}

class ChargingStationsScreen extends StatefulWidget {
  const ChargingStationsScreen({super.key});

  @override
  State<ChargingStationsScreen> createState() => _ChargingStationsScreenState();
}

class _ChargingStationsScreenState extends State<ChargingStationsScreen> {
  // ===========================================================================
  // IMPORTANT: PASTE YOUR OPEN CHARGE MAP API KEY HERE
  // ===========================================================================
  static const String ocmApiKey = '5934eb89-eb4b-4884-85ba-71732e01b3ff';
  
  final int _selectedIndex = 2; // Charging tab
  final MapController _mapController = MapController();
  final PageController _pageController = PageController(viewportFraction: 0.85);

  // Locations & Search State
  LatLng? _userGpsPosition;
  LatLng? _searchCenterPosition;
  bool _isPinningMode = false;
  String _centerLabel = 'Locating GPS...';

  // API & Data States
  bool _isLoading = true;
  String _statusMessage = 'Initializing map...';
  List<ChargingStation> _stations = [];
  int _selectedCardIndex = 0;

  @override
  void initState() {
    super.initState();
    
    // Restore state if we previously visited this page during the app session
    if (ChargingSession.hasInitialized) {
      _userGpsPosition = ChargingSession.userGpsPosition;
      _searchCenterPosition = ChargingSession.searchCenterPosition;
      _centerLabel = ChargingSession.centerLabel;
      _stations = List.from(ChargingSession.stations);
      _selectedCardIndex = ChargingSession.selectedCardIndex;
      _isLoading = false;
      _statusMessage = '';

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        if (ChargingSession.mapCenter != null) {
          _mapController.move(ChargingSession.mapCenter!, ChargingSession.mapZoom);
        }
        // Jump to the previously selected card without animating on startup
        if (_stations.isNotEmpty && _pageController.hasClients) {
          _pageController.jumpToPage(_selectedCardIndex);
        }
      });
    } else {
      _initCurrentLocation();
    }
  }

  @override
  void dispose() {
    _syncToSession();
    _pageController.dispose();
    super.dispose();
  }

  void _syncToSession() {
    ChargingSession.hasInitialized = true;
    ChargingSession.userGpsPosition = _userGpsPosition;
    ChargingSession.searchCenterPosition = _searchCenterPosition;
    ChargingSession.centerLabel = _centerLabel;
    ChargingSession.stations = _stations;
    ChargingSession.selectedCardIndex = _selectedCardIndex;
  }

  void _onBottomNavTapped(int index) {
    if (index == _selectedIndex) return;
    _syncToSession(); // Save state before leaving

    switch (index) {
      case 0: Navigator.pushReplacementNamed(context, '/dashboard'); break;
      case 1: Navigator.pushReplacementNamed(context, '/route-planning'); break;
      case 3: Navigator.pushReplacementNamed(context, '/trips'); break;
      case 4: Navigator.pushReplacementNamed(context, '/profile'); break;
    }
  }

  Future<void> _initCurrentLocation() async {
    setState(() {
      _isLoading = true;
      _isPinningMode = false;
      _statusMessage = 'Acquiring GPS location...';
    });

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) throw Exception('Location services are turned off.');

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) throw Exception('Location permission was denied.');
      }
      if (permission == LocationPermission.deniedForever) {
        await Geolocator.openAppSettings();
        throw Exception('Location permission is permanently denied. Please enable it in Settings.');
      }

      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      final gpsLocation = LatLng(position.latitude, position.longitude);

      setState(() {
        _userGpsPosition = gpsLocation;
        _searchCenterPosition = gpsLocation;
        _centerLabel = 'Near Current Location';
      });

      _mapController.move(gpsLocation, 12.0);
      await _fetchStationsFromOCM(gpsLocation);
    } catch (e) {
      setState(() {
        _isLoading = false;
        _statusMessage = e.toString().replaceAll('Exception: ', '');
      });
    }
  }

  Future<void> _fetchStationsFromOCM(LatLng center) async {
    if (ocmApiKey == 'YOUR_OPEN_CHARGE_MAP_API_KEY') {
      setState(() {
        _isLoading = false;
        _statusMessage = 'Please enter your OpenChargeMap API Key in the code.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _statusMessage = 'Searching stations within 25 km...';
      _stations.clear();
      _selectedCardIndex = 0;
    });

    try {
      final url = Uri.parse(
        'https://api.openchargemap.io/v3/poi?key=$ocmApiKey&latitude=${center.latitude}&longitude=${center.longitude}&distance=25&distanceunit=KM&maxresults=50&compact=true&verbose=false'
      );

      final response = await http.get(url, headers: {'User-Agent': 'EVRouteOptimizerApp/1.0'})
          .timeout(const Duration(seconds: 20));

      if (response.statusCode != 200) throw Exception('API Error: ${response.statusCode}');

      final List<dynamic> data = json.decode(response.body);
      List<ChargingStation> parsedStations = [];

      for (var el in data) {
        final address = el['AddressInfo'];
        if (address == null) continue;

        final double? lat = (address['Latitude'] as num?)?.toDouble();
        final double? lon = (address['Longitude'] as num?)?.toDouble();
        
        if (lat == null || lon == null) continue;

        final double distanceMeters = Geolocator.distanceBetween(center.latitude, center.longitude, lat, lon);

        int plugCount = 0;
        double maxPowerKw = 0.0;
        if (el['Connections'] != null) {
          for (var conn in el['Connections']) {
            plugCount += (conn['Quantity'] as num?)?.toInt() ?? 1;
            final power = (conn['PowerKW'] as num?)?.toDouble() ?? 0.0;
            if (power > maxPowerKw) maxPowerKw = power;
          }
        }

        parsedStations.add(ChargingStation(
          id: el['ID'].toString(),
          name: address['Title'] ?? 'EV Charging Station',
          location: LatLng(lat, lon),
          distanceKm: distanceMeters / 1000.0,
          operator: el['OperatorInfo']?['Title'] ?? 'Unknown Operator',
          capacity: plugCount > 0 ? '$plugCount Plugs' : 'Standard Port',
          powerInfo: maxPowerKw > 0 ? 'Max ${maxPowerKw.toStringAsFixed(0)} kW' : 'Power Unknown',
        ));
      }

      parsedStations.sort((a, b) => a.distanceKm.compareTo(b.distanceKm));

      setState(() {
        _stations = parsedStations;
        _isLoading = false;
        if (_stations.isEmpty) _statusMessage = 'No charging stations found within 25 km.';
      });

      if (_stations.isNotEmpty) {
        final boundsPoints = [center, ..._stations.take(6).map((s) => s.location)];
        final bounds = LatLngBounds.fromPoints(boundsPoints);
        _mapController.fitCamera(CameraFit.bounds(bounds: bounds, padding: const EdgeInsets.all(60)));
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _statusMessage = 'Failed to load OpenChargeMap data. Check connection or API key.';
      });
    }
  }

  void _onMapTap(TapPosition tapPosition, LatLng point) {
    if (!_isPinningMode) return;

    setState(() {
      _isPinningMode = false;
      _searchCenterPosition = point;
      _centerLabel = 'Pinned: ${point.latitude.toStringAsFixed(3)}, ${point.longitude.toStringAsFixed(3)}';
    });

    _mapController.move(point, 12.0);
    _fetchStationsFromOCM(point);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF070B16),
      body: SafeArea(
        child: Stack(
          children: [
            FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: _searchCenterPosition ?? const LatLng(20.5937, 78.9629),
                initialZoom: ChargingSession.mapZoom,
                onTap: _onMapTap,
                onPositionChanged: (pos, hasGesture) {
                  if (pos.center != null) {
                    ChargingSession.mapCenter = pos.center;
                    ChargingSession.mapZoom = pos.zoom;
                  }
                },
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.ev_route_optimizer',
                ),

                MarkerLayer(
                  markers: [
                    if (_userGpsPosition != null)
                      Marker(
                        point: _userGpsPosition!,
                        width: 44,
                        height: 44,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(width: 36, height: 36, decoration: BoxDecoration(color: Colors.blueAccent.withOpacity(0.25), shape: BoxShape.circle)),
                            Container(width: 16, height: 16, decoration: BoxDecoration(color: Colors.blueAccent, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2.5))),
                          ],
                        ),
                      ),

                    if (_searchCenterPosition != null && _searchCenterPosition != _userGpsPosition)
                      Marker(
                        point: _searchCenterPosition!,
                        width: 48,
                        height: 48,
                        child: const Icon(Icons.location_pin, color: Colors.deepOrangeAccent, size: 42),
                      ),

                    for (int i = 0; i < _stations.length; i++)
                      Marker(
                        point: _stations[i].location,
                        width: 44,
                        height: 44,
                        child: GestureDetector(
                          onTap: () {
                            setState(() => _selectedCardIndex = i);
                            _pageController.animateToPage(i, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
                            _mapController.move(_stations[i].location, 14.5);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: _selectedCardIndex == i ? const Color(0xFF1ECB6B) : const Color(0xFF101728),
                              shape: BoxShape.circle,
                              border: Border.all(color: _selectedCardIndex == i ? Colors.white : const Color(0xFF1ECB6B), width: 2.5),
                              boxShadow: const [BoxShadow(color: Colors.black54, blurRadius: 6, offset: Offset(0, 3))],
                            ),
                            child: Icon(Icons.bolt, color: _selectedCardIndex == i ? const Color(0xFF070B16) : const Color(0xFF1ECB6B), size: 22),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),

            Positioned(
              top: 14,
              left: 16,
              right: 16,
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF070B16).withOpacity(0.9),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: Colors.white.withOpacity(0.08)),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back_ios_new, size: 18, color: Colors.white),
                          onPressed: () => Navigator.pushReplacementNamed(context, '/dashboard'),
                        ),
                      ),
                      const SizedBox(width: 10),

                      Expanded(
                        child: Container(
                          height: 48,
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          decoration: BoxDecoration(
                            color: const Color(0xFF0E1526).withOpacity(0.95),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: Colors.white.withOpacity(0.08)),
                          ),
                          child: Row(
                            children: [
                              Icon(_searchCenterPosition == _userGpsPosition ? Icons.my_location : Icons.pin_drop, color: const Color(0xFF1ECB6B), size: 18),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  _isLoading ? 'Scanning 25 km radius...' : '$_centerLabel (${_stations.length} found)',
                                  style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => setState(() => _isPinningMode = !_isPinningMode),
                          icon: Icon(Icons.add_location_alt_outlined, size: 16, color: _isPinningMode ? const Color(0xFF070B16) : Colors.white),
                          label: Text(
                            _isPinningMode ? 'Tap Map to Place' : 'Drop Pin on Map',
                            style: TextStyle(color: _isPinningMode ? const Color(0xFF070B16) : Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _isPinningMode ? const Color(0xFF1ECB6B) : const Color(0xFF0E1526).withOpacity(0.9),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: _isPinningMode ? const Color(0xFF1ECB6B) : Colors.white.withOpacity(0.08))),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _initCurrentLocation,
                          icon: const Icon(Icons.gps_fixed, size: 16, color: Color(0xFF1ECB6B)),
                          label: const Text('Use My GPS', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                          style: OutlinedButton.styleFrom(
                            backgroundColor: const Color(0xFF0E1526).withOpacity(0.9),
                            side: BorderSide(color: Colors.white.withOpacity(0.08)),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            if (_isPinningMode)
              Positioned(
                top: 130,
                left: 24,
                right: 24,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1ECB6B),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: const [BoxShadow(color: Colors.black45, blurRadius: 10, offset: Offset(0, 4))],
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.touch_app, color: Color(0xFF070B16), size: 18),
                      SizedBox(width: 8),
                      Text('Tap anywhere on the map to search 25 km around it', style: TextStyle(color: Color(0xFF070B16), fontSize: 12, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),

            if (_isLoading || _stations.isEmpty)
              Positioned(
                bottom: 30,
                left: 20,
                right: 20,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0E1526).withOpacity(0.95),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: Colors.white.withOpacity(0.08)),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (_isLoading) const CircularProgressIndicator(color: Color(0xFF1ECB6B))
                      else const Icon(Icons.bolt, color: Colors.amber, size: 38),
                      const SizedBox(height: 14),
                      Text(_statusMessage, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
                      if (!_isLoading) ...[
                        const SizedBox(height: 14),
                        ElevatedButton.icon(
                          onPressed: () {
                            if (_searchCenterPosition != null) _fetchStationsFromOCM(_searchCenterPosition!);
                            else _initCurrentLocation();
                          },
                          icon: const Icon(Icons.refresh, size: 16, color: Color(0xFF070B16)),
                          label: const Text('Try Again', style: TextStyle(color: Color(0xFF070B16), fontWeight: FontWeight.bold)),
                          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1ECB6B)),
                        )
                      ],
                    ],
                  ),
                ),
              ),

            if (!_isLoading && _stations.isNotEmpty)
              Positioned(
                bottom: 20,
                left: 0,
                right: 0,
                height: 154,
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _stations.length,
                  onPageChanged: (index) {
                    setState(() => _selectedCardIndex = index);
                    _mapController.move(_stations[index].location, 14.5);
                  },
                  itemBuilder: (context, index) {
                    final station = _stations[index];
                    final isSelected = _selectedCardIndex == index;

                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0E1526).withOpacity(0.95),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected ? const Color(0xFF1ECB6B) : Colors.white.withOpacity(0.08),
                          width: isSelected ? 1.5 : 1,
                        ),
                        boxShadow: const [BoxShadow(color: Colors.black45, blurRadius: 10, offset: Offset(0, 4))],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  station.name,
                                  style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
                                  maxLines: 1, overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(color: const Color(0xFF102E20), borderRadius: BorderRadius.circular(8)),
                                child: Text(
                                  '${station.distanceKm.toStringAsFixed(1)} km away',
                                  style: const TextStyle(color: Color(0xFF1ECB6B), fontSize: 11, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(station.operator, style: const TextStyle(color: Color(0xFF676E84), fontSize: 13)),
                          const Spacer(),
                          const Divider(color: Colors.white12, height: 1),
                          const Spacer(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.ev_station, color: Colors.amber, size: 16),
                                  const SizedBox(width: 6),
                                  Text('${station.capacity} • ${station.powerInfo}', style: const TextStyle(color: Colors.white70, fontSize: 11)),
                                ],
                              ),
                              GestureDetector(
                                onTap: () {
                                  _syncToSession(); // Save this screen state before leaving!
                                  
                                  // Navigating to Route Planning and sending the coordinates
                                  Navigator.pushReplacementNamed(
                                    context, 
                                    '/route-planning',
                                    arguments: {
                                      'autoCalculate': true,
                                      'sourcePos': _searchCenterPosition ?? _userGpsPosition,
                                      'sourceName': 'Current Location',
                                      'destPos': station.location,
                                      'destName': station.name,
                                    },
                                  );
                                },
                                child: const Row(
                                  children: [
                                    Text('Plan Route', style: TextStyle(color: Color(0xFF1ECB6B), fontWeight: FontWeight.bold, fontSize: 13)),
                                    SizedBox(width: 4),
                                    Icon(Icons.arrow_forward_ios, size: 12, color: Color(0xFF1ECB6B)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),

      bottomNavigationBar: Container(
        decoration: BoxDecoration(color: const Color(0xFF0A0F1D), border: Border(top: BorderSide(color: Colors.white.withOpacity(0.04)))),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onBottomNavTapped,
          backgroundColor: const Color(0xFF0A0F1D),
          type: BottomNavigationBarType.fixed,
          selectedItemColor: const Color(0xFF1ECB6B),
          unselectedItemColor: const Color(0xFF535D75),
          selectedFontSize: 11,
          unselectedFontSize: 11,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.alt_route), label: 'Routes'),
            BottomNavigationBarItem(icon: Icon(Icons.bolt), label: 'Charging'),
            BottomNavigationBarItem(icon: Icon(Icons.assignment_outlined), activeIcon: Icon(Icons.assignment), label: 'Trips'),
            BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: 'Profile'),
          ],
        ),
      ),
    );
  }
}