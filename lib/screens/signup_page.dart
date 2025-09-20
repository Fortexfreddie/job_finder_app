import 'package:flutter/material.dart';
import '../widgets/custom_textfield.dart';
import '../widgets/custom_button.dart';
import './signin_page.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _phoneError;
  String? _passwordError;

  @override

  void initState() {
    super.initState();
    // Add listeners for real-time validation
    _phoneController.addListener(_validatePhone);
    _passwordController.addListener(_validatePassword);
  }

  void _validatePhone() {
    setState(() {
      String phone = _phoneController.text.trim();
      _phoneError = phone.isEmpty
          ? "Mobile number cannot be empty"
          : phone.length < 11
          ? "Please enter a valid mobile number"
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
                  "Sign Up",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),

                // Phone Number TextField
                CustomTextField(
                  hintText: "Enter your phone",
                  prefixIcon: Icons.phone,
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  errorText: _phoneError,
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
                    _validatePhone();
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
                      "Have an account?",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(width: 5),
                    GestureDetector(
                      onTap: () {
                        // Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SignInPage()),
                        );
                      },
                      child: Text(
                        "Sign in",
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