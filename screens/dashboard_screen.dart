// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class DashboardScreen extends StatefulWidget {
//   const DashboardScreen({super.key});

//   @override
//   State<DashboardScreen> createState() => _DashboardScreenState();
// }

// class _DashboardScreenState extends State<DashboardScreen> {
//   final int _selectedIndex = 0;

//   void _onItemTapped(int index) {
//     if (index == _selectedIndex) return;
//     switch (index) {
//       case 1: Navigator.pushReplacementNamed(context, '/route-planning'); break;
//       case 2: Navigator.pushReplacementNamed(context, '/charging'); break;
//       case 3: Navigator.pushReplacementNamed(context, '/trips'); break;
//       case 4: Navigator.pushReplacementNamed(context, '/profile'); break;
//     }
//   }

//   void _logout() {
//     showDialog(
//       context: context,
//       builder: (ctx) => AlertDialog(
//         backgroundColor: const Color(0xFF101728),
//         title: const Text('Log Out', style: TextStyle(color: Colors.white)),
//         content: const Text('Are you sure you want to log out and return to the home screen?', style: TextStyle(color: Color(0xFF8D98AF))),
//         actions: [
//           TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel', style: TextStyle(color: Color(0xFF676E84)))),
//           ElevatedButton(
//             style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
//             onPressed: () async {
//               Navigator.pop(ctx);
//               await FirebaseAuth.instance.signOut();
//               if (mounted) Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
//             },
//             child: const Text('Log Out', style: TextStyle(color: Colors.white)),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF070B16),
//       body: SafeArea(
//         child: _buildHomeDashboardTab(),
//       ),
//       bottomNavigationBar: Container(
//         decoration: BoxDecoration(
//           color: const Color(0xFF0A0F1D),
//           border: Border(top: BorderSide(color: Colors.white.withOpacity(0.04))),
//         ),
//         child: BottomNavigationBar(
//           currentIndex: _selectedIndex,
//           onTap: _onItemTapped,
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

//   Widget _buildHomeDashboardTab() {
//     final user = FirebaseAuth.instance.currentUser;
//     if (user == null) {
//       return const Center(child: Text('User not authenticated.', style: TextStyle(color: Colors.white)));
//     }

//     String displayName = (user.displayName != null && user.displayName!.isNotEmpty) 
//         ? user.displayName! 
//         : 'EV Driver';

//     return StreamBuilder<DocumentSnapshot>(
//       stream: FirebaseFirestore.instance.collection('users').doc(user.uid).snapshots(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Center(child: CircularProgressIndicator(color: Color(0xFF1ECB6B)));
//         }

//         if (snapshot.hasError || !snapshot.hasData || !snapshot.data!.exists) {
//           return const Center(child: Text('No vehicle data found.\nPlease complete onboarding.', textAlign: TextAlign.center, style: TextStyle(color: Colors.white70)));
//         }

//         final data = snapshot.data!.data() as Map<String, dynamic>;
//         final String vehicleBrand = data['vehicleBrand'] ?? 'Unknown';
//         final String vehicleModel = data['vehicleModel'] ?? 'Vehicle';
//         final double batteryCapacityKwh = (data['batteryCapacityKwh'] ?? 75.0).toDouble();
//         final double avgConsumption = (data['avgConsumption'] ?? 15.0).toDouble();

//         // Calculate max possible range for full battery
//         int maxRange = avgConsumption > 0 ? ((batteryCapacityKwh / avgConsumption) * 100).round() : 0;

//         return SingleChildScrollView(
//           padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Header
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           children: const [
//                             Text('Good morning', style: TextStyle(color: Color(0xFF676E84), fontSize: 13)),
//                             SizedBox(width: 4),
//                             Text('👋', style: TextStyle(fontSize: 13)),
//                           ],
//                         ),
//                         const SizedBox(height: 4),
//                         Text(
//                           displayName, 
//                           style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                       ],
//                     ),
//                   ),
//                   Row(
//                     children: [
//                       Container(
//                         width: 40,
//                         height: 40,
//                         decoration: const BoxDecoration(color: Color(0xFF101728), shape: BoxShape.circle),
//                         child: const Icon(Icons.person, color: Color(0xFF6A4CEB), size: 22),
//                       ),
//                       const SizedBox(width: 8),
//                       IconButton(icon: const Icon(Icons.logout, color: Colors.white70, size: 22), tooltip: 'Logout', onPressed: _logout),
//                     ],
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 20),

