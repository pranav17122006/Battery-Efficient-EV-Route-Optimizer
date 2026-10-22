// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});

//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   final _formKey = GlobalKey<FormState>();

//   bool _obscurePassword = true;
//   bool _isLoading = false;

//   @override
//   void dispose() {
//     _emailController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }

//   Future<void> _handleLogin() async {
//     if (_formKey.currentState!.validate()) {
//       setState(() => _isLoading = true);
//       try {
//         // Authenticate with Firebase
//         await FirebaseAuth.instance.signInWithEmailAndPassword(
//           email: _emailController.text.trim(),
//           password: _passwordController.text.trim(),
//         );
        
//         // Navigate to Dashboard on success
//         if (mounted) Navigator.pushNamedAndRemoveUntil(context, '/dashboard', (route) => false);
        
//       } on FirebaseAuthException catch (e) {
//         String message = 'Login failed';
//         if (e.code == 'user-not-found' || e.code == 'wrong-password' || e.code == 'invalid-credential') {
//           message = 'Invalid email or password.';
//         }
//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
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
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Back Button
//                 Container(
//                   decoration: BoxDecoration(
//                     color: const Color(0xFF101728),
//                     borderRadius: BorderRadius.circular(12),
//                     border: Border.all(color: Colors.white.withOpacity(0.05)),
//                   ),
//                   child: IconButton(
//                     icon: const Icon(Icons.arrow_back_ios_new, size: 18, color: Colors.white),
//                     onPressed: () {
//                       if (Navigator.canPop(context)) Navigator.pop(context);
//                       else Navigator.pushReplacementNamed(context, '/');
//                     },
//                   ),
//                 ),
//                 const SizedBox(height: 28),

//                 // Title
//                 const Text(
//                   'Welcome back',
//                   style: TextStyle(
//                     fontSize: 32,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white,
//                     letterSpacing: -0.5,
//                   ),
//                 ),
//                 const SizedBox(height: 8),

//                 // Subtitle
//                 const Text(
//                   'Sign in to continue your journey.',
//                   style: TextStyle(fontSize: 14, color: Color(0xFF676E84)),
//                 ),
//                 const SizedBox(height: 36),

//                 // Email
//                 _buildInputLabel('EMAIL'),
//                 const SizedBox(height: 8),
//                 _buildTextField(
//                   controller: _emailController,
//                   hintText: 'you@example.com',
//                   keyboardType: TextInputType.emailAddress,
//                   validator: (value) => value == null || value.trim().isEmpty ? 'Please enter your email' : null,
//                 ),
//                 const SizedBox(height: 20),

//                 // Password
//                 _buildInputLabel('PASSWORD'),
//                 const SizedBox(height: 8),
//                 _buildTextField(
//                   controller: _passwordController,
//                   hintText: '••••••••',
//                   obscureText: _obscurePassword,
//                   suffixIcon: IconButton(
//                     icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility, color: const Color(0xFF4C5366), size: 20),
//                     onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
//                   ),
//                   validator: (value) => value == null || value.isEmpty ? 'Please enter your password' : null,
//                 ),
//                 const SizedBox(height: 14),

//                 // Forgot Password Link
//                 Align(
//                   alignment: Alignment.centerRight,
//                   child: GestureDetector(
//                     onTap: () {},
//                     child: const Text('Forgot password?', style: TextStyle(color: Color(0xFF1ECB6B), fontWeight: FontWeight.w600, fontSize: 13)),
//                   ),
//                 ),
//                 const SizedBox(height: 28),

//                 // Login Button
//                 SizedBox(
//                   width: double.infinity,
//                   height: 54,
//                   child: ElevatedButton(
//                     onPressed: _isLoading ? null : _handleLogin,
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: const Color(0xFF1ECB6B),
//                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//                     ),
//                     child: _isLoading
//                         ? const SizedBox(
//                             width: 24,
//                             height: 24,
//                             child: CircularProgressIndicator(color: Color(0xFF070B16), strokeWidth: 3),
//                           )
//                         : const Text(
//                             'Login',
//                             style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF070B16)),
//                           ),
//                   ),
//                 ),
//                 const SizedBox(height: 28),

//                 // Divider: "or continue with"
//                 Row(
//                   children: [
//                     Expanded(child: Container(height: 1, color: Colors.white.withOpacity(0.08))),
//                     const Padding(
//                       padding: EdgeInsets.symmetric(horizontal: 12.0),
//                       child: Text('or continue with', style: TextStyle(color: Color(0xFF4E566B), fontSize: 12)),
//                     ),
//                     Expanded(child: Container(height: 1, color: Colors.white.withOpacity(0.08))),
//                   ],
//                 ),
//                 const SizedBox(height: 24),

//                 // Google Button Placeholder
//                 SizedBox(
//                   width: double.infinity,
//                   height: 54,
//                   child: OutlinedButton(
//                     onPressed: () {},
//                     style: OutlinedButton.styleFrom(
//                       backgroundColor: const Color(0xFF101728),
//                       side: BorderSide(color: Colors.white.withOpacity(0.06)),
//                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//                     ),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: const [
//                         Icon(Icons.g_mobiledata, color: Colors.white, size: 28),
//                         SizedBox(width: 8),
//                         Text('Continue with Google', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600)),
//                       ],
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 32),

