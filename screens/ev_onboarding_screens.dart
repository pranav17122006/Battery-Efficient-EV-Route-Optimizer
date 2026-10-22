// // import 'package:flutter/material.dart';
// // import 'package:firebase_auth/firebase_auth.dart';
// // import 'package:cloud_firestore/cloud_firestore.dart';

// // class EVOnboardingScreen extends StatefulWidget {
// //   const EVOnboardingScreen({super.key});

// //   @override
// //   State<EVOnboardingScreen> createState() => _EVOnboardingScreenState();
// // }

// // class _EVOnboardingScreenState extends State<EVOnboardingScreen> {
// //   final PageController _pageController = PageController();
// //   int _currentPage = 0;
// //   bool _isLoading = false;

// //   // Step 1 Form Data
// //   String _selectedBrand = 'Tesla';
// //   String _selectedModel = 'Model 3';
// //   final TextEditingController _batteryCapacityCtrl = TextEditingController(text: '75');
// //   final TextEditingController _currentBatteryCtrl = TextEditingController(text: '72');
// //   final TextEditingController _consumptionCtrl = TextEditingController(text: '15.5');

// //   // Step 2 Form Data
// //   String _selectedChargerType = 'Fast';
// //   String _selectedMaxTime = '30m';
// //   bool _autoChargingStops = true;

// //   final List<String> _brands = ['Tesla', 'Hyundai', 'Porsche', 'BMW', 'Tata'];
// //   final List<String> _models = ['Model 3', 'Model Y', 'Model S', 'Ioniq 5', 'Taycan'];
// //   final List<String> _chargerTypes = ['Fast', 'Normal', 'Any'];
// //   final List<String> _timeLimits = ['15m', '30m', '45m', '60m'];

// //   @override
// //   void dispose() {
// //     _pageController.dispose();
// //     _batteryCapacityCtrl.dispose();
// //     _currentBatteryCtrl.dispose();
// //     _consumptionCtrl.dispose();
// //     super.dispose();
// //   }

// //   Future<void> _nextPage() async {
// //     if (_currentPage == 0) {
// //       _pageController.animateToPage(
// //         1,
// //         duration: const Duration(milliseconds: 300),
// //         curve: Curves.easeInOut,
// //       );
// //     } else {
// //       // Step 2 Complete -> Save Data to Firestore
// //       setState(() => _isLoading = true);
// //       try {
// //         final String? uid = FirebaseAuth.instance.currentUser?.uid;
        
// //         if (uid != null) {
// //           // Write document to 'users' collection
// //           await FirebaseFirestore.instance.collection('users').doc(uid).set({
// //             'vehicleBrand': _selectedBrand,
// //             'vehicleModel': _selectedModel,
// //             'batteryCapacityKwh': double.tryParse(_batteryCapacityCtrl.text) ?? 0.0,
// //             'currentBatteryPercent': int.tryParse(_currentBatteryCtrl.text) ?? 0,
// //             'avgConsumption': double.tryParse(_consumptionCtrl.text) ?? 0.0,
// //             'preferredCharger': _selectedChargerType,
// //             'maxChargingTime': _selectedMaxTime,
// //             'autoChargingStops': _autoChargingStops,
// //             'createdAt': FieldValue.serverTimestamp(),
// //           });
// //         }
        
// //         // Success -> Route to Dashboard
// //         if (mounted) {
// //           Navigator.pushNamedAndRemoveUntil(context, '/dashboard', (route) => false);
// //         }
        
// //       } catch (e) {
// //         if (mounted) {
// //           ScaffoldMessenger.of(context).showSnackBar(
// //             SnackBar(content: Text('Failed to save profile: $e')),
// //           );
// //         }
// //       } finally {
// //         if (mounted) setState(() => _isLoading = false);
// //       }
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       backgroundColor: const Color(0xFF070B16),
// //       body: SafeArea(
// //         child: Column(
// //           children: [
// //             const SizedBox(height: 12),
// //             // Top Progress Bar
// //             Padding(
// //               padding: const EdgeInsets.symmetric(horizontal: 24.0),
// //               child: Row(
// //                 children: [
// //                   Expanded(
// //                     child: Container(
// //                       height: 4,
// //                       decoration: BoxDecoration(color: const Color(0xFF1ECB6B), borderRadius: BorderRadius.circular(2)),
// //                     ),
// //                   ),
// //                   const SizedBox(width: 8),
// //                   Expanded(
// //                     child: Container(
// //                       height: 4,
// //                       decoration: BoxDecoration(
// //                         color: _currentPage >= 1 ? const Color(0xFF1ECB6B) : Colors.white.withOpacity(0.12),
// //                         borderRadius: BorderRadius.circular(2),
// //                       ),
// //                     ),
// //                   ),
// //                   const SizedBox(width: 8),
// //                   Expanded(
// //                     child: Container(
// //                       height: 4,
// //                       decoration: BoxDecoration(color: Colors.white.withOpacity(0.12), borderRadius: BorderRadius.circular(2)),
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             ),
// //             const SizedBox(height: 16),

