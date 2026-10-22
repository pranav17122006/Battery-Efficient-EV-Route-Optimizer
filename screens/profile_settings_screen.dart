
// // import 'package:flutter/material.dart';

// // class ProfileSettingsScreen extends StatefulWidget {
// //   const ProfileSettingsScreen({super.key});

// //   @override
// //   State<ProfileSettingsScreen> createState() => _ProfileSettingsScreenState();
// // }

// // class _ProfileSettingsScreenState extends State<ProfileSettingsScreen> {
// //   // Profile tab is index 4[cite: 11]
// //   final int _selectedIndex = 4;

// //   // Handles Bottom Navigation Bar Routing
// //   void _onBottomNavTapped(int index) {
// //     if (index == _selectedIndex) return; // Already on Profile Settings

// //     switch (index) {
// //       case 0:
// //         Navigator.pushReplacementNamed(context, '/dashboard');
// //         break;
// //       case 1:
// //         Navigator.pushReplacementNamed(context, '/route-planning');
// //         break;
// //       case 2:
// //         Navigator.pushReplacementNamed(context, '/charging');
// //         break;
// //       case 3:
// //         Navigator.pushReplacementNamed(context, '/trips');
// //         break;
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       backgroundColor: const Color(0xFF070B16), // Deep dark background[cite: 11]
// //       body: SafeArea(
// //         child: Column(
// //           children: [
// //             // Fixed Header
// //             const Padding(
// //               padding: EdgeInsets.only(left: 24.0, right: 24.0, top: 16.0, bottom: 8.0),
// //               child: Align(
// //                 alignment: Alignment.centerLeft,
// //                 child: Text(
// //                   'Profile',
// //                   style: TextStyle(
// //                     fontSize: 28,
// //                     fontWeight: FontWeight.bold,
// //                     color: Colors.white,
// //                     letterSpacing: -0.5,
// //                   ),
// //                 ),
// //               ),
// //             ),
            
// //             // Scrollable Content
// //             Expanded(
// //               child: ListView(
// //                 padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
// //                 children: [
// //                   // 1. User Profile Card[cite: 11]
// //                   Container(
// //                     padding: const EdgeInsets.all(20),
// //                     decoration: BoxDecoration(
// //                       color: const Color(0xFF0E1526),
// //                       borderRadius: BorderRadius.circular(24),
// //                       border: Border.all(color: Colors.white.withOpacity(0.04)),
// //                     ),
// //                     child: Row(
// //                       children: [
// //                         // Avatar Icon[cite: 11]
// //                         Container(
// //                           width: 64,
// //                           height: 64,
// //                           decoration: BoxDecoration(
// //                             color: const Color(0xFF132A29), // Teal-tinted background[cite: 11]
// //                             borderRadius: BorderRadius.circular(16),
// //                             border: Border.all(color: const Color(0xFF1ECB6B).withOpacity(0.2)),
// //                           ),
// //                           child: const Icon(Icons.person, color: Color(0xFF7B52AB), size: 36),
// //                         ),
// //                         const SizedBox(width: 16),
// //                         // User Info[cite: 11]
// //                         Expanded(
// //                           child: Column(
// //                             crossAxisAlignment: CrossAxisAlignment.start,
// //                             children: [
// //                               const Text(
// //                                 'Alex Kumar',
// //                                 style: TextStyle(
// //                                   color: Colors.white,
// //                                   fontSize: 20,
// //                                   fontWeight: FontWeight.bold,
// //                                 ),
// //                               ),
// //                               const SizedBox(height: 2),
// //                               const Text(
// //                                 'alex.kumar@example.com',
// //                                 style: TextStyle(
// //                                   color: Color(0xFF676E84),
// //                                   fontSize: 13,
// //                                 ),
// //                               ),
// //                               const SizedBox(height: 8),
// //                               // EV Driver Badge[cite: 11]
// //                               Container(
// //                                 padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
// //                                 decoration: BoxDecoration(
// //                                   color: const Color(0xFF102E20), // Dark green pill[cite: 11]
// //                                   borderRadius: BorderRadius.circular(12),
// //                                 ),
// //                                 child: const Text(
// //                                   'EV Driver',
// //                                   style: TextStyle(
// //                                     color: Color(0xFF1ECB6B),
// //                                     fontSize: 11,
// //                                     fontWeight: FontWeight.bold,
// //                                   ),
// //                                 ),
// //                               ),
// //                             ],
// //                           ),
// //                         ),
// //                       ],
// //                     ),
// //                   ),
// //                   const SizedBox(height: 20),

