import 'package:flutter/material.dart';
import '../widgets/custom_textfield.dart';
import '../widgets/custom_button.dart';
import './signup_page.dart';
import '../services/auth_service.dart';
import './app_shell.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert'; // For JWT decoding
import 'package:logger/logger.dart';


class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final authService = AuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _emailError;
  String? _passwordError;
  bool _isLoading = false; // track the login
  final storage = FlutterSecureStorage();
  final logger = Logger();

  @override
  void dispose() {
    // Always dispose controllers to free memory
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override

  void initState() {
    super.initState();
    // Add listeners for real-time validation
    _emailController.addListener(_validateEmail);
    _passwordController.addListener(_validatePassword);
    _checkTokenAndRedirect(); // Check token and decode on page load
  }

  Future<void> _checkTokenAndRedirect() async {
    final token = await storage.read(key: 'jwt_token'); // Read saved token
    if (token != null) {
      // Decode and validate token
      if (await _isTokenValid(token)) {
        // Navigate to HomePage if valid
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const AppShell()),
        );
      } else {
        // Invalid or expired token, clear it
        await storage.delete(key: 'jwt_token');
        if (!mounted) return;
        logger.e("Invalid or expired token cleared");
      }
    }
  }

  Future<bool> _isTokenValid(String token) async {
    try {
      // Decode JWT to check expiration (header.payload.signature)
      final parts = token.split('.');
      if (parts.length != 3) return false; // Invalid JWT format
      final payload = jsonDecode(
        utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))),
      );
      final exp =
          payload['exp'] as int?; // Expiration timestamp (seconds since epoch)
      if (exp == null) return false; // No expiration claim
      final now =
          DateTime.now().millisecondsSinceEpoch ~/
          1000; // Current time in seconds
      return exp > now; // Token is valid if exp is in the future
    } catch (e) {
      logger.e("Token validation error: $e");
      return false;
    }
  }

  void _validateEmail() {
    setState(() {
      String email = _emailController.text.trim();
      _emailError = email.isEmpty
          ? "Email cannot be empty"
          : !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)
          ? "Please enter a valid email"
          : null;
    });
  }

  void _validatePassword() {
    setState(() {
      String password = _passwordController.text.trim();
      _passwordError = password.isEmpty
          ? "Password cannot be empty"
          : password.length < 6
          ? "Password must be at least 6 characters"
          : null;
    });
  }

  @override


  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Center(
                  child: Image(
                    image: const AssetImage("assets/image_1.1.png"),
                    height: 300,
                    width: 300,
                  ),
                ),

                // SizedBox(height: 5),
                const Text(
                  "Sign In",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),

                // Email TextField
                CustomTextField(
                  hintText: "Enter your email",
                  prefixIcon: Icons.email,
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  errorText: _emailError,
                ),
                const SizedBox(height: 10),

                // Password TextField
                CustomTextField(
                  hintText: "Enter your password",
                  prefixIcon: Icons.lock,
                  suffixIcon: Icons.visibility, 
                  isPassword: true,
                  controller: _passwordController,
                  keyboardType: TextInputType.visiblePassword,
                  errorText: _passwordError,
                ),

                const SizedBox(height: 10),
                // continue button
                CustomButton(
                  text: "Continue",
                  backgroundColor: Colors.blue,
                  textColor: Colors.white,
                  isLoading: _isLoading,
                  onPressed: _isLoading ? null : () async {
                    // Run local validations before hitting backend
                    _validateEmail();
                    _validatePassword();

                    setState(() => _isLoading = true);

                    try {
                      // Wait for login to complete (returns { "success": bool, "message": String })
                      final response = await authService.login(
                        _emailController.text.trim(),
                        _passwordController.text.trim(),
                      );

                      // Check if widget is still mounted before using context
                      if (!mounted) return;

                      // Handle response
                      if (response["success"] == true) {
                        // Login success
                        // ScaffoldMessenger.of(context).showSnackBar(
                        //   SnackBar(content: Text(response["message"] ?? "Login successful!")),
                        // );

                        // Navigate to next page
                        Navigator.pushReplacement(
                          context,
                                MaterialPageRoute(
                                  builder: (context) => const AppShell(),
                                ),
                        );
                      } else {
                        // Login failed (backend error like "Invalid password")
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(response["message"] ?? "Login failed.")),
                        );
                      }
                    } catch (e) {
                      // Exception (network error, timeout, etc.)
                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("An error occurred: $e")),
                      );
                    } finally {
                      // Reset loading state
                      if (mounted) {
                        setState(() => _isLoading = false);
                      }
                    }
                  },
                ),


                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: Divider(thickness: 1, color: Colors.grey[300]),
                    ),
                    const SizedBox(width: 10),
                    const Text("Or"),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Divider(thickness: 1, color: Colors.grey[300]),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Register with Apple button
                CustomButton(
                  text: "Register with Apple",
                  backgroundColor: Colors.black,
                  textColor: Colors.white,
                  icon: Icons.apple,
                  onPressed: () {
                    _validateEmail();
                    _validatePassword();
                  },
                ),
                const SizedBox(height: 10),

                // Register with Google button with OutlinedButton.icon
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.grey.shade300),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    icon: Image.asset(
                      "assets/google.png",
                      height: 20,
                      width: 20,
                    ),
                    label: const Text(
                      "Register with Google",
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // Don't have an account? Sign Up
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Don't have an account?",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 5),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SignUpPage()),
                        );
                        // Navigator.pop(context);
                      },
                      child: const Text(
                        "Sign up",
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ), 
            ),
        ),
      ),
    );
  }
}