// //             // Page View container for steps
// //             Expanded(
// //               child: PageView(
// //                 controller: _pageController,
// //                 physics: const NeverScrollableScrollPhysics(),
// //                 onPageChanged: (index) => setState(() => _currentPage = index),
// //                 children: [
// //                   _buildStep1(),
// //                   _buildStep2(),
// //                 ],
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   // ================= STEP 1: TELL US ABOUT YOUR EV =================
// //   Widget _buildStep1() {
// //     return SingleChildScrollView(
// //       padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           const Text('Tell us about your EV', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: -0.5)),
// //           const SizedBox(height: 8),
// //           const Text('We use these details to plan better routes for you.', style: TextStyle(fontSize: 14, color: Color(0xFF676E84))),
// //           const SizedBox(height: 24),

// //           // Vehicle Banner Card
// //           Container(
// //             padding: const EdgeInsets.all(16),
// //             decoration: BoxDecoration(
// //               color: const Color(0xFF0E1526),
// //               borderRadius: BorderRadius.circular(16),
// //               border: Border.all(color: Colors.white.withOpacity(0.04)),
// //             ),
// //             child: Row(
// //               children: [
// //                 Container(
// //                   padding: const EdgeInsets.all(10),
// //                   decoration: BoxDecoration(color: const Color(0xFF161E34), borderRadius: BorderRadius.circular(12)),
// //                   child: const Text('🚗', style: TextStyle(fontSize: 22)),
// //                 ),
// //                 const SizedBox(width: 14),
// //                 Expanded(
// //                   child: Column(
// //                     crossAxisAlignment: CrossAxisAlignment.start,
// //                     children: [
// //                       const Text('Selected Vehicle', style: TextStyle(fontSize: 12, color: Color(0xFF676E84))),
// //                       const SizedBox(height: 2),
// //                       Text('$_selectedBrand $_selectedModel', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
// //                     ],
// //                   ),
// //                 ),
// //                 Container(
// //                   padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
// //                   decoration: BoxDecoration(color: const Color(0xFF1ECB6B).withOpacity(0.12), borderRadius: BorderRadius.circular(20)),
// //                   child: const Text('Popular', style: TextStyle(color: Color(0xFF1ECB6B), fontSize: 11, fontWeight: FontWeight.bold)),
// //                 ),
// //               ],
// //             ),
// //           ),
// //           const SizedBox(height: 22),

// //           // Vehicle Brand
// //           _buildInputLabel('VEHICLE BRAND'),
// //           const SizedBox(height: 8),
// //           _buildDropdown(value: _selectedBrand, items: _brands, onChanged: (val) => setState(() => _selectedBrand = val!)),
// //           const SizedBox(height: 18),

// //           // Vehicle Model
// //           _buildInputLabel('VEHICLE MODEL'),
// //           const SizedBox(height: 8),
// //           _buildDropdown(value: _selectedModel, items: _models, onChanged: (val) => setState(() => _selectedModel = val!)),
// //           const SizedBox(height: 18),

// //           // Battery & Current %
// //           Row(
// //             children: [
// //               Expanded(
// //                 child: Column(
// //                   crossAxisAlignment: CrossAxisAlignment.start,
// //                   children: [
// //                     _buildInputLabel('BATTERY'),
// //                     const SizedBox(height: 8),
// //                     _buildMetricInput(controller: _batteryCapacityCtrl, suffixText: 'kWh', badgeText: 'capacity', badgeColor: const Color(0xFF4C5366)),
// //                   ],
// //                 ),
// //               ),
// //               const SizedBox(width: 14),
// //               Expanded(
// //                 child: Column(
// //                   crossAxisAlignment: CrossAxisAlignment.start,
// //                   children: [
// //                     _buildInputLabel('CURRENT %'),
// //                     const SizedBox(height: 8),
// //                     _buildMetricInput(
// //                       controller: _currentBatteryCtrl,
// //                       suffixText: '%',
// //                       textColor: const Color(0xFF1ECB6B),
// //                       badgeText: 'charged',
// //                       badgeColor: const Color(0xFF4C5366),
// //                       borderColor: const Color(0xFF1ECB6B).withOpacity(0.4),
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //             ],
// //           ),
// //           const SizedBox(height: 18),