// //                   // 2. Active Vehicle Status Card[cite: 11]
// //                   Container(
// //                     padding: const EdgeInsets.all(20),
// //                     decoration: BoxDecoration(
// //                       color: const Color(0xFF0E1526),
// //                       borderRadius: BorderRadius.circular(24),
// //                       border: Border.all(color: Colors.white.withOpacity(0.04)),
// //                     ),
// //                     child: Column(
// //                       crossAxisAlignment: CrossAxisAlignment.start,
// //                       children: [
// //                         const Text(
// //                           'MY VEHICLE',
// //                           style: TextStyle(
// //                             fontSize: 10,
// //                             fontWeight: FontWeight.bold,
// //                             letterSpacing: 1.2,
// //                             color: Color(0xFF676E84),
// //                           ),
// //                         ),
// //                         const SizedBox(height: 16),
// //                         Row(
// //                           crossAxisAlignment: CrossAxisAlignment.center,
// //                           children: [
// //                             const Text('🚗', style: TextStyle(fontSize: 28)), // Placeholder for red car icon[cite: 11]
// //                             const SizedBox(width: 16),
// //                             Expanded(
// //                               child: Column(
// //                                 crossAxisAlignment: CrossAxisAlignment.start,
// //                                 children: [
// //                                   const Text(
// //                                     'Tesla Model 3',
// //                                     style: TextStyle(
// //                                       color: Colors.white,
// //                                       fontSize: 18,
// //                                       fontWeight: FontWeight.bold,
// //                                     ),
// //                                   ),
// //                                   const SizedBox(height: 2),
// //                                   const Text(
// //                                     '75 kWh battery',
// //                                     style: TextStyle(
// //                                       color: Color(0xFF676E84),
// //                                       fontSize: 13,
// //                                     ),
// //                                   ),
// //                                   const SizedBox(height: 12),
// //                                   // Battery Progress Row[cite: 11]
// //                                   Row(
// //                                     children: [
// //                                       Expanded(
// //                                         child: ClipRRect(
// //                                           borderRadius: BorderRadius.circular(4),
// //                                           child: LinearProgressIndicator(
// //                                             value: 0.72,
// //                                             minHeight: 6,
// //                                             backgroundColor: const Color(0xFF161F34),
// //                                             valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF1ECB6B)),
// //                                           ),
// //                                         ),
// //                                       ),
// //                                       const SizedBox(width: 12),
// //                                       const Text(
// //                                         '72%',
// //                                         style: TextStyle(
// //                                           color: Color(0xFF1ECB6B),
// //                                           fontWeight: FontWeight.bold,
// //                                           fontSize: 14,
// //                                         ),
// //                                       ),
// //                                     ],
// //                                   ),
// //                                 ],
// //                               ),
// //                             ),
// //                           ],
// //                         ),
// //                       ],
// //                     ),
// //                   ),
// //                   const SizedBox(height: 20),

// //                   // 3. Settings Menu List Card[cite: 11]
// //                   Container(
// //                     decoration: BoxDecoration(
// //                       color: const Color(0xFF0E1526),
// //                       borderRadius: BorderRadius.circular(24),
// //                       border: Border.all(color: Colors.white.withOpacity(0.04)),
// //                     ),
// //                     child: Column(
// //                       children: [
// //                         _buildSettingsRow(
// //                           icon: Icons.directions_car,
// //                           iconColor: Colors.pinkAccent,
// //                           label: 'Vehicle Settings',
// //                           isFirst: true,
// //                         ),
// //                         _buildSettingsRow(
// //                           icon: Icons.bolt,
// //                           iconColor: Colors.orangeAccent,
// //                           label: 'Charging Preferences',
// //                         ),
// //                         _buildSettingsRow(
// //                           icon: Icons.assignment,
// //                           iconColor: Colors.orangeAccent,
// //                           label: 'Trip History',
// //                           onTap: () => _onBottomNavTapped(3),
// //                         ),
// //                         _buildSettingsRow(
// //                           icon: Icons.notifications,
// //                           iconColor: Colors.amber,
// //                           label: 'Notifications',
// //                         ),
// //                         _buildSettingsRow(
// //                           icon: Icons.help_outline,
// //                           iconColor: Colors.redAccent,
// //                           label: 'Help & Support',
// //                         ),
// //                         _buildSettingsRow(
// //                           icon: Icons.lock_outline,
// //                           iconColor: Colors.amberAccent,
// //                           label: 'Privacy',
// //                         ),
// //                         _buildSettingsRow(
// //                           icon: Icons.settings,
// //                           iconColor: Colors.grey.shade400,
// //                           label: 'Settings',
// //                           isLast: true,
// //                         ),
// //                       ],
// //                     ),
// //                   ),
// //                   const SizedBox(height: 24),
// //                 ],
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),

