// import 'package:flutter/material.dart';

// class TripHistoryScreen extends StatefulWidget {
//   const TripHistoryScreen({super.key});

//   @override
//   State<TripHistoryScreen> createState() => _TripHistoryScreenState();
// }

// class _TripHistoryScreenState extends State<TripHistoryScreen> {
//   // Trips tab index is 3[cite: 10]
//   final int _selectedIndex = 3;

//   // Handles Bottom Navigation Bar Routing between all screens
//   void _onBottomNavTapped(int index) {
//     if (index == _selectedIndex) return; // Already on Trip History[cite: 10]

//     switch (index) {
//       case 0:
//         Navigator.pushReplacementNamed(context, '/dashboard');
//         break;
//       case 1:
//         Navigator.pushReplacementNamed(context, '/route-planning');
//         break;
//       case 2:
//         Navigator.pushReplacementNamed(context, '/charging');
//         break;
//       case 4:
//         Navigator.pushReplacementNamed(context, '/profile');
//         break;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF070B16), // Dark background theme[cite: 10]
//       body: SafeArea(
//         child: Column(
//           children: [
//             Expanded(
//               child: ListView(
//                 padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
//                 children: [
//                   // Header: Title & Total Trips Badge[cite: 10]
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       const Text(
//                         'Trip history',
//                         style: TextStyle(
//                           fontSize: 26,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white,
//                           letterSpacing: -0.5,
//                         ),
//                       ),
//                       Container(
//                         padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
//                         decoration: BoxDecoration(
//                           color: const Color(0xFF12192A),
//                           borderRadius: BorderRadius.circular(16),
//                           border: Border.all(color: Colors.white.withOpacity(0.05)),
//                         ),
//                         child: const Text(
//                           '4 trips',
//                           style: TextStyle(
//                             color: Color(0xFF8692A6),
//                             fontSize: 12,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 20),

//                   // Top Stats Summary: Distance & Energy[cite: 10]
//                   Row(
//                     children: [
//                       Expanded(
//                         child: _buildSummaryCard(
//                           value: '1,177 km',
//                           label: 'Total distance',
//                           valueColor: Colors.white,
//                         ),
//                       ),
//                       const SizedBox(width: 12),
//                       Expanded(
//                         child: _buildSummaryCard(
//                           value: '179.2 kWh',
//                           label: 'Total energy',
//                           valueColor: const Color(0xFF1ECB6B),
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 20),

//                   // Trip Cards[cite: 10]
//                   _buildTripCard(
//                     route: 'Chennai → Coimbatore',
//                     date: 'Today',
//                     distance: '248 km',
//                     energy: '38.2 kWh',
//                     savedPercent: '12% saved',
//                     ecoScore: '92',
//                   ),
//                   const SizedBox(height: 12),
//                   _buildTripCard(
//                     route: 'Coimbatore → Chennai',
//                     date: 'Yesterday',
//                     distance: '241 km',
//                     energy: '36.8 kWh',
//                     savedPercent: '10% saved',
//                     ecoScore: '88',
//                   ),
//                   const SizedBox(height: 12),
//                   _buildTripCard(
//                     route: 'Chennai → Bengaluru',
//                     date: 'Sep 7',
//                     distance: '346 km',
//                     energy: '52.4 kWh',
//                     savedPercent: '8% saved',
//                     ecoScore: '85',
//                   ),
//                   const SizedBox(height: 12),
//                   _buildTripCard(
//                     route: 'Bengaluru → Chennai',
//                     date: 'Sep 5',
//                     distance: '342 km',
//                     energy: '51.8 kWh',
//                     savedPercent: '9% saved',
//                     ecoScore: '87',
//                   ),
//                   const SizedBox(height: 16),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),

//       // Bottom Navigation Bar[cite: 10]
//       bottomNavigationBar: Container(
//         decoration: BoxDecoration(
//           color: const Color(0xFF0A0F1D),
//           border: Border(top: BorderSide(color: Colors.white.withOpacity(0.04))),
//         ),
//         child: BottomNavigationBar(
//           currentIndex: _selectedIndex,
//           onTap: _onBottomNavTapped,
//           backgroundColor: const Color(0xFF0A0F1D),
//           type: BottomNavigationBarType.fixed,
//           selectedItemColor: const Color(0xFF1ECB6B), // Active Trips tab[cite: 10]
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