// //           // Consumption
// //           _buildInputLabel('AVG. CONSUMPTION'),
// //           const SizedBox(height: 8),
// //           _buildMetricInput(controller: _consumptionCtrl, suffixText: 'kWh / 100 km', badgeText: 'Efficient', badgeColor: const Color(0xFF1ECB6B), isTag: true),
// //           const SizedBox(height: 32),

// //           // Continue Button
// //           SizedBox(
// //             width: double.infinity,
// //             height: 54,
// //             child: ElevatedButton(
// //               onPressed: _nextPage,
// //               style: ElevatedButton.styleFrom(
// //                 backgroundColor: const Color(0xFF1ECB6B),
// //                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
// //               ),
// //               child: const Row(
// //                 mainAxisAlignment: MainAxisAlignment.center,
// //                 children: [
// //                   Text('Continue', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF070B16))),
// //                   SizedBox(width: 6),
// //                   Icon(Icons.arrow_forward, size: 18, color: Color(0xFF070B16)),
// //                 ],
// //               ),
// //             ),
// //           ),
// //           const SizedBox(height: 20),
// //         ],
// //       ),
// //     );
// //   }

// //   // ================= STEP 2: CHARGING PREFERENCES =================
// //   Widget _buildStep2() {
// //     return SingleChildScrollView(
// //       padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           const Text('Charging preferences', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: -0.5)),
// //           const SizedBox(height: 8),
// //           const Text('Customize how stops are added to your routes.', style: TextStyle(fontSize: 14, color: Color(0xFF676E84))),
// //           const SizedBox(height: 24),

// //           // Preferred Charger Type
// //           Container(
// //             width: double.infinity,
// //             padding: const EdgeInsets.all(20),
// //             decoration: BoxDecoration(
// //               color: const Color(0xFF0E1526),
// //               borderRadius: BorderRadius.circular(20),
// //               border: Border.all(color: Colors.white.withOpacity(0.04)),
// //             ),
// //             child: Column(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 const Text('Preferred charger type', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)),
// //                 const SizedBox(height: 16),
// //                 Row(
// //                   children: _chargerTypes.map((type) {
// //                     final isSelected = _selectedChargerType == type;
// //                     return Expanded(
// //                       child: Padding(
// //                         padding: const EdgeInsets.symmetric(horizontal: 4.0),
// //                         child: GestureDetector(
// //                           onTap: () => setState(() => _selectedChargerType = type),
// //                           child: Container(
// //                             height: 48,
// //                             decoration: BoxDecoration(color: isSelected ? const Color(0xFF1ECB6B) : const Color(0xFF161F34), borderRadius: BorderRadius.circular(12)),
// //                             alignment: Alignment.center,
// //                             child: Text(type, style: TextStyle(color: isSelected ? const Color(0xFF070B16) : const Color(0xFF5A637C), fontWeight: FontWeight.bold, fontSize: 14)),
// //                           ),
// //                         ),
// //                       ),
// //                     );
// //                   }).toList(),
// //                 ),
// //               ],
// //             ),
// //           ),
// //           const SizedBox(height: 18),

// //           // Maximum Charging Time
// //           Container(
// //             width: double.infinity,
// //             padding: const EdgeInsets.all(20),
// //             decoration: BoxDecoration(
// //               color: const Color(0xFF0E1526),
// //               borderRadius: BorderRadius.circular(20),
// //               border: Border.all(color: Colors.white.withOpacity(0.04)),
// //             ),
// //             child: Column(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 const Text('Maximum charging time', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)),
// //                 const SizedBox(height: 16),
// //                 Row(
// //                   children: _timeLimits.map((time) {
// //                     final isSelected = _selectedMaxTime == time;
// //                     return Expanded(
// //                       child: Padding(
// //                         padding: const EdgeInsets.symmetric(horizontal: 4.0),
// //                         child: GestureDetector(
// //                           onTap: () => setState(() => _selectedMaxTime = time),
// //                           child: Container(
// //                             height: 48,
// //                             decoration: BoxDecoration(color: isSelected ? const Color(0xFF1ECB6B) : const Color(0xFF161F34), borderRadius: BorderRadius.circular(12)),
// //                             alignment: Alignment.center,
// //                             child: Text(time, style: TextStyle(color: isSelected ? const Color(0xFF070B16) : const Color(0xFF5A637C), fontWeight: FontWeight.bold, fontSize: 13)),
// //                           ),
// //                         ),
// //                       ),
// //                     );
// //                   }).toList(),
// //                 ),
// //               ],
// //             ),
// //           ),
// //           const SizedBox(height: 18),