// //       // Bottom Navigation Bar[cite: 11]
// //       bottomNavigationBar: Container(
// //         decoration: BoxDecoration(
// //           color: const Color(0xFF0A0F1D),
// //           border: Border(top: BorderSide(color: Colors.white.withOpacity(0.04))),
// //         ),
// //         child: BottomNavigationBar(
// //           currentIndex: _selectedIndex, // Profile active at index 4[cite: 11]
// //           onTap: _onBottomNavTapped,
// //           backgroundColor: const Color(0xFF0A0F1D),
// //           type: BottomNavigationBarType.fixed,
// //           selectedItemColor: const Color(0xFF1ECB6B),
// //           unselectedItemColor: const Color(0xFF535D75),
// //           selectedFontSize: 11,
// //           unselectedFontSize: 11,
// //           items: const [
// //             BottomNavigationBarItem(
// //               icon: Icon(Icons.home_outlined),
// //               activeIcon: Icon(Icons.home),
// //               label: 'Home',
// //             ),
// //             BottomNavigationBarItem(
// //               icon: Icon(Icons.alt_route),
// //               label: 'Routes',
// //             ),
// //             BottomNavigationBarItem(
// //               icon: Icon(Icons.bolt),
// //               label: 'Charging',
// //             ),
// //             BottomNavigationBarItem(
// //               icon: Icon(Icons.assignment_outlined),
// //               activeIcon: Icon(Icons.assignment),
// //               label: 'Trips',
// //             ),
// //             BottomNavigationBarItem(
// //               icon: Icon(Icons.person_outline),
// //               activeIcon: Icon(Icons.person),
// //               label: 'Profile', // Active state[cite: 11]
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   // Builder for the individual settings list items[cite: 11]
// //   Widget _buildSettingsRow({
// //     required IconData icon,
// //     required Color iconColor,
// //     required String label,
// //     bool isFirst = false,
// //     bool isLast = false,
// //     VoidCallback? onTap,
// //   }) {
// //     return InkWell(
// //       onTap: onTap ?? () {},
// //       borderRadius: BorderRadius.vertical(
// //         top: Radius.circular(isFirst ? 24 : 0),
// //         bottom: Radius.circular(isLast ? 24 : 0),
// //       ),
// //       child: Container(
// //         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
// //         decoration: BoxDecoration(
// //           border: isLast ? null : Border(
// //             bottom: BorderSide(color: Colors.white.withOpacity(0.04)),
// //           ),
// //         ),
// //         child: Row(
// //           children: [
// //             Icon(icon, color: iconColor, size: 20),
// //             const SizedBox(width: 16),
// //             Expanded(
// //               child: Text(
// //                 label,
// //                 style: const TextStyle(
// //                   color: Colors.white,
// //                   fontSize: 15,
// //                   fontWeight: FontWeight.w600,
// //                 ),
// //               ),
// //             ),
// //             const Icon(Icons.chevron_right, color: Color(0xFF4C556D), size: 20), // Trailing Chevron[cite: 11]
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }


// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class ProfileSettingsScreen extends StatefulWidget {
//   const ProfileSettingsScreen({super.key});

//   @override
//   State<ProfileSettingsScreen> createState() => _ProfileSettingsScreenState();
// }

// class _ProfileSettingsScreenState extends State<ProfileSettingsScreen> {
//   final int _selectedIndex = 4; // Profile tab index

//   // Available options for editing
//   final List<String> _brands = ['Tesla', 'Hyundai', 'Porsche', 'BMW', 'Tata', 'Kia', 'BYD'];
//   final List<String> _models = ['Model 3', 'Model Y', 'Model S', 'Ioniq 5', 'Taycan', 'EV6', 'Nexon EV'];
//   final List<String> _chargerTypes = ['Fast', 'Normal', 'Any'];
//   final List<String> _timeLimits = ['15m', '30m', '45m', '60m'];

//   // Bottom Navigation Bar Routing
//   void _onBottomNavTapped(int index) {
//     if (index == _selectedIndex) return;

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
//       case 3:
//         Navigator.pushReplacementNamed(context, '/trips');
//         break;
//     }
//   }

//   // --- EDIT VEHICLE DETAILS MODAL ---
//   void _showEditVehicleSheet(BuildContext context, Map<String, dynamic> data, String uid) {
//     String selectedBrand = data['vehicleBrand'] ?? 'Tesla';
//     String selectedModel = data['vehicleModel'] ?? 'Model 3';
//     final batteryCtrl = TextEditingController(text: (data['batteryCapacityKwh'] ?? 75.0).toString());
//     final consumptionCtrl = TextEditingController(text: (data['avgConsumption'] ?? 15.5).toString());
//     bool isSaving = false;