//                 // Bottom Create Account Link
//                 Center(
//                   child: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       const Text("Don't have an account? ", style: TextStyle(color: Color(0xFF676E84), fontSize: 14)),
//                       GestureDetector(
//                         onTap: () => Navigator.pushReplacementNamed(context, '/signup'),
//                         child: const Text('Create one', style: TextStyle(color: Color(0xFF1ECB6B), fontWeight: FontWeight.bold, fontSize: 14)),
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildInputLabel(String label) {
//     return Text(label, style: const TextStyle(fontSize: 11, letterSpacing: 1.1, fontWeight: FontWeight.w700, color: Color(0xFF78829D)));
//   }

//   Widget _buildTextField({
//     required TextEditingController controller,
//     required String hintText,
//     bool obscureText = false,
//     TextInputType keyboardType = TextInputType.text,
//     Widget? suffixIcon,
//     String? Function(String?)? validator,
//   }) {
//     return Container(
//       decoration: BoxDecoration(
//         color: const Color(0xFF0E1424),
//         borderRadius: BorderRadius.circular(14),
//         border: Border.all(color: Colors.white.withOpacity(0.04)),
//       ),
//       child: TextFormField(
//         controller: controller,
//         obscureText: obscureText,
//         keyboardType: keyboardType,
//         validator: validator,
//         style: const TextStyle(color: Colors.white, fontSize: 14),
//         decoration: InputDecoration(
//           contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//           border: InputBorder.none,
//           hintText: hintText,
//           hintStyle: const TextStyle(color: Color(0xFF384056), fontSize: 14),
//           suffixIcon: suffixIcon,
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        // Authenticate with Firebase
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
        
        // Navigate to Dashboard on success
        if (mounted) {
          Navigator.pushNamedAndRemoveUntil(context, '/dashboard', (route) => false);
        }
        
      } on FirebaseAuthException catch (e) {
        String message = 'Login failed';
        if (e.code == 'user-not-found' || e.code == 'wrong-password' || e.code == 'invalid-credential') {
          message = 'Invalid email or password.';
        }
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
        }
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF070B16),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Back Button
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF101728),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white.withOpacity(0.05)),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new, size: 18, color: Colors.white),
                    onPressed: () {
                      if (Navigator.canPop(context)) {
                        Navigator.pop(context);
                      } else {
                        Navigator.pushReplacementNamed(context, '/');
                      }
                    },
                  ),
                ),
                const SizedBox(height: 28),

                // Title
                const Text(
                  'Welcome back',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 8),

                // Subtitle
                const Text(
                  'Sign in to continue your journey.',
                  style: TextStyle(fontSize: 14, color: Color(0xFF676E84)),
                ),
                const SizedBox(height: 36),

                // Email
                _buildInputLabel('EMAIL'),
                const SizedBox(height: 8),
                _buildTextField(
                  controller: _emailController,
                  hintText: 'you@example.com',
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) => value == null || value.trim().isEmpty ? 'Please enter your email' : null,
                ),
                const SizedBox(height: 20),

                // Password
                _buildInputLabel('PASSWORD'),
                const SizedBox(height: 8),
                _buildTextField(
                  controller: _passwordController,
                  hintText: '••••••••',
                  obscureText: _obscurePassword,
                  suffixIcon: IconButton(
                    icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility, color: const Color(0xFF4C5366), size: 20),
                    onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                  ),
                  validator: (value) => value == null || value.isEmpty ? 'Please enter your password' : null,
                ),
                const SizedBox(height: 14),

                // Forgot Password Link
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {},
                    child: const Text(
                      'Forgot password?', 
                      style: TextStyle(color: Color(0xFF1ECB6B), fontWeight: FontWeight.w600, fontSize: 13),
                    ),
                  ),
                ),
                const SizedBox(height: 28),

                // Login Button
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1ECB6B),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(color: Color(0xFF070B16), strokeWidth: 3),
                          )
                        : const Text(
                            'Login',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF070B16)),
                          ),
                  ),
                ),
                const SizedBox(height: 32),

                // Bottom Create Account Link
                Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "Don't have an account? ", 
                        style: TextStyle(color: Color(0xFF676E84), fontSize: 14),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pushReplacementNamed(context, '/signup'),
                        child: const Text(
                          'Create one', 
                          style: TextStyle(color: Color(0xFF1ECB6B), fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputLabel(String label) {
    return Text(
      label, 
      style: const TextStyle(
        fontSize: 11, 
        letterSpacing: 1.1, 
        fontWeight: FontWeight.w700, 
        color: Color(0xFF78829D),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    Widget? suffixIcon,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0E1424),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withOpacity(0.04)),
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        validator: validator,
        style: const TextStyle(color: Colors.white, fontSize: 14),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          border: InputBorder.none,
          hintText: hintText,
          hintStyle: const TextStyle(color: Color(0xFF384056), fontSize: 14),
          suffixIcon: suffixIcon,
        ),
      ),
    );
  }
}