// //           // Auto Charging Stops
// //           Container(
// //             padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
// //             decoration: BoxDecoration(
// //               color: const Color(0xFF0E1526),
// //               borderRadius: BorderRadius.circular(20),
// //               border: Border.all(color: Colors.white.withOpacity(0.04)),
// //             ),
// //             child: Row(
// //               children: [
// //                 Expanded(
// //                   child: Column(
// //                     crossAxisAlignment: CrossAxisAlignment.start,
// //                     children: const [
// //                       Text('Auto charging stops', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)),
// //                       SizedBox(height: 4),
// //                       Text('Automatically include stops in routes', style: TextStyle(fontSize: 12, color: Color(0xFF676E84))),
// //                     ],
// //                   ),
// //                 ),
// //                 Switch(
// //                   value: _autoChargingStops,
// //                   activeColor: Colors.white,
// //                   activeTrackColor: const Color(0xFF1ECB6B),
// //                   inactiveThumbColor: const Color(0xFF676E84),
// //                   inactiveTrackColor: const Color(0xFF161F34),
// //                   onChanged: (val) => setState(() => _autoChargingStops = val),
// //                 ),
// //               ],
// //             ),
// //           ),
// //           const SizedBox(height: 36),

// //           // Save & Continue Button
// //           SizedBox(
// //             width: double.infinity,
// //             height: 54,
// //             child: ElevatedButton(
// //               onPressed: _isLoading ? null : _nextPage,
// //               style: ElevatedButton.styleFrom(
// //                 backgroundColor: const Color(0xFF1ECB6B),
// //                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
// //               ),
// //               child: _isLoading 
// //                   ? const SizedBox(
// //                       width: 24, 
// //                       height: 24, 
// //                       child: CircularProgressIndicator(color: Color(0xFF070B16), strokeWidth: 3)
// //                     )
// //                   : const Text('Save & Continue', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF070B16))),
// //             ),
// //           ),
// //           const SizedBox(height: 20),
// //         ],
// //       ),
// //     );
// //   }

// //   // Helpers
// //   Widget _buildInputLabel(String label) {
// //     return Text(label, style: const TextStyle(fontSize: 11, letterSpacing: 1.1, fontWeight: FontWeight.w700, color: Color(0xFF78829D)));
// //   }

// //   Widget _buildDropdown({required String value, required List<String> items, required ValueChanged<String?> onChanged}) {
// //     return Container(
// //       padding: const EdgeInsets.symmetric(horizontal: 16),
// //       decoration: BoxDecoration(color: const Color(0xFF0E1424), borderRadius: BorderRadius.circular(14), border: Border.all(color: Colors.white.withOpacity(0.04))),
// //       child: DropdownButtonHideUnderline(
// //         child: DropdownButton<String>(
// //           value: value,
// //           dropdownColor: const Color(0xFF101728),
// //           icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF78829D)),
// //           isExpanded: true,
// //           style: const TextStyle(color: Colors.white, fontSize: 14),
// //           onChanged: onChanged,
// //           items: items.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _buildMetricInput({
// //     required TextEditingController controller,
// //     required String suffixText,
// //     required String badgeText,
// //     required Color badgeColor,
// //     Color textColor = Colors.white,
// //     Color? borderColor,
// //     bool isTag = false,
// //   }) {
// //     return Container(
// //       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
// //       decoration: BoxDecoration(color: const Color(0xFF0E1424), borderRadius: BorderRadius.circular(14), border: Border.all(color: borderColor ?? Colors.white.withOpacity(0.04))),
// //       child: Row(
// //         children: [
// //           Expanded(
// //             child: TextField(
// //               controller: controller,
// //               style: TextStyle(color: textColor, fontSize: 14, fontWeight: FontWeight.w600),
// //               decoration: InputDecoration(
// //                 border: InputBorder.none,
// //                 suffixText: suffixText,
// //                 suffixStyle: TextStyle(color: textColor, fontSize: 14, fontWeight: FontWeight.w600),
// //               ),
// //             ),
// //           ),
// //           if (isTag)
// //             Container(
// //               padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
// //               decoration: BoxDecoration(color: badgeColor.withOpacity(0.12), borderRadius: BorderRadius.circular(8)),
// //               child: Text(badgeText, style: TextStyle(color: badgeColor, fontSize: 11, fontWeight: FontWeight.bold)),
// //             )
// //           else
// //             Text(badgeText, style: TextStyle(color: badgeColor, fontSize: 12)),
// //         ],
// //       ),
// //     );
// //   }
// // }



// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class EVOnboardingScreen extends StatefulWidget {
//   const EVOnboardingScreen({super.key});