//               // Vehicle Status Card
//               Container(
//                 padding: const EdgeInsets.all(20),
//                 decoration: BoxDecoration(color: const Color(0xFF0F1528), borderRadius: BorderRadius.circular(22), border: Border.all(color: Colors.white.withOpacity(0.04))),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             const Text('Your vehicle', style: TextStyle(color: Color(0xFF676E84), fontSize: 12)),
//                             const SizedBox(height: 4),
//                             Text('$vehicleBrand $vehicleModel', style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
//                           ],
//                         ),
//                         const Text('🚗', style: TextStyle(fontSize: 32)),
//                       ],
//                     ),
//                     const SizedBox(height: 16),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.end,
//                       children: [
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.end,
//                           children: [
//                             Text(
//                               '$maxRange km',
//                               style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
//                             ),
//                             const SizedBox(height: 2),
//                             const Text('max estimated range', style: TextStyle(color: Color(0xFF676E84), fontSize: 11)),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 24),

//               // Three Quick Actions
//               Row(
//                 children: [
//                   Expanded(child: _buildActionShortcut(icon: const Icon(Icons.map, color: Colors.blueAccent, size: 24), label: 'Plan Route', onTap: () => _onItemTapped(1))),
//                   const SizedBox(width: 10),
//                   Expanded(child: _buildActionShortcut(icon: const Icon(Icons.bolt, color: Colors.amber, size: 24), label: 'Find Charger', onTap: () => _onItemTapped(2))),
//                   const SizedBox(width: 10),
//                   Expanded(child: _buildActionShortcut(icon: const Icon(Icons.assignment, color: Colors.orangeAccent, size: 24), label: 'Trips', onTap: () => _onItemTapped(3))),
//                 ],
//               ),
//               const SizedBox(height: 32),

//               // Recent Trips Header
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   const Text('Recent trips', style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold)),
//                   GestureDetector(
//                     onTap: () => _onItemTapped(3),
//                     child: const Text('See all', style: TextStyle(color: Color(0xFF1ECB6B), fontSize: 13, fontWeight: FontWeight.bold)),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 12),

