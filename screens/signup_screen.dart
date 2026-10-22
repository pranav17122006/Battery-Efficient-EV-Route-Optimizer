// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class SignUpScreen extends StatefulWidget {
//   const SignUpScreen({super.key});

//   @override
//   State<SignUpScreen> createState() => _SignUpScreenState();
// }

// class _SignUpScreenState extends State<SignUpScreen> {
//   final _formKey = GlobalKey<FormState>();

//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   final TextEditingController _confirmPasswordController = TextEditingController();

//   bool _agreedToTerms = false;
//   bool _obscurePassword = true;
//   bool _obscureConfirmPassword = true;
//   bool _isLoading = false; // Added loading state

//   @override
//   void dispose() {
//     _nameController.dispose();
//     _emailController.dispose();
//     _passwordController.dispose();
//     _confirmPasswordController.dispose();
//     super.dispose();
//   }

//   Future<void> _handleSignUp() async {
//     if (!_agreedToTerms) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           backgroundColor: Color(0xFF161E34),
//           content: Text(
//             'Please accept the Terms of Service and Privacy Policy to continue.',
//             style: TextStyle(color: Colors.white),
//           ),
//         ),
//       );
//       return;
//     }

//     if (_formKey.currentState!.validate()) {
//       setState(() => _isLoading = true);
//       try {
//         // 1. Create the user in Firebase Auth
//         await FirebaseAuth.instance.createUserWithEmailAndPassword(
//           email: _emailController.text.trim(),
//           password: _passwordController.text.trim(),
//         );

//         // 2. Navigate to Onboarding if successful
//         if (mounted) Navigator.pushNamed(context, '/ev-onboarding');
//       } on FirebaseAuthException catch (e) {
//         String message = 'An error occurred';
//         if (e.code == 'weak-password') {
//           message = 'The password provided is too weak.';
//         } else if (e.code == 'email-already-in-use') {
//           message = 'An account already exists for that email.';
//         }
        
//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text(message)),
//           );
//         }
//       } finally {
//         if (mounted) setState(() => _isLoading = false);
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final bool isFormReady = _agreedToTerms && !_isLoading;

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
//                     border: Border.all(color: Colors.white.withOpacity(0.06)),
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
//                   'Create your account',
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
//                   'Join thousands of EV drivers saving energy.',
//                   style: TextStyle(fontSize: 14, color: Color(0xFF676E84)),
//                 ),
//                 const SizedBox(height: 32),

//                 // Full Name
//                 _buildInputLabel('FULL NAME'),
//                 const SizedBox(height: 8),
//                 _buildTextField(
//                   controller: _nameController,
//                   hintText: 'Alex Kumar',
//                   keyboardType: TextInputType.name,
//                   validator: (value) => value == null || value.trim().isEmpty ? 'Please enter your full name' : null,
//                 ),
//                 const SizedBox(height: 20),

//                 // Email
//                 _buildInputLabel('EMAIL'),
//                 const SizedBox(height: 8),
//                 _buildTextField(
//                   controller: _emailController,
//                   hintText: 'you@example.com',
//                   keyboardType: TextInputType.emailAddress,
//                   validator: (value) {
//                     if (value == null || value.trim().isEmpty) return 'Please enter your email';
//                     if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) return 'Enter a valid email address';
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 20),

//                 // Password
//                 _buildInputLabel('PASSWORD'),
//                 const SizedBox(height: 8),
//                 _buildTextField(
//                   controller: _passwordController,
//                   hintText: 'Create a strong password',
//                   obscureText: _obscurePassword,
//                   suffixIcon: IconButton(
//                     icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility, color: const Color(0xFF4C5366), size: 20),
//                     onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
//                   ),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) return 'Please enter a password';
//                     if (value.length < 6) return 'Password must be at least 6 characters';
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 20),