//   @override
//   State<EVOnboardingScreen> createState() => _EVOnboardingScreenState();
// }

// class _EVOnboardingScreenState extends State<EVOnboardingScreen> {
//   final PageController _pageController = PageController();
//   int _currentPage = 0;
//   bool _isLoading = false;

//   // Step 1 Form Data
//   String _selectedBrand = 'Tesla';
//   String _selectedModel = 'Model 3';
//   final TextEditingController _batteryCapacityCtrl = TextEditingController(text: '75');
//   final TextEditingController _consumptionCtrl = TextEditingController(text: '15.5');

//   // Step 2 Form Data
//   String _selectedChargerType = 'Fast';
//   String _selectedMaxTime = '30m';
//   bool _autoChargingStops = true;

//   final List<String> _brands = ['Tesla', 'Hyundai', 'Porsche', 'BMW', 'Tata'];
//   final List<String> _models = ['Model 3', 'Model Y', 'Model S', 'Ioniq 5', 'Taycan'];
//   final List<String> _chargerTypes = ['Fast', 'Normal', 'Any'];
//   final List<String> _timeLimits = ['15m', '30m', '45m', '60m'];

//   @override
//   void dispose() {
//     _pageController.dispose();
//     _batteryCapacityCtrl.dispose();
//     _consumptionCtrl.dispose();
//     super.dispose();
//   }

//   Future<void> _nextPage() async {
//     if (_currentPage == 0) {
//       _pageController.animateToPage(
//         1,
//         duration: const Duration(milliseconds: 300),
//         curve: Curves.easeInOut,
//       );
//     } else {
//       // Step 2 Complete -> Save Data to Firestore
//       setState(() => _isLoading = true);
//       try {
//         final String? uid = FirebaseAuth.instance.currentUser?.uid;
        
//         if (uid != null) {
//           await FirebaseFirestore.instance.collection('users').doc(uid).set({
//             'vehicleBrand': _selectedBrand,
//             'vehicleModel': _selectedModel,
//             'batteryCapacityKwh': double.tryParse(_batteryCapacityCtrl.text) ?? 0.0,
//             'avgConsumption': double.tryParse(_consumptionCtrl.text) ?? 0.0,
//             'preferredCharger': _selectedChargerType,
//             'maxChargingTime': _selectedMaxTime,
//             'autoChargingStops': _autoChargingStops,
//             'createdAt': FieldValue.serverTimestamp(),
//           });
//         }
        
//         if (mounted) {
//           Navigator.pushNamedAndRemoveUntil(context, '/dashboard', (route) => false);
//         }
        
//       } catch (e) {
//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text('Failed to save profile: $e')),
//           );
//         }
//       } finally {
//         if (mounted) setState(() => _isLoading = false);
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF070B16),
//       body: SafeArea(
//         child: Column(
//           children: [
//             const SizedBox(height: 12),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 24.0),
//               child: Row(
//                 children: [
//                   Expanded(child: Container(height: 4, decoration: BoxDecoration(color: const Color(0xFF1ECB6B), borderRadius: BorderRadius.circular(2)))),
//                   const SizedBox(width: 8),
//                   Expanded(child: Container(height: 4, decoration: BoxDecoration(color: _currentPage >= 1 ? const Color(0xFF1ECB6B) : Colors.white.withOpacity(0.12), borderRadius: BorderRadius.circular(2)))),
//                   const SizedBox(width: 8),
//                   Expanded(child: Container(height: 4, decoration: BoxDecoration(color: Colors.white.withOpacity(0.12), borderRadius: BorderRadius.circular(2)))),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 16),
//             Expanded(
//               child: PageView(
//                 controller: _pageController,
//                 physics: const NeverScrollableScrollPhysics(),
//                 onPageChanged: (index) => setState(() => _currentPage = index),
//                 children: [_buildStep1(), _buildStep2()],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // ================= STEP 1 =================
//   Widget _buildStep1() {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text('Tell us about your EV', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: -0.5)),
//           const SizedBox(height: 8),
//           const Text('We use these details to plan better routes for you.', style: TextStyle(fontSize: 14, color: Color(0xFF676E84))),
//           const SizedBox(height: 24),