//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: const Color(0xFF0E1526),
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
//       ),
//       builder: (ctx) {
//         return StatefulBuilder(
//           builder: (context, setModalState) {
//             return Padding(
//               padding: EdgeInsets.only(
//                 left: 24,
//                 right: 24,
//                 top: 20,
//                 bottom: MediaQuery.of(context).viewInsets.bottom + 24,
//               ),
//               child: SingleChildScrollView(
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Center(
//                       child: Container(
//                         width: 40,
//                         height: 4,
//                         decoration: BoxDecoration(
//                           color: Colors.white24,
//                           borderRadius: BorderRadius.circular(2),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 20),
//                     const Text(
//                       'Edit Vehicle Details',
//                       style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
//                     ),
//                     const SizedBox(height: 18),

//                     // Vehicle Brand Dropdown
//                     const Text('VEHICLE BRAND', style: TextStyle(color: Color(0xFF78829D), fontSize: 11, fontWeight: FontWeight.bold)),
//                     const SizedBox(height: 6),
//                     _buildModalDropdown(
//                       value: selectedBrand,
//                       items: _brands,
//                       onChanged: (val) => setModalState(() => selectedBrand = val!),
//                     ),
//                     const SizedBox(height: 14),

//                     // Vehicle Model Dropdown
//                     const Text('VEHICLE MODEL', style: TextStyle(color: Color(0xFF78829D), fontSize: 11, fontWeight: FontWeight.bold)),
//                     const SizedBox(height: 6),
//                     _buildModalDropdown(
//                       value: selectedModel,
//                       items: _models,
//                       onChanged: (val) => setModalState(() => selectedModel = val!),
//                     ),
//                     const SizedBox(height: 14),

//                     // Battery Capacity (kWh)
//                     const Text('BATTERY CAPACITY (kWh)', style: TextStyle(color: Color(0xFF78829D), fontSize: 11, fontWeight: FontWeight.bold)),
//                     const SizedBox(height: 6),
//                     _buildModalTextField(controller: batteryCtrl, suffix: 'kWh', keyboardType: TextInputType.number),
//                     const SizedBox(height: 14),

//                     // Average Consumption
//                     const Text('AVG. CONSUMPTION (kWh / 100 km)', style: TextStyle(color: Color(0xFF78829D), fontSize: 11, fontWeight: FontWeight.bold)),
//                     const SizedBox(height: 6),
//                     _buildModalTextField(controller: consumptionCtrl, suffix: 'kWh / 100 km', keyboardType: TextInputType.number),
//                     const SizedBox(height: 24),

//                     // Save Button
//                     SizedBox(
//                       width: double.infinity,
//                       height: 50,
//                       child: ElevatedButton(
//                         onPressed: isSaving
//                             ? null
//                             : () async {
//                                 setModalState(() => isSaving = true);
//                                 try {
//                                   await FirebaseFirestore.instance.collection('users').doc(uid).update({
//                                     'vehicleBrand': selectedBrand,
//                                     'vehicleModel': selectedModel,
//                                     'batteryCapacityKwh': double.tryParse(batteryCtrl.text.trim()) ?? 75.0,
//                                     'avgConsumption': double.tryParse(consumptionCtrl.text.trim()) ?? 15.5,
//                                   });
//                                   if (mounted) Navigator.pop(ctx);
//                                 } catch (e) {
//                                   ScaffoldMessenger.of(context).showSnackBar(
//                                     SnackBar(content: Text('Failed to update: $e')),
//                                   );
//                                 } finally {
//                                   setModalState(() => isSaving = false);
//                                 }
//                               },
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: const Color(0xFF1ECB6B),
//                           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
//                         ),
//                         child: isSaving
//                             ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Color(0xFF070B16), strokeWidth: 2))
//                             : const Text('Save Changes', style: TextStyle(color: Color(0xFF070B16), fontWeight: FontWeight.bold, fontSize: 15)),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           },
//         );
//       },
//     );
//   }

//   // --- EDIT CHARGING PREFERENCES MODAL ---
//   void _showEditChargingSheet(BuildContext context, Map<String, dynamic> data, String uid) {
//     String selectedType = data['preferredCharger'] ?? 'Fast';
//     String selectedTime = data['maxChargingTime'] ?? '30m';
//     bool autoStops = data['autoChargingStops'] ?? true;
//     bool isSaving = false;

//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: const Color(0xFF0E1526),
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
//       ),
//       builder: (ctx) {
//         return StatefulBuilder(
//           builder: (context, setModalState) {
//             return Padding(
//               padding: const EdgeInsets.only(left: 24, right: 24, top: 20, bottom: 28),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Center(
//                     child: Container(
//                       width: 40,
//                       height: 4,
//                       decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2)),
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   const Text(
//                     'Edit Charging Preferences',
//                     style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
//                   ),
//                   const SizedBox(height: 20),

//                   // Preferred Charger Type
//                   const Text('PREFERRED CHARGER TYPE', style: TextStyle(color: Color(0xFF78829D), fontSize: 11, fontWeight: FontWeight.bold)),
//                   const SizedBox(height: 10),
//                   Row(
//                     children: _chargerTypes.map((type) {
//                       final isSelected = selectedType == type;
//                       return Expanded(
//                         child: Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 4.0),
//                           child: GestureDetector(
//                             onTap: () => setModalState(() => selectedType = type),
//                             child: Container(
//                               height: 44,
//                               decoration: BoxDecoration(
//                                 color: isSelected ? const Color(0xFF1ECB6B) : const Color(0xFF161F34),
//                                 borderRadius: BorderRadius.circular(12),
//                               ),
//                               alignment: Alignment.center,
//                               child: Text(
//                                 type,
//                                 style: TextStyle(
//                                   color: isSelected ? const Color(0xFF070B16) : const Color(0xFF78829D),
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                       );
//                     }).toList(),
//                   ),
//                   const SizedBox(height: 20),

//                   // Maximum Charging Time
//                   const Text('MAXIMUM CHARGING TIME', style: TextStyle(color: Color(0xFF78829D), fontSize: 11, fontWeight: FontWeight.bold)),
//                   const SizedBox(height: 10),
//                   Row(
//                     children: _timeLimits.map((time) {
//                       final isSelected = selectedTime == time;
//                       return Expanded(
//                         child: Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 4.0),
//                           child: GestureDetector(
//                             onTap: () => setModalState(() => selectedTime = time),
//                             child: Container(
//                               height: 44,
//                               decoration: BoxDecoration(
//                                 color: isSelected ? const Color(0xFF1ECB6B) : const Color(0xFF161F34),
//                                 borderRadius: BorderRadius.circular(12),
//                               ),
//                               alignment: Alignment.center,
//                               child: Text(
//                                 time,
//                                 style: TextStyle(
//                                   color: isSelected ? const Color(0xFF070B16) : const Color(0xFF78829D),
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                       );
//                     }).toList(),
//                   ),
//                   const SizedBox(height: 20),