//                 // Confirm Password
//                 _buildInputLabel('CONFIRM PASSWORD'),
//                 const SizedBox(height: 8),
//                 _buildTextField(
//                   controller: _confirmPasswordController,
//                   hintText: 'Repeat your password',
//                   obscureText: _obscureConfirmPassword,
//                   suffixIcon: IconButton(
//                     icon: Icon(_obscureConfirmPassword ? Icons.visibility_off : Icons.visibility, color: const Color(0xFF4C5366), size: 20),
//                     onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
//                   ),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) return 'Please repeat your password';
//                     if (value != _passwordController.text) return 'Passwords do not match';
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 24),

//                 // Terms of Service Checkbox
//                 Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     SizedBox(
//                       height: 24,
//                       width: 24,
//                       child: Checkbox(
//                         value: _agreedToTerms,
//                         activeColor: const Color(0xFF1ECB6B),
//                         checkColor: const Color(0xFF070B16),
//                         side: BorderSide(color: Colors.white.withOpacity(0.2), width: 1.5),
//                         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
//                         onChanged: (value) => setState(() => _agreedToTerms = value ?? false),
//                       ),
//                     ),
//                     const SizedBox(width: 12),
//                     Expanded(
//                       child: RichText(
//                         text: TextSpan(
//                           style: const TextStyle(fontSize: 13, color: Color(0xFF676E84), height: 1.4),
//                           children: [
//                             const TextSpan(text: 'I agree to the '),
//                             TextSpan(
//                               text: 'Terms of Service',
//                               style: const TextStyle(color: Color(0xFF1ECB6B), fontWeight: FontWeight.w600),
//                               recognizer: TapGestureRecognizer()..onTap = () {},
//                             ),
//                             const TextSpan(text: ' and\n'),
//                             TextSpan(
//                               text: 'Privacy Policy',
//                               style: const TextStyle(color: Color(0xFF1ECB6B), fontWeight: FontWeight.w600),
//                               recognizer: TapGestureRecognizer()..onTap = () {},
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 28),

//                 // Create Account Button
//                 SizedBox(
//                   width: double.infinity,
//                   height: 54,
//                   child: ElevatedButton(
//                     onPressed: _isLoading ? null : _handleSignUp,
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: isFormReady ? const Color(0xFF1ECB6B) : const Color(0xFF125232),
//                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//                       disabledBackgroundColor: const Color(0xFF125232),
//                     ),
//                     child: _isLoading
//                         ? const SizedBox(
//                             width: 24,
//                             height: 24,
//                             child: CircularProgressIndicator(color: Color(0xFF051B0F), strokeWidth: 3),
//                           )
//                         : Text(
//                             'Create Account',
//                             style: TextStyle(
//                               fontSize: 15,
//                               fontWeight: FontWeight.bold,
//                               color: isFormReady ? const Color(0xFF070B16) : const Color(0xFF051B0F),
//                             ),
//                           ),
//                   ),
//                 ),
//                 const SizedBox(height: 24),