//           Container(
//             padding: const EdgeInsets.all(16),
//             decoration: BoxDecoration(color: const Color(0xFF0E1526), borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.white.withOpacity(0.04))),
//             child: Row(
//               children: [
//                 Container(
//                   padding: const EdgeInsets.all(10),
//                   decoration: BoxDecoration(color: const Color(0xFF161E34), borderRadius: BorderRadius.circular(12)),
//                   child: const Text('🚗', style: TextStyle(fontSize: 22)),
//                 ),
//                 const SizedBox(width: 14),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text('Selected Vehicle', style: TextStyle(fontSize: 12, color: Color(0xFF676E84))),
//                       const SizedBox(height: 2),
//                       Text('$_selectedBrand $_selectedModel', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
//                     ],
//                   ),
//                 ),
//                 Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
//                   decoration: BoxDecoration(color: const Color(0xFF1ECB6B).withOpacity(0.12), borderRadius: BorderRadius.circular(20)),
//                   child: const Text('Popular', style: TextStyle(color: Color(0xFF1ECB6B), fontSize: 11, fontWeight: FontWeight.bold)),
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(height: 22),

//           _buildInputLabel('VEHICLE BRAND'),
//           const SizedBox(height: 8),
//           _buildDropdown(value: _selectedBrand, items: _brands, onChanged: (val) => setState(() => _selectedBrand = val!)),
//           const SizedBox(height: 18),

//           _buildInputLabel('VEHICLE MODEL'),
//           const SizedBox(height: 8),
//           _buildDropdown(value: _selectedModel, items: _models, onChanged: (val) => setState(() => _selectedModel = val!)),
//           const SizedBox(height: 18),

//           // Battery capacity (Full width now, Current % removed)
//           _buildInputLabel('BATTERY'),
//           const SizedBox(height: 8),
//           _buildMetricInput(controller: _batteryCapacityCtrl, suffixText: 'kWh', badgeText: 'capacity', badgeColor: const Color(0xFF4C5366)),
//           const SizedBox(height: 18),

//           _buildInputLabel('AVG. CONSUMPTION'),
//           const SizedBox(height: 8),
//           _buildMetricInput(controller: _consumptionCtrl, suffixText: 'kWh / 100 km', badgeText: 'Efficient', badgeColor: const Color(0xFF1ECB6B), isTag: true),
//           const SizedBox(height: 32),

//           SizedBox(
//             width: double.infinity,
//             height: 54,
//             child: ElevatedButton(
//               onPressed: _nextPage,
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: const Color(0xFF1ECB6B),
//                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//               ),
//               child: const Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text('Continue', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF070B16))),
//                   SizedBox(width: 6),
//                   Icon(Icons.arrow_forward, size: 18, color: Color(0xFF070B16)),
//                 ],
//               ),
//             ),
//           ),
//           const SizedBox(height: 20),
//         ],
//       ),
//     );
//   }

//   // ================= STEP 2 =================
//   Widget _buildStep2() {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text('Charging preferences', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: -0.5)),
//           const SizedBox(height: 8),
//           const Text('Customize how stops are added to your routes.', style: TextStyle(fontSize: 14, color: Color(0xFF676E84))),
//           const SizedBox(height: 24),

//           Container(
//             width: double.infinity,
//             padding: const EdgeInsets.all(20),
//             decoration: BoxDecoration(color: const Color(0xFF0E1526), borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.white.withOpacity(0.04))),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text('Preferred charger type', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)),
//                 const SizedBox(height: 16),
//                 Row(
//                   children: _chargerTypes.map((type) {
//                     final isSelected = _selectedChargerType == type;
//                     return Expanded(
//                       child: Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 4.0),
//                         child: GestureDetector(
//                           onTap: () => setState(() => _selectedChargerType = type),
//                           child: Container(
//                             height: 48,
//                             decoration: BoxDecoration(color: isSelected ? const Color(0xFF1ECB6B) : const Color(0xFF161F34), borderRadius: BorderRadius.circular(12)),
//                             alignment: Alignment.center,
//                             child: Text(type, style: TextStyle(color: isSelected ? const Color(0xFF070B16) : const Color(0xFF5A637C), fontWeight: FontWeight.bold, fontSize: 14)),
//                           ),
//                         ),
//                       ),
//                     );
//                   }).toList(),
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(height: 18),

//           Container(
//             width: double.infinity,
//             padding: const EdgeInsets.all(20),
//             decoration: BoxDecoration(color: const Color(0xFF0E1526), borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.white.withOpacity(0.04))),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text('Maximum charging time', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)),
//                 const SizedBox(height: 16),
//                 Row(
//                   children: _timeLimits.map((time) {
//                     final isSelected = _selectedMaxTime == time;
//                     return Expanded(
//                       child: Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 4.0),
//                         child: GestureDetector(
//                           onTap: () => setState(() => _selectedMaxTime = time),
//                           child: Container(
//                             height: 48,
//                             decoration: BoxDecoration(color: isSelected ? const Color(0xFF1ECB6B) : const Color(0xFF161F34), borderRadius: BorderRadius.circular(12)),
//                             alignment: Alignment.center,
//                             child: Text(time, style: TextStyle(color: isSelected ? const Color(0xFF070B16) : const Color(0xFF5A637C), fontWeight: FontWeight.bold, fontSize: 13)),
//                           ),
//                         ),
//                       ),
//                     );
//                   }).toList(),
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(height: 18),