//                   // Auto Charging Stops
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: const [
//                           Text('Auto charging stops', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
//                           SizedBox(height: 2),
//                           Text('Automatically add stops to routes', style: TextStyle(color: Color(0xFF676E84), fontSize: 12)),
//                         ],
//                       ),
//                       Switch(
//                         value: autoStops,
//                         activeColor: Colors.white,
//                         activeTrackColor: const Color(0xFF1ECB6B),
//                         inactiveThumbColor: const Color(0xFF676E84),
//                         inactiveTrackColor: const Color(0xFF161F34),
//                         onChanged: (val) => setModalState(() => autoStops = val),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 24),

//                   // Save Button
//                   SizedBox(
//                     width: double.infinity,
//                     height: 50,
//                     child: ElevatedButton(
//                       onPressed: isSaving
//                           ? null
//                           : () async {
//                               setModalState(() => isSaving = true);
//                               try {
//                                 await FirebaseFirestore.instance.collection('users').doc(uid).update({
//                                   'preferredCharger': selectedType,
//                                   'maxChargingTime': selectedTime,
//                                   'autoChargingStops': autoStops,
//                                 });
//                                 if (mounted) Navigator.pop(ctx);
//                               } catch (e) {
//                                 ScaffoldMessenger.of(context).showSnackBar(
//                                   SnackBar(content: Text('Failed to update: $e')),
//                                 );
//                               } finally {
//                                 setModalState(() => isSaving = false);
//                               }
//                             },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: const Color(0xFF1ECB6B),
//                         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
//                       ),
//                       child: isSaving
//                           ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Color(0xFF070B16), strokeWidth: 2))
//                           : const Text('Save Preferences', style: TextStyle(color: Color(0xFF070B16), fontWeight: FontWeight.bold, fontSize: 15)),
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           },
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final user = FirebaseAuth.instance.currentUser;

//     if (user == null) {
//       return const Scaffold(
//         backgroundColor: Color(0xFF070B16),
//         body: Center(child: Text('User not logged in', style: TextStyle(color: Colors.white))),
//       );
//     }

//     final String displayName = (user.displayName != null && user.displayName!.isNotEmpty)
//         ? user.displayName!
//         : (user.email?.split('@')[0] ?? 'EV Driver');
//     final String userEmail = user.email ?? 'No email';

//     return Scaffold(
//       backgroundColor: const Color(0xFF070B16),
//       body: SafeArea(
//         child: StreamBuilder<DocumentSnapshot>(
//           stream: FirebaseFirestore.instance.collection('users').doc(user.uid).snapshots(),
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return const Center(child: CircularProgressIndicator(color: Color(0xFF1ECB6B)));
//             }

//             final data = (snapshot.hasData && snapshot.data!.exists)
//                 ? (snapshot.data!.data() as Map<String, dynamic>)
//                 : <String, dynamic>{};

//             final String vehicleBrand = data['vehicleBrand'] ?? 'Tesla';
//             final String vehicleModel = data['vehicleModel'] ?? 'Model 3';
//             final double batteryCapacity = (data['batteryCapacityKwh'] ?? 75.0).toDouble();
//             final double avgConsumption = (data['avgConsumption'] ?? 15.5).toDouble();
//             final String preferredCharger = data['preferredCharger'] ?? 'Fast';
//             final String maxChargingTime = data['maxChargingTime'] ?? '30m';

//             int maxRange = avgConsumption > 0 ? ((batteryCapacity / avgConsumption) * 100).round() : 0;

//             return Column(
//               children: [
//                 // Header
//                 const Padding(
//                   padding: EdgeInsets.only(left: 24.0, right: 24.0, top: 16.0, bottom: 8.0),
//                   child: Align(
//                     alignment: Alignment.centerLeft,
//                     child: Text(
//                       'Profile',
//                       style: TextStyle(
//                         fontSize: 28,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.white,
//                         letterSpacing: -0.5,
//                       ),
//                     ),
//                   ),
//                 ),

//                 // Main Content List
//                 Expanded(
//                   child: ListView(
//                     padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
//                     children: [
//                       // 1. User Profile Card (Fetched from Firebase Auth)
//                       Container(
//                         padding: const EdgeInsets.all(20),
//                         decoration: BoxDecoration(
//                           color: const Color(0xFF0E1526),
//                           borderRadius: BorderRadius.circular(24),
//                           border: Border.all(color: Colors.white.withOpacity(0.04)),
//                         ),
//                         child: Row(
//                           children: [
//                             Container(
//                               width: 64,
//                               height: 64,
//                               decoration: BoxDecoration(
//                                 color: const Color(0xFF132A29),
//                                 borderRadius: BorderRadius.circular(16),
//                                 border: Border.all(color: const Color(0xFF1ECB6B).withOpacity(0.2)),
//                               ),
//                               child: const Icon(Icons.person, color: Color(0xFF7B52AB), size: 36),
//                             ),
//                             const SizedBox(width: 16),
//                             Expanded(
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     displayName,
//                                     style: const TextStyle(
//                                       color: Colors.white,
//                                       fontSize: 20,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                     overflow: TextOverflow.ellipsis,
//                                   ),
//                                   const SizedBox(height: 2),
//                                   Text(
//                                     userEmail,
//                                     style: const TextStyle(
//                                       color: Color(0xFF676E84),
//                                       fontSize: 13,
//                                     ),
//                                     overflow: TextOverflow.ellipsis,
//                                   ),
//                                   const SizedBox(height: 8),
//                                   Container(
//                                     padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
//                                     decoration: BoxDecoration(
//                                       color: const Color(0xFF102E20),
//                                       borderRadius: BorderRadius.circular(12),
//                                     ),
//                                     child: const Text(
//                                       'EV Driver',
//                                       style: TextStyle(
//                                         color: Color(0xFF1ECB6B),
//                                         fontSize: 11,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       const SizedBox(height: 20),