//   // Summary Stat Cards[cite: 10]
//   Widget _buildSummaryCard({
//     required String value,
//     required String label,
//     required Color valueColor,
//   }) {
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
//       decoration: BoxDecoration(
//         color: const Color(0xFF0F1528),
//         borderRadius: BorderRadius.circular(18),
//         border: Border.all(color: Colors.white.withOpacity(0.04)),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           Text(
//             value,
//             style: TextStyle(
//               fontSize: 22,
//               fontWeight: FontWeight.bold,
//               color: valueColor,
//             ),
//           ),
//           const SizedBox(height: 6),
//           Text(
//             label,
//             style: const TextStyle(
//               fontSize: 12,
//               color: Color(0xFF676E84),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // Individual Trip History Card[cite: 10]
//   Widget _buildTripCard({
//     required String route,
//     required String date,
//     required String distance,
//     required String energy,
//     required String savedPercent,
//     required String ecoScore,
//   }) {
//     return Container(
//       padding: const EdgeInsets.all(18),
//       decoration: BoxDecoration(
//         color: const Color(0xFF0F1528),
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(color: Colors.white.withOpacity(0.04)),
//       ),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Route name[cite: 10]
//                 Text(
//                   route,
//                   style: const TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white,
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 // Date[cite: 10]
//                 Text(
//                   date,
//                   style: const TextStyle(
//                     fontSize: 12,
//                     color: Color(0xFF676E84),
//                   ),
//                 ),
//                 const SizedBox(height: 14),
//                 // Trip metrics row: distance, energy, and saved badge[cite: 10]
//                 Row(
//                   children: [
//                     const Icon(Icons.location_on, color: Color(0xFFFF5376), size: 14),
//                     const SizedBox(width: 4),
//                     Text(
//                       distance,
//                       style: const TextStyle(color: Color(0xFF7E8A9E), fontSize: 12),
//                     ),
//                     const SizedBox(width: 12),
//                     const Icon(Icons.bolt, color: Colors.amber, size: 14),
//                     const SizedBox(width: 4),
//                     Text(
//                       energy,
//                       style: const TextStyle(color: Color(0xFF7E8A9E), fontSize: 12),
//                     ),
//                     const SizedBox(width: 12),
//                     Container(
//                       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
//                       decoration: BoxDecoration(
//                         color: const Color(0xFF1ECB6B).withOpacity(0.12),
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       child: Text(
//                         savedPercent,
//                         style: const TextStyle(
//                           color: Color(0xFF1ECB6B),
//                           fontSize: 11,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(width: 12),
//           // Eco Score Badge on right side[cite: 10]
//           Container(
//             width: 44,
//             height: 44,
//             decoration: BoxDecoration(
//               color: const Color(0xFF0A1E1E),
//               borderRadius: BorderRadius.circular(12),
//               border: Border.all(
//                 color: const Color(0xFF1ECB6B).withOpacity(0.35),
//                 width: 1.2,
//               ),
//             ),
//             child: Center(
//               child: Text(
//                 ecoScore,
//                 style: const TextStyle(
//                   color: Color(0xFF1ECB6B),
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TripHistoryScreen extends StatefulWidget {
  const TripHistoryScreen({super.key});

  @override
  State<TripHistoryScreen> createState() => _TripHistoryScreenState();
}

class _TripHistoryScreenState extends State<TripHistoryScreen> {
  final int _selectedIndex = 3; // Trips tab index

  void _onBottomNavTapped(int index) {
    if (index == _selectedIndex) return;
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/dashboard');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/route-planning');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/charging');
        break;
      case 4:
        Navigator.pushReplacementNamed(context, '/profile');
        break;
    }
  }

  String _formatDate(String isoString) {
    try {
      final date = DateTime.parse(isoString).toLocal();
      final months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
      ];
      final ampm = date.hour >= 12 ? 'PM' : 'AM';
      final hour = date.hour > 12
          ? date.hour - 12
          : (date.hour == 0 ? 12 : date.hour);
      final min = date.minute.toString().padLeft(2, '0');
      return '${date.day} ${months[date.month - 1]} ${date.year}, $hour:$min $ampm';
    } catch (_) {
      return 'Unknown Date';
    }
  }

  String _formatDuration(double minutes) {
    final int hours = minutes.floor() ~/ 60;
    final int mins = minutes.floor() % 60;
    if (hours > 0) return '${hours}h ${mins}m';
    return '${mins}m';
  }

  // Allow users to delete a trip history record
  Future<void> _deleteTrip(String docId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('trips')
          .doc(docId)
          .delete();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Trip deleted.'),
            backgroundColor: Color(0xFF202A3D),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: const Color(0xFF070B16),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            const Padding(
              padding: EdgeInsets.only(left: 24.0, right: 24.0, top: 20.0, bottom: 12.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Trip History',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: -0.5,
                  ),
                ),
              ),
            ),

            // Main List Content
            Expanded(
              child: user == null
                  ? const Center(
                      child: Text(
                        'Please log in to view trips.',
                        style: TextStyle(color: Colors.white70),
                      ),
                    )
                  : StreamBuilder<QuerySnapshot>(
                      // Order by dateTime descending (newest first)
                      stream: FirebaseFirestore.instance
                          .collection('users')
                          .doc(user.uid)
                          .collection('trips')
                          .orderBy('dateTime', descending: true)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(color: Color(0xFF1ECB6B)),
                          );
                        }

                        if (snapshot.hasError) {
                          return Center(
                            child: Text(
                              'Error loading trips.\n${snapshot.error}',
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.redAccent),
                            ),
                          );
                        }

                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.assignment_outlined, size: 64, color: Color(0xFF202B40)),
                                const SizedBox(height: 16),
                                const Text(
                                  'No trips recorded yet.',
                                  style: TextStyle(color: Color(0xFF78829D), fontSize: 16),
                                ),
                                const SizedBox(height: 8),
                                ElevatedButton(
                                  onPressed: () => Navigator.pushReplacementNamed(context, '/route-planning'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF1ECB6B).withOpacity(0.15),
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  ),
                                  child: const Text('Plan a Route', style: TextStyle(color: Color(0xFF1ECB6B))),
                                )
                              ],
                            ),
                          );
                        }

                        final trips = snapshot.data!.docs;

                        return ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                          itemCount: trips.length,
                          itemBuilder: (context, index) {
                            final doc = trips[index];
                            final data = doc.data() as Map<String, dynamic>;

                            final String source = data['source'] ?? 'Unknown Source';
                            final String dest = data['destination'] ?? 'Unknown Destination';
                            final double distance = (data['distanceKm'] ?? 0).toDouble();
                            final double energy = (data['kwhNeeded'] ?? 0).toDouble();
                            final double duration = (data['durationMinutes'] ?? 0).toDouble();
                            final String dateTimeIso = data['dateTime'] ?? '';

                            return _buildTripCard(
                              docId: doc.id,
                              source: source,
                              destination: dest,
                              distanceKm: distance,
                              durationMin: duration,
                              energyKwh: energy,
                              dateTimeIso: dateTimeIso,
                            );
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF0A0F1D),
          border: Border(top: BorderSide(color: Colors.white.withOpacity(0.04))),
        ),
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

  Widget _buildTripCard({
    required String docId,
    required String source,
    required String destination,
    required double distanceKm,
    required double durationMin,
    required double energyKwh,
    required String dateTimeIso,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0E1526),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.04)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _formatDate(dateTimeIso),
                style: const TextStyle(color: Color(0xFF78829D), fontSize: 12, fontWeight: FontWeight.bold),
              ),
              GestureDetector(
                onTap: () => _deleteTrip(docId),
                child: const Icon(Icons.delete_outline, color: Color(0xFF4C556D), size: 18),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  const Icon(Icons.trip_origin, color: Color(0xFF1ECB6B), size: 14),
                  Container(width: 2, height: 24, color: Colors.white12),
                  const Icon(Icons.location_on, color: Colors.redAccent, size: 14),
                ],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      source.replaceAll(', ', '\n'), 
                      style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 18),
                    Text(
                      destination.replaceAll(', ', '\n'), 
                      style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          const Divider(color: Colors.white10, height: 1),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildTripStat(Icons.map, '${distanceKm.toStringAsFixed(1)} km'),
              _buildTripStat(Icons.access_time, _formatDuration(durationMin)),
              _buildTripStat(Icons.bolt, '${energyKwh.toStringAsFixed(1)} kWh'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTripStat(IconData icon, String value) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF78829D), size: 16),
        const SizedBox(width: 6),
        Text(value, style: const TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.bold)),
      ],
    );
  }
}