//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
//             decoration: BoxDecoration(color: const Color(0xFF0E1526), borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.white.withOpacity(0.04))),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: const [
//                       Text('Auto charging stops', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)),
//                       SizedBox(height: 4),
//                       Text('Automatically include stops in routes', style: TextStyle(fontSize: 12, color: Color(0xFF676E84))),
//                     ],
//                   ),
//                 ),
//                 Switch(
//                   value: _autoChargingStops,
//                   activeColor: Colors.white,
//                   activeTrackColor: const Color(0xFF1ECB6B),
//                   inactiveThumbColor: const Color(0xFF676E84),
//                   inactiveTrackColor: const Color(0xFF161F34),
//                   onChanged: (val) => setState(() => _autoChargingStops = val),
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(height: 36),

//           SizedBox(
//             width: double.infinity,
//             height: 54,
//             child: ElevatedButton(
//               onPressed: _isLoading ? null : _nextPage,
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: const Color(0xFF1ECB6B),
//                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//               ),
//               child: _isLoading 
//                   ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Color(0xFF070B16), strokeWidth: 3))
//                   : const Text('Save & Continue', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF070B16))),
//             ),
//           ),
//           const SizedBox(height: 20),
//         ],
//       ),
//     );
//   }

//   Widget _buildInputLabel(String label) {
//     return Text(label, style: const TextStyle(fontSize: 11, letterSpacing: 1.1, fontWeight: FontWeight.w700, color: Color(0xFF78829D)));
//   }

//   Widget _buildDropdown({required String value, required List<String> items, required ValueChanged<String?> onChanged}) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 16),
//       decoration: BoxDecoration(color: const Color(0xFF0E1424), borderRadius: BorderRadius.circular(14), border: Border.all(color: Colors.white.withOpacity(0.04))),
//       child: DropdownButtonHideUnderline(
//         child: DropdownButton<String>(
//           value: value, dropdownColor: const Color(0xFF101728), isExpanded: true,
//           style: const TextStyle(color: Colors.white, fontSize: 14),
//           onChanged: onChanged,
//           items: items.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
//         ),
//       ),
//     );
//   }

//   Widget _buildMetricInput({required TextEditingController controller, required String suffixText, required String badgeText, required Color badgeColor, bool isTag = false}) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
//       decoration: BoxDecoration(color: const Color(0xFF0E1424), borderRadius: BorderRadius.circular(14), border: Border.all(color: Colors.white.withOpacity(0.04))),
//       child: Row(
//         children: [
//           Expanded(
//             child: TextField(
//               controller: controller,
//               style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
//               decoration: InputDecoration(
//                 border: InputBorder.none, suffixText: suffixText, suffixStyle: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
//               ),
//             ),
//           ),
//           if (isTag)
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
//               decoration: BoxDecoration(color: badgeColor.withOpacity(0.12), borderRadius: BorderRadius.circular(8)),
//               child: Text(badgeText, style: TextStyle(color: badgeColor, fontSize: 11, fontWeight: FontWeight.bold)),
//             )
//           else
//             Text(badgeText, style: TextStyle(color: badgeColor, fontSize: 12)),
//         ],
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EVOnboardingScreen extends StatefulWidget {
  const EVOnboardingScreen({super.key});

  @override
  State<EVOnboardingScreen> createState() => _EVOnboardingScreenState();
}

class _EVOnboardingScreenState extends State<EVOnboardingScreen> {
  bool _isLoading = false;

  // Form Data
  String _selectedBrand = 'Tesla';
  String _selectedModel = 'Model 3';
  final TextEditingController _batteryCapacityCtrl = TextEditingController(text: '75');
  final TextEditingController _consumptionCtrl = TextEditingController(text: '15.5');

  final List<String> _brands = ['Tesla', 'Hyundai', 'Porsche', 'BMW', 'Tata', 'Kia', 'BYD'];
  final List<String> _models = ['Model 3', 'Model Y', 'Model S', 'Ioniq 5', 'Taycan', 'EV6', 'Nexon EV'];

  @override
  void dispose() {
    _batteryCapacityCtrl.dispose();
    _consumptionCtrl.dispose();
    super.dispose();
  }