//                       // 2. Active Vehicle Status Card (Fetched from Firestore)
//                       Container(
//                         padding: const EdgeInsets.all(20),
//                         decoration: BoxDecoration(
//                           color: const Color(0xFF0E1526),
//                           borderRadius: BorderRadius.circular(24),
//                           border: Border.all(color: Colors.white.withOpacity(0.04)),
//                         ),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 const Text(
//                                   'MY VEHICLE',
//                                   style: TextStyle(
//                                     fontSize: 10,
//                                     fontWeight: FontWeight.bold,
//                                     letterSpacing: 1.2,
//                                     color: Color(0xFF676E84),
//                                   ),
//                                 ),
//                                 GestureDetector(
//                                   onTap: () => _showEditVehicleSheet(context, data, user.uid),
//                                   child: const Text(
//                                     'Edit',
//                                     style: TextStyle(
//                                       color: Color(0xFF1ECB6B),
//                                       fontSize: 12,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             const SizedBox(height: 16),
//                             Row(
//                               crossAxisAlignment: CrossAxisAlignment.center,
//                               children: [
//                                 const Text('🚗', style: TextStyle(fontSize: 32)),
//                                 const SizedBox(width: 16),
//                                 Expanded(
//                                   child: Column(
//                                     crossAxisAlignment: CrossAxisAlignment.start,
//                                     children: [
//                                       Text(
//                                         '$vehicleBrand $vehicleModel',
//                                         style: const TextStyle(
//                                           color: Colors.white,
//                                           fontSize: 18,
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                       ),
//                                       const SizedBox(height: 2),
//                                       Text(
//                                         '$batteryCapacity kWh battery · $avgConsumption kWh/100km',
//                                         style: const TextStyle(
//                                           color: Color(0xFF676E84),
//                                           fontSize: 13,
//                                         ),
//                                       ),
//                                       const SizedBox(height: 6),
//                                       Text(
//                                         'Estimated Max Range: $maxRange km',
//                                         style: const TextStyle(
//                                           color: Color(0xFF1ECB6B),
//                                           fontSize: 13,
//                                           fontWeight: FontWeight.w600,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                       const SizedBox(height: 20),

//                       // 3. Settings Menu List (Only Vehicle, Charging, and Trips)
//                       Container(
//                         decoration: BoxDecoration(
//                           color: const Color(0xFF0E1526),
//                           borderRadius: BorderRadius.circular(24),
//                           border: Border.all(color: Colors.white.withOpacity(0.04)),
//                         ),
//                         child: Column(
//                           children: [
//                             // 1. Vehicle Settings -> Opens Edit Modal
//                             _buildSettingsRow(
//                               icon: Icons.directions_car,
//                               iconColor: Colors.pinkAccent,
//                               label: 'Vehicle Settings',
//                               subtitle: '$vehicleBrand $vehicleModel ($batteryCapacity kWh)',
//                               isFirst: true,
//                               onTap: () => _showEditVehicleSheet(context, data, user.uid),
//                             ),

//                             // 2. Charging Preferences -> Opens Edit Modal
//                             _buildSettingsRow(
//                               icon: Icons.bolt,
//                               iconColor: Colors.amber,
//                               label: 'Charging Preferences',
//                               subtitle: '$preferredCharger · Max $maxChargingTime',
//                               onTap: () => _showEditChargingSheet(context, data, user.uid),
//                             ),

//                             // 3. Trip History -> Routes to Trips
//                             _buildSettingsRow(
//                               icon: Icons.assignment,
//                               iconColor: Colors.orangeAccent,
//                               label: 'Trip History',
//                               subtitle: 'View completed routes and energy log',
//                               isLast: true,
//                               onTap: () => _onBottomNavTapped(3),
//                             ),
//                           ],
//                         ),
//                       ),
//                       const SizedBox(height: 24),
//                     ],
//                   ),
//                 ),
//               ],
//             );
//           },
//         ),
//       ),

//       // Bottom Navigation Bar
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
//           selectedItemColor: const Color(0xFF1ECB6B),
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

//   // --- HELPER WIDGETS ---

//   Widget _buildSettingsRow({
//     required IconData icon,
//     required Color iconColor,
//     required String label,
//     String? subtitle,
//     bool isFirst = false,
//     bool isLast = false,
//     VoidCallback? onTap,
//   }) {
//     return InkWell(
//       onTap: onTap,
//       borderRadius: BorderRadius.vertical(
//         top: Radius.circular(isFirst ? 24 : 0),
//         bottom: Radius.circular(isLast ? 24 : 0),
//       ),
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
//         decoration: BoxDecoration(
//           border: isLast
//               ? null
//               : Border(bottom: BorderSide(color: Colors.white.withOpacity(0.04))),
//         ),
//         child: Row(
//           children: [
//             Icon(icon, color: iconColor, size: 22),
//             const SizedBox(width: 16),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     label,
//                     style: const TextStyle(
//                       color: Colors.white,
//                       fontSize: 15,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                   if (subtitle != null) ...[
//                     const SizedBox(height: 2),
//                     Text(
//                       subtitle,
//                       style: const TextStyle(
//                         color: Color(0xFF676E84),
//                         fontSize: 12,
//                       ),
//                     ),
//                   ]
//                 ],
//               ),
//             ),
//             const Icon(Icons.chevron_right, color: Color(0xFF4C556D), size: 20),
//           ],
//         ),
//       ),
//     );
//   }