//                 // Bottom Login Link
//                 Center(
//                   child: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       const Text('Already have an account? ', style: TextStyle(color: Color(0xFF676E84), fontSize: 14)),
//                       GestureDetector(
//                         onTap: () => Navigator.pushReplacementNamed(context, '/login'),
//                         child: const Text('Login', style: TextStyle(color: Color(0xFF1ECB6B), fontWeight: FontWeight.bold, fontSize: 14)),
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

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _agreedToTerms = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignUp() async {
    // 1. Check if terms are accepted
    if (!_agreedToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Color(0xFF161E34),
          content: Text(
            'Please accept the Terms of Service and Privacy Policy to continue.',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
      return;
    }

    // 2. Validate the form fields
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        // 3. Create the user in Firebase Auth
        UserCredential userCred = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        // 4. Save the Full Name to the Firebase user profile
        await userCred.user?.updateDisplayName(_nameController.text.trim());

        // 5. Navigate to EV Onboarding if successful
        if (mounted) {
          Navigator.pushNamed(context, '/ev-onboarding');
        }
      } on FirebaseAuthException catch (e) {
        String message = 'An error occurred';
        if (e.code == 'weak-password') {
          message = 'The password provided is too weak.';
        } else if (e.code == 'email-already-in-use') {
          message = 'An account already exists for that email.';
        }
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message)),
          );
        }
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isFormReady = _agreedToTerms && !_isLoading;

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
                    border: Border.all(color: Colors.white.withOpacity(0.06)),
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
                  'Create your account',
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
                  'Join thousands of EV drivers saving energy.',
                  style: TextStyle(fontSize: 14, color: Color(0xFF676E84)),
                ),
                const SizedBox(height: 32),

                // Full Name
                _buildInputLabel('FULL NAME'),
                const SizedBox(height: 8),
                _buildTextField(
                  controller: _nameController,
                  hintText: 'Alex Kumar',
                  keyboardType: TextInputType.name,
                  validator: (value) => value == null || value.trim().isEmpty ? 'Please enter your full name' : null,
                ),
                const SizedBox(height: 20),

                // Email
                _buildInputLabel('EMAIL'),
                const SizedBox(height: 8),
                _buildTextField(
                  controller: _emailController,
                  hintText: 'you@example.com',
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) return 'Please enter your email';
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) return 'Enter a valid email address';
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Password
                _buildInputLabel('PASSWORD'),
                const SizedBox(height: 8),
                _buildTextField(
                  controller: _passwordController,
                  hintText: 'Create a strong password',
                  obscureText: _obscurePassword,
                  suffixIcon: IconButton(
                    icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility, color: const Color(0xFF4C5366), size: 20),
                    onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Please enter a password';
                    if (value.length < 6) return 'Password must be at least 6 characters';
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Confirm Password
                _buildInputLabel('CONFIRM PASSWORD'),
                const SizedBox(height: 8),
                _buildTextField(
                  controller: _confirmPasswordController,
                  hintText: 'Repeat your password',
                  obscureText: _obscureConfirmPassword,
                  suffixIcon: IconButton(
                    icon: Icon(_obscureConfirmPassword ? Icons.visibility_off : Icons.visibility, color: const Color(0xFF4C5366), size: 20),
                    onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Please repeat your password';
                    if (value != _passwordController.text) return 'Passwords do not match';
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                // Terms of Service Checkbox
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 24,
                      width: 24,
                      child: Checkbox(
                        value: _agreedToTerms,
                        activeColor: const Color(0xFF1ECB6B),
                        checkColor: const Color(0xFF070B16),
                        side: BorderSide(color: Colors.white.withOpacity(0.2), width: 1.5),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                        onChanged: (value) => setState(() => _agreedToTerms = value ?? false),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          style: const TextStyle(fontSize: 13, color: Color(0xFF676E84), height: 1.4),
                          children: [
                            const TextSpan(text: 'I agree to the '),
                            TextSpan(
                              text: 'Terms of Service',
                              style: const TextStyle(color: Color(0xFF1ECB6B), fontWeight: FontWeight.w600),
                              recognizer: TapGestureRecognizer()..onTap = () {},
                            ),
                            const TextSpan(text: ' and\n'),
                            TextSpan(
                              text: 'Privacy Policy',
                              style: const TextStyle(color: Color(0xFF1ECB6B), fontWeight: FontWeight.w600),
                              recognizer: TapGestureRecognizer()..onTap = () {},
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 28),

                // Create Account Button
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleSignUp,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isFormReady ? const Color(0xFF1ECB6B) : const Color(0xFF125232),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      disabledBackgroundColor: const Color(0xFF125232),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(color: Color(0xFF051B0F), strokeWidth: 3),
                          )
                        : Text(
                            'Create Account',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: isFormReady ? const Color(0xFF070B16) : const Color(0xFF051B0F),
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 24),

                // Bottom Login Link
                Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Already have an account? ', style: TextStyle(color: Color(0xFF676E84), fontSize: 14)),
                      GestureDetector(
                        onTap: () => Navigator.pushReplacementNamed(context, '/login'),
                        child: const Text('Login', style: TextStyle(color: Color(0xFF1ECB6B), fontWeight: FontWeight.bold, fontSize: 14)),
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

  // Custom Input Label Widget
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

  // Custom TextField Widget
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