  Future<void> _saveAndContinue() async {
    setState(() => _isLoading = true);
    
    try {
      final String? uid = FirebaseAuth.instance.currentUser?.uid;
      
      if (uid != null) {
        // Save only the EV data to Firestore
        await FirebaseFirestore.instance.collection('users').doc(uid).set({
          'vehicleBrand': _selectedBrand,
          'vehicleModel': _selectedModel,
          'batteryCapacityKwh': double.tryParse(_batteryCapacityCtrl.text) ?? 0.0,
          'avgConsumption': double.tryParse(_consumptionCtrl.text) ?? 0.0,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }
      
      // Navigate to Dashboard
      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(context, '/dashboard', (route) => false);
      }
      
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save profile: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF070B16),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Tell us about your EV', 
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: -0.5)
              ),
              const SizedBox(height: 8),
              const Text(
                'We use these details to plan better routes for you.', 
                style: TextStyle(fontSize: 14, color: Color(0xFF676E84))
              ),
              const SizedBox(height: 32),

              // Vehicle Banner Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF0E1526), 
                  borderRadius: BorderRadius.circular(16), 
                  border: Border.all(color: Colors.white.withOpacity(0.04))
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(color: const Color(0xFF161E34), borderRadius: BorderRadius.circular(12)),
                      child: const Text('🚗', style: TextStyle(fontSize: 22)),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Selected Vehicle', style: TextStyle(fontSize: 12, color: Color(0xFF676E84))),
                          const SizedBox(height: 2),
                          Text('$_selectedBrand $_selectedModel', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(color: const Color(0xFF1ECB6B).withOpacity(0.12), borderRadius: BorderRadius.circular(20)),
                      child: const Text('Popular', style: TextStyle(color: Color(0xFF1ECB6B), fontSize: 11, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Dropdowns
              _buildInputLabel('VEHICLE BRAND'),
              const SizedBox(height: 8),
              _buildDropdown(value: _selectedBrand, items: _brands, onChanged: (val) => setState(() => _selectedBrand = val!)),
              const SizedBox(height: 18),

              _buildInputLabel('VEHICLE MODEL'),
              const SizedBox(height: 8),
              _buildDropdown(value: _selectedModel, items: _models, onChanged: (val) => setState(() => _selectedModel = val!)),
              const SizedBox(height: 18),

              // Text Inputs
              _buildInputLabel('BATTERY'),
              const SizedBox(height: 8),
              _buildMetricInput(controller: _batteryCapacityCtrl, suffixText: 'kWh', badgeText: 'capacity', badgeColor: const Color(0xFF4C5366)),
              const SizedBox(height: 18),

              _buildInputLabel('AVG. CONSUMPTION'),
              const SizedBox(height: 8),
              _buildMetricInput(controller: _consumptionCtrl, suffixText: 'kWh / 100 km', badgeText: 'Efficient', badgeColor: const Color(0xFF1ECB6B), isTag: true),
              const SizedBox(height: 36),

              // Save & Continue Button
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveAndContinue,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1ECB6B),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: _isLoading
                      ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Color(0xFF070B16), strokeWidth: 3))
                      : const Text('Save & Continue', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF070B16))),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // --- Helper Widgets ---
  Widget _buildInputLabel(String label) {
    return Text(label, style: const TextStyle(fontSize: 11, letterSpacing: 1.1, fontWeight: FontWeight.w700, color: Color(0xFF78829D)));
  }

  Widget _buildDropdown({required String value, required List<String> items, required ValueChanged<String?> onChanged}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(color: const Color(0xFF0E1424), borderRadius: BorderRadius.circular(14), border: Border.all(color: Colors.white.withOpacity(0.04))),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value, 
          dropdownColor: const Color(0xFF101728), 
          isExpanded: true,
          style: const TextStyle(color: Colors.white, fontSize: 14),
          onChanged: onChanged,
          items: items.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
        ),
      ),
    );
  }

  Widget _buildMetricInput({required TextEditingController controller, required String suffixText, required String badgeText, required Color badgeColor, bool isTag = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(color: const Color(0xFF0E1424), borderRadius: BorderRadius.circular(14), border: Border.all(color: Colors.white.withOpacity(0.04))),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
              decoration: InputDecoration(
                border: InputBorder.none, 
                suffixText: suffixText, 
                suffixStyle: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
              ),
            ),
          ),
          if (isTag)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(color: badgeColor.withOpacity(0.12), borderRadius: BorderRadius.circular(8)),
              child: Text(badgeText, style: TextStyle(color: badgeColor, fontSize: 11, fontWeight: FontWeight.bold)),
            )
          else
            Text(badgeText, style: TextStyle(color: badgeColor, fontSize: 12)),
        ],
      ),
    );
  }
}