import 'package:flutter/material.dart';
import '../widgets/custom_textfield.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

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
                SizedBox(height: 80),
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
                ),
                SizedBox(height: 10),

                // Password TextField
                CustomTextField(
                  hintText: "hintText",
                  prefixIcon: Icons.lock, 
                  isPassword: true,
                  controller: _passwordController,
                ),

                SizedBox(height: 10),
              ],
            ), 
            ),
        ),
      ),
    );
  }
}