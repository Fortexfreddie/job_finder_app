import 'package:flutter/material.dart';
import '../widgets/custom_textfield.dart';
import '../widgets/custom_button.dart';
import './signup_page.dart';
import '../services/auth_service.dart';

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

  @override

  void initState() {
    super.initState();
    // Add listeners for real-time validation
    _emailController.addListener(_validateEmail);
    _passwordController.addListener(_validatePassword);
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
                SizedBox(height: 20),
                Center(
                  child: Image(
                    image: AssetImage("assets/image_1.1.png"),
                    height: 300,
                    width: 300,
                  ),
                ),

                // SizedBox(height: 5),
                Text(
                  "Sign In",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),

                // Email TextField
                CustomTextField(
                  hintText: "Enter your email",
                  prefixIcon: Icons.email,
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  errorText: _emailError,
                ),
                SizedBox(height: 10),

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

                SizedBox(height: 10),
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
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(response["message"] ?? "Login successful!")),
                        );

                        // Navigate to next page
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const SignInPage()),
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


                SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: Divider(thickness: 1, color: Colors.grey[300]),
                    ),
                    SizedBox(width: 10),
                    Text("Or"),
                    SizedBox(width: 10),
                    Expanded(
                      child: Divider(thickness: 1, color: Colors.grey[300]),
                    ),
                  ],
                ),
                SizedBox(height: 20),
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
                SizedBox(height: 10),

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
                    label: Text(
                      "Register with Google",
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                  ),
                ),

                SizedBox(height: 10),

                // Don't have an account? Sign Up
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account?",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(width: 5),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SignUpPage()),
                        );
                        // Navigator.pop(context);
                      },
                      child: Text(
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