//               _buildTripCard(fromTo: 'Chennai → Coimbatore', distance: '248 km', duration: '3h 38m', energy: '38.2 kWh'),
//               const SizedBox(height: 10),
//               _buildTripCard(fromTo: 'Coimbatore → Chennai', distance: '241 km', duration: '3h 31m', energy: '36.8 kWh'),
//               const SizedBox(height: 10),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   // ================= HELPER WIDGETS =================
//   Widget _buildActionShortcut({required Widget icon, required String label, required VoidCallback onTap}) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: const EdgeInsets.symmetric(vertical: 14),
//         decoration: BoxDecoration(color: const Color(0xFF0F1528), borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.white.withOpacity(0.04))),
//         child: Column(
//           children: [
//             icon,
//             const SizedBox(height: 8),
//             Text(label, style: const TextStyle(color: Color(0xFF909BB3), fontSize: 12, fontWeight: FontWeight.w600)),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildTripCard({required String fromTo, required String distance, required String duration, required String energy}) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(color: const Color(0xFF0F1528), borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.white.withOpacity(0.04))),
//       child: Column(
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(fromTo, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
//               Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
//                 decoration: BoxDecoration(color: const Color(0xFF1ECB6B).withOpacity(0.12), borderRadius: BorderRadius.circular(20)),
//                 child: const Text('Completed', style: TextStyle(color: Color(0xFF1ECB6B), fontSize: 11, fontWeight: FontWeight.w600)),
//               ),
//             ],
//           ),
//           const SizedBox(height: 12),
//           Row(
//             children: [
//               const Icon(Icons.location_on, color: Colors.redAccent, size: 14),
//               const SizedBox(width: 4),
//               Text(distance, style: const TextStyle(color: Color(0xFF676E84), fontSize: 12)),
//               const SizedBox(width: 14),
//               const Icon(Icons.access_time, color: Color(0xFF676E84), size: 14),
//               const SizedBox(width: 4),
//               Text(duration, style: const TextStyle(color: Color(0xFF676E84), fontSize: 12)),
//               const SizedBox(width: 14),
//               const Icon(Icons.bolt, color: Colors.amber, size: 14),
//               const SizedBox(width: 4),
//               Text(energy, style: const TextStyle(color: Color(0xFF676E84), fontSize: 12)),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final int _selectedIndex = 0;

  void _onItemTapped(int index) {
    if (index == _selectedIndex) return;
    switch (index) {
      case 1: Navigator.pushReplacementNamed(context, '/route-planning'); break;
      case 2: Navigator.pushReplacementNamed(context, '/charging'); break;
      case 3: Navigator.pushReplacementNamed(context, '/trips'); break;
      case 4: Navigator.pushReplacementNamed(context, '/profile'); break;
    }
  }

  void _logout() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF101728),
        title: const Text('Log Out', style: TextStyle(color: Colors.white)),
        content: const Text('Are you sure you want to log out and return to the home screen?', style: TextStyle(color: Color(0xFF8D98AF))),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel', style: TextStyle(color: Color(0xFF676E84)))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () async {
              Navigator.pop(ctx);
              await FirebaseAuth.instance.signOut();
              if (mounted) Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
            },
            child: const Text('Log Out', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
  
  String _formatDuration(double minutes) {
    final int hours = minutes.floor() ~/ 60;
    final int mins = minutes.floor() % 60;
    if (hours > 0) return '${hours}h ${mins}m';
    return '${mins}m';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF070B16),
      body: SafeArea(
        child: _buildHomeDashboardTab(),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF0A0F1D),
          border: Border(top: BorderSide(color: Colors.white.withOpacity(0.04))),
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
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

  Widget _buildHomeDashboardTab() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const Center(child: Text('User not authenticated.', style: TextStyle(color: Colors.white)));
    }

    String displayName = (user.displayName != null && user.displayName!.isNotEmpty) 
        ? user.displayName! 
        : 'EV Driver';

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance.collection('users').doc(user.uid).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(color: Color(0xFF1ECB6B)));
        }

        if (snapshot.hasError || !snapshot.hasData || !snapshot.data!.exists) {
          return const Center(child: Text('No vehicle data found.\nPlease complete onboarding.', textAlign: TextAlign.center, style: TextStyle(color: Colors.white70)));
        }

        final data = snapshot.data!.data() as Map<String, dynamic>;
        final String vehicleBrand = data['vehicleBrand'] ?? 'Unknown';
        final String vehicleModel = data['vehicleModel'] ?? 'Vehicle';
        final double batteryCapacityKwh = (data['batteryCapacityKwh'] ?? 75.0).toDouble();
        final double avgConsumption = (data['avgConsumption'] ?? 15.0).toDouble();

        // Calculate max possible range for full battery
        int maxRange = avgConsumption > 0 ? ((batteryCapacityKwh / avgConsumption) * 100).round() : 0;

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: const [
                            Text('Good morning', style: TextStyle(color: Color(0xFF676E84), fontSize: 13)),
                            SizedBox(width: 4),
                            Text('👋', style: TextStyle(fontSize: 13)),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          displayName, 
                          style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(color: Color(0xFF101728), shape: BoxShape.circle),
                        child: const Icon(Icons.person, color: Color(0xFF6A4CEB), size: 22),
                      ),
                      const SizedBox(width: 8),
                      IconButton(icon: const Icon(Icons.logout, color: Colors.white70, size: 22), tooltip: 'Logout', onPressed: _logout),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Vehicle Status Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(color: const Color(0xFF0F1528), borderRadius: BorderRadius.circular(22), border: Border.all(color: Colors.white.withOpacity(0.04))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Your vehicle', style: TextStyle(color: Color(0xFF676E84), fontSize: 12)),
                            const SizedBox(height: 4),
                            Text('$vehicleBrand $vehicleModel', style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const Text('🚗', style: TextStyle(fontSize: 32)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '$maxRange km',
                              style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 2),
                            const Text('max estimated range', style: TextStyle(color: Color(0xFF676E84), fontSize: 11)),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Three Quick Actions
              Row(
                children: [
                  Expanded(child: _buildActionShortcut(icon: const Icon(Icons.map, color: Colors.blueAccent, size: 24), label: 'Plan Route', onTap: () => _onItemTapped(1))),
                  const SizedBox(width: 10),
                  Expanded(child: _buildActionShortcut(icon: const Icon(Icons.bolt, color: Colors.amber, size: 24), label: 'Find Charger', onTap: () => _onItemTapped(2))),
                  const SizedBox(width: 10),
                  Expanded(child: _buildActionShortcut(icon: const Icon(Icons.assignment, color: Colors.orangeAccent, size: 24), label: 'Trips', onTap: () => _onItemTapped(3))),
                ],
              ),
              const SizedBox(height: 32),

              // Recent Trips Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Recent trips', style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold)),
                  GestureDetector(
                    onTap: () => _onItemTapped(3),
                    child: const Text('See all', style: TextStyle(color: Color(0xFF1ECB6B), fontSize: 13, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Dynamic Recent Trips List
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(user.uid)
                    .collection('trips')
                    .orderBy('dateTime', descending: true)
                    .limit(3)
                    .snapshots(),
                builder: (context, tripSnapshot) {
                  if (tripSnapshot.connectionState == ConnectionState.waiting) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Center(child: CircularProgressIndicator(color: Color(0xFF1ECB6B))),
                    );
                  }
                  
                  if (!tripSnapshot.hasData || tripSnapshot.data!.docs.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Center(
                        child: Text('No trips recorded yet.', style: TextStyle(color: Color(0xFF676E84))),
                      ),
                    );
                  }

                  final trips = tripSnapshot.data!.docs;
                  
                  return Column(
                    children: trips.map((doc) {
                      final tripData = doc.data() as Map<String, dynamic>;
                      final source = tripData['source'] ?? 'Unknown';
                      final dest = tripData['destination'] ?? 'Unknown';
                      final distance = (tripData['distanceKm'] ?? 0).toDouble();
                      final duration = (tripData['durationMinutes'] ?? 0).toDouble();
                      final energy = (tripData['kwhNeeded'] ?? 0).toDouble();
                      
                      final fromTo = '${source.split(',')[0]} → ${dest.split(',')[0]}';
                      
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _buildTripCard(
                          fromTo: fromTo,
                          distance: '${distance.toStringAsFixed(1)} km',
                          duration: _formatDuration(duration),
                          energy: '${energy.toStringAsFixed(1)} kWh',
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  // ================= HELPER WIDGETS =================
  Widget _buildActionShortcut({required Widget icon, required String label, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(color: const Color(0xFF0F1528), borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.white.withOpacity(0.04))),
        child: Column(
          children: [
            icon,
            const SizedBox(height: 8),
            Text(label, style: const TextStyle(color: Color(0xFF909BB3), fontSize: 12, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  Widget _buildTripCard({required String fromTo, required String distance, required String duration, required String energy}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: const Color(0xFF0F1528), borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.white.withOpacity(0.04))),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(fromTo, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14), overflow: TextOverflow.ellipsis),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(color: const Color(0xFF1ECB6B).withOpacity(0.12), borderRadius: BorderRadius.circular(20)),
                child: const Text('Completed', style: TextStyle(color: Color(0xFF1ECB6B), fontSize: 11, fontWeight: FontWeight.w600)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.location_on, color: Colors.redAccent, size: 14),
              const SizedBox(width: 4),
              Text(distance, style: const TextStyle(color: Color(0xFF676E84), fontSize: 12)),
              const SizedBox(width: 14),
              const Icon(Icons.access_time, color: Color(0xFF676E84), size: 14),
              const SizedBox(width: 4),
              Text(duration, style: const TextStyle(color: Color(0xFF676E84), fontSize: 12)),
              const SizedBox(width: 14),
              const Icon(Icons.bolt, color: Colors.amber, size: 14),
              const SizedBox(width: 4),
              Text(energy, style: const TextStyle(color: Color(0xFF676E84), fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }
}