//   static Widget _buildModalDropdown({
//     required String value,
//     required List<String> items,
//     required ValueChanged<String?> onChanged,
//   }) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 14),
//       decoration: BoxDecoration(
//         color: const Color(0xFF161F34),
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: DropdownButtonHideUnderline(
//         child: DropdownButton<String>(
//           value: items.contains(value) ? value : items.first,
//           dropdownColor: const Color(0xFF161F34),
//           icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF78829D)),
//           isExpanded: true,
//           style: const TextStyle(color: Colors.white, fontSize: 14),
//           onChanged: onChanged,
//           items: items.map((item) {
//             return DropdownMenuItem(value: item, child: Text(item));
//           }).toList(),
//         ),
//       ),
//     );
//   }

//   static Widget _buildModalTextField({
//     required TextEditingController controller,
//     required String suffix,
//     TextInputType keyboardType = TextInputType.text,
//   }) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 14),
//       decoration: BoxDecoration(
//         color: const Color(0xFF161F34),
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: TextField(
//         controller: controller,
//         keyboardType: keyboardType,
//         style: const TextStyle(color: Colors.white, fontSize: 14),
//         decoration: InputDecoration(
//           border: InputBorder.none,
//           suffixText: suffix,
//           suffixStyle: const TextStyle(color: Color(0xFF78829D), fontSize: 13),
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileSettingsScreen extends StatefulWidget {
  const ProfileSettingsScreen({super.key});

  @override
  State<ProfileSettingsScreen> createState() => _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState extends State<ProfileSettingsScreen> {
  final int _selectedIndex = 4; // Profile tab index

  // Available options for editing
  final List<String> _brands = ['Tesla', 'Hyundai', 'Porsche', 'BMW', 'Tata', 'Kia', 'BYD'];
  final List<String> _models = ['Model 3', 'Model Y', 'Model S', 'Ioniq 5', 'Taycan', 'EV6', 'Nexon EV'];

  // Bottom Navigation Bar Routing
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
      case 3:
        Navigator.pushReplacementNamed(context, '/trips');
        break;
    }
  }

  // --- EDIT VEHICLE DETAILS MODAL ---
  void _showEditVehicleSheet(BuildContext context, Map<String, dynamic> data, String uid) {
    String selectedBrand = data['vehicleBrand'] ?? 'Tesla';
    String selectedModel = data['vehicleModel'] ?? 'Model 3';
    final batteryCtrl = TextEditingController(text: (data['batteryCapacityKwh'] ?? 75.0).toString());
    final consumptionCtrl = TextEditingController(text: (data['avgConsumption'] ?? 15.5).toString());
    bool isSaving = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF0E1526),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 24,
                right: 24,
                top: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.white24,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Edit Vehicle Details',
                      style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 18),

                    // Vehicle Brand Dropdown
                    const Text('VEHICLE BRAND', style: TextStyle(color: Color(0xFF78829D), fontSize: 11, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    _buildModalDropdown(
                      value: selectedBrand,
                      items: _brands,
                      onChanged: (val) => setModalState(() => selectedBrand = val!),
                    ),
                    const SizedBox(height: 14),

                    // Vehicle Model Dropdown
                    const Text('VEHICLE MODEL', style: TextStyle(color: Color(0xFF78829D), fontSize: 11, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    _buildModalDropdown(
                      value: selectedModel,
                      items: _models,
                      onChanged: (val) => setModalState(() => selectedModel = val!),
                    ),
                    const SizedBox(height: 14),

                    // Battery Capacity (kWh)
                    const Text('BATTERY CAPACITY (kWh)', style: TextStyle(color: Color(0xFF78829D), fontSize: 11, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    _buildModalTextField(controller: batteryCtrl, suffix: 'kWh', keyboardType: TextInputType.number),
                    const SizedBox(height: 14),

                    // Average Consumption
                    const Text('AVG. CONSUMPTION (kWh / 100 km)', style: TextStyle(color: Color(0xFF78829D), fontSize: 11, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    _buildModalTextField(controller: consumptionCtrl, suffix: 'kWh / 100 km', keyboardType: TextInputType.number),
                    const SizedBox(height: 24),

                    // Save Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: isSaving
                            ? null
                            : () async {
                                setModalState(() => isSaving = true);
                                try {
                                  await FirebaseFirestore.instance.collection('users').doc(uid).update({
                                    'vehicleBrand': selectedBrand,
                                    'vehicleModel': selectedModel,
                                    'batteryCapacityKwh': double.tryParse(batteryCtrl.text.trim()) ?? 75.0,
                                    'avgConsumption': double.tryParse(consumptionCtrl.text.trim()) ?? 15.5,
                                  });
                                  if (mounted) Navigator.pop(ctx);
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Failed to update: $e')),
                                  );
                                } finally {
                                  setModalState(() => isSaving = false);
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1ECB6B),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                        child: isSaving
                            ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Color(0xFF070B16), strokeWidth: 2))
                            : const Text('Save Changes', style: TextStyle(color: Color(0xFF070B16), fontWeight: FontWeight.bold, fontSize: 15)),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Scaffold(
        backgroundColor: Color(0xFF070B16),
        body: Center(child: Text('User not logged in', style: TextStyle(color: Colors.white))),
      );
    }

    final String displayName = (user.displayName != null && user.displayName!.isNotEmpty)
        ? user.displayName!
        : (user.email?.split('@')[0] ?? 'EV Driver');
    final String userEmail = user.email ?? 'No email';

    return Scaffold(
      backgroundColor: const Color(0xFF070B16),
      body: SafeArea(
        child: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance.collection('users').doc(user.uid).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator(color: Color(0xFF1ECB6B)));
            }

            final data = (snapshot.hasData && snapshot.data!.exists)
                ? (snapshot.data!.data() as Map<String, dynamic>)
                : <String, dynamic>{};

            final String vehicleBrand = data['vehicleBrand'] ?? 'Tesla';
            final String vehicleModel = data['vehicleModel'] ?? 'Model 3';
            final double batteryCapacity = (data['batteryCapacityKwh'] ?? 75.0).toDouble();
            final double avgConsumption = (data['avgConsumption'] ?? 15.5).toDouble();

            int maxRange = avgConsumption > 0 ? ((batteryCapacity / avgConsumption) * 100).round() : 0;

            return Column(
              children: [
                // Header
                const Padding(
                  padding: EdgeInsets.only(left: 24.0, right: 24.0, top: 16.0, bottom: 8.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Profile',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ),
                ),

                // Main Content List
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                    children: [
                      // 1. User Profile Card
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0E1526),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: Colors.white.withOpacity(0.04)),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 64,
                              height: 64,
                              decoration: BoxDecoration(
                                color: const Color(0xFF132A29),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: const Color(0xFF1ECB6B).withOpacity(0.2)),
                              ),
                              child: const Icon(Icons.person, color: Color(0xFF7B52AB), size: 36),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    displayName,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    userEmail,
                                    style: const TextStyle(
                                      color: Color(0xFF676E84),
                                      fontSize: 13,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF102E20),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Text(
                                      'EV Driver',
                                      style: TextStyle(
                                        color: Color(0xFF1ECB6B),
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // 2. Active Vehicle Status Card
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0E1526),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: Colors.white.withOpacity(0.04)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'MY VEHICLE',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.2,
                                    color: Color(0xFF676E84),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () => _showEditVehicleSheet(context, data, user.uid),
                                  child: const Text(
                                    'Edit',
                                    style: TextStyle(
                                      color: Color(0xFF1ECB6B),
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text('🚗', style: TextStyle(fontSize: 32)),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '$vehicleBrand $vehicleModel',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        '$batteryCapacity kWh battery · $avgConsumption kWh/100km',
                                        style: const TextStyle(
                                          color: Color(0xFF676E84),
                                          fontSize: 13,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        'Estimated Max Range: $maxRange km',
                                        style: const TextStyle(
                                          color: Color(0xFF1ECB6B),
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // 3. Settings Menu List
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF0E1526),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: Colors.white.withOpacity(0.04)),
                        ),
                        child: Column(
                          children: [
                            // 1. Vehicle Settings
                            _buildSettingsRow(
                              icon: Icons.directions_car,
                              iconColor: Colors.pinkAccent,
                              label: 'Vehicle Settings',
                              subtitle: '$vehicleBrand $vehicleModel ($batteryCapacity kWh)',
                              isFirst: true,
                              onTap: () => _showEditVehicleSheet(context, data, user.uid),
                            ),

                            // 2. Trip History
                            _buildSettingsRow(
                              icon: Icons.assignment,
                              iconColor: Colors.orangeAccent,
                              label: 'Trip History',
                              subtitle: 'View completed routes and energy log',
                              isLast: true,
                              onTap: () => _onBottomNavTapped(3),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),

      // Bottom Navigation Bar
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
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.alt_route),
              label: 'Routes',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bolt),
              label: 'Charging',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.assignment_outlined),
              activeIcon: Icon(Icons.assignment),
              label: 'Trips',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }

  // --- HELPER WIDGETS ---

  Widget _buildSettingsRow({
    required IconData icon,
    required Color iconColor,
    required String label,
    String? subtitle,
    bool isFirst = false,
    bool isLast = false,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(isFirst ? 24 : 0),
        bottom: Radius.circular(isLast ? 24 : 0),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          border: isLast
              ? null
              : Border(bottom: BorderSide(color: Colors.white.withOpacity(0.04))),
        ),
        child: Row(
          children: [
            Icon(icon, color: iconColor, size: 22),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: Color(0xFF676E84),
                        fontSize: 12,
                      ),
                    ),
                  ]
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Color(0xFF4C556D), size: 20),
          ],
        ),
      ),
    );
  }

  static Widget _buildModalDropdown({
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF161F34),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: items.contains(value) ? value : items.first,
          dropdownColor: const Color(0xFF161F34),
          icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF78829D)),
          isExpanded: true,
          style: const TextStyle(color: Colors.white, fontSize: 14),
          onChanged: onChanged,
          items: items.map((item) {
            return DropdownMenuItem(value: item, child: Text(item));
          }).toList(),
        ),
      ),
    );
  }

  static Widget _buildModalTextField({
    required TextEditingController controller,
    required String suffix,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF161F34),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: const TextStyle(color: Colors.white, fontSize: 14),
        decoration: InputDecoration(
          border: InputBorder.none,
          suffixText: suffix,
          suffixStyle: const TextStyle(color: Color(0xFF78829D), fontSize: 13),
        ),
      ),
    );
  }
}