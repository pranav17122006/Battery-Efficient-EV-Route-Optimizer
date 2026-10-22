import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF070B16),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 12),

              // Top Tag Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: const Color(0xFF1ECB6B).withOpacity(0.3),
                    width: 1.5,
                  ),
                ),
                child: const Text(
                  'INTELLIGENT EV NAVIGATION',
                  style: TextStyle(
                    color: Color(0xFF1ECB6B),
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Main Heading (Fixed FontWeight.w800)
              const Text(
                'Plan smarter\nEV journeys',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 34,
                  fontWeight: FontWeight.w800,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 14),

              // Subheading
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Find routes that balance distance,\ntravel time and battery consumption.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF676E84),
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
              ),
              const Spacer(),

              // EV Vector Artwork
              const _EVIllustration(),
              const Spacer(),

              // Quick Info Cards
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: _buildInfoCard(
                      icon: const Icon(Icons.battery_saver, color: Color(0xFF99FF55), size: 28),
                      title: 'Save\nBattery',
                      subtitle: 'Up to 15%\nmore range',
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildInfoCard(
                      icon: const Icon(Icons.bolt, color: Colors.amber, size: 28),
                      title: 'Find\nChargers',
                      subtitle: '8,000+\nstations',
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildInfoCard(
                      icon: const Icon(Icons.map, color: Colors.blueAccent, size: 28),
                      title: 'Optimize',
                      subtitle: 'Smart routing\n ',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Action: Get Started -> Sign Up
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: () => Navigator.pushNamed(context, '/signup'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1ECB6B),
                    foregroundColor: const Color(0xFF070B16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  child: const Text('Get Started'),
                ),
              ),
              const SizedBox(height: 12),

              // Action: Login
              SizedBox(
                width: double.infinity,
                height: 54,
                child: OutlinedButton(
                  onPressed: () => Navigator.pushNamed(context, '/login'),
                  style: OutlinedButton.styleFrom(
                    backgroundColor: const Color(0xFF121829),
                    side: BorderSide(
                      color: Colors.white.withOpacity(0.05),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'Login',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required Widget icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF0F1528),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.04),
        ),
      ),
      child: Column(
        children: [
          icon,
          const SizedBox(height: 10),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 10,
              color: Color(0xFF4C5366),
            ),
          ),
        ],
      ),
    );
  }
}

class _EVIllustration extends StatelessWidget {
  const _EVIllustration();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 110,
      width: 280,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            bottom: 24,
            left: 0,
            right: 0,
            child: Container(
              height: 2,
              color: Colors.white.withOpacity(0.1),
            ),
          ),
          // Charging terminal
          Positioned(
            bottom: 20,
            right: 20,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end, // Fixed CrossAxisAlignment.end
              children: [
                Container(
                  width: 30,
                  height: 2,
                  color: const Color(0xFF1ECB6B).withOpacity(0.4),
                ),
                Container(
                  width: 14,
                  height: 32,
                  decoration: BoxDecoration(
                    color: const Color(0xFF0C1D1A),
                    border: Border.all(color: const Color(0xFF1ECB6B), width: 1.5),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Center(
                    child: Container(
                      width: 4,
                      height: 4,
                      decoration: const BoxDecoration(
                        color: Color(0xFF1ECB6B),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Vehicle
          Positioned(
            bottom: 20,
            left: 45,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 50,
                  height: 12,
                  decoration: BoxDecoration(
                    color: const Color(0xFF14243A),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(3),
                      topRight: Radius.circular(3),
                    ),
                    border: Border.all(color: Colors.white.withOpacity(0.1)),
                  ),
                ),
                Container(
                  width: 2,
                  height: 4,
                  color: const Color(0xFF1ECB6B),
                ),
                Container(
                  width: 130,
                  height: 32,
                  decoration: BoxDecoration(
                    color: const Color(0xFF141F2E),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: Colors.white.withOpacity(0.08)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(left: 6),
                        width: 8,
                        height: 14,
                        decoration: BoxDecoration(
                          color: const Color(0xFF1ECB6B),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(right: 6),
                        width: 8,
                        height: 14,
                        decoration: BoxDecoration(
                          color: const Color(0xFF1ECB6B),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 12,
            left: 75,
            child: _buildGlowingWheel(),
          ),
          Positioned(
            bottom: 12,
            left: 155,
            child: _buildGlowingWheel(),
          ),
          const Positioned(
            top: 40,
            left: 118,
            child: Icon(Icons.flash_on, color: Color(0xFF1ECB6B), size: 24),
          ),
        ],
      ),
    );
  }

  Widget _buildGlowingWheel() {
    return Container(
      width: 26,
      height: 26,
      decoration: BoxDecoration(
        color: const Color(0xFF070B16),
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFF1ECB6B), width: 3),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1ECB6B).withOpacity(0.4),
            blurRadius: 4,
            spreadRadius: 1.5,
          ),
        ],
      ),
      child: Center(
        child: Container(
          width: 8,
          height: 8,
          decoration: const BoxDecoration(
            color: Color(0xFF1ECB6B),
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}