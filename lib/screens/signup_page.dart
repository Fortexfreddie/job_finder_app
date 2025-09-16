import 'package:flutter/material.dart';
import '../widgets/custom_textfield.dart';
import '../widgets/custom_button.dart';

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
                  keyboardType: TextInputType.phone,
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
              ],
            ), 
            ),
        ),
      ),
    );
  }
}