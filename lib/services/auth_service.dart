// Import dart:convert for JSON encoding/decoding
import 'dart:convert';

// Import http package for making network requests
import 'package:http/http.dart' as http;

// Import logger package for structured logging (instead of using print)
import 'package:logger/logger.dart';

class AuthService {
  // Logger instance for logging info and errors
  final logger = Logger();

  // Base URL of your backend (hosted on Render)
  final String baseUrl = "https://job-finder-app-backend.onrender.com/api/auth";

  // ====================== SIGNUP ======================
  // Function to register a new user
  Future<void> signup(String name, String email, String phone, String password) async {
    // Build the complete signup URL (https://.../api/auth/signup)
    final url = Uri.parse('$baseUrl/signup');

    // Make a POST request to the backend
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"}, // Tell backend we’re sending JSON
      body: jsonEncode({
        "name": name,            // From user input
        "email": email,
        "phonenumber": phone,
        "password": password,
      }),
    );

    // Check backend response
    if (response.statusCode == 201) {
      // 201 = Created → User successfully registered
      logger.i("Signup success: ${response.body}");
    } else {
      // Any other status code → Registration failed
      logger.e("Signup failed: ${response.body}");
    }
  }

  // ====================== LOGIN ======================
  // Function to log in existing user
  Future<void> login(String email, String password) async {
    // Build the complete login URL (https://.../api/auth/login)
    final url = Uri.parse('$baseUrl/login');

    // Make a POST request to the backend
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"}, // Sending JSON body
      body: jsonEncode({
        "email": email,          // From user input
        "password": password,
      }),
    );

    // Check backend response
    if (response.statusCode == 200) {
      // 200 = OK → Login successful
      final data = jsonDecode(response.body); // Parse JSON response
      logger.i("Login success, token: ${data['token']}");

      // You’ll later store this token (e.g., in SharedPreferences) for authentication
    } else {
      // Login failed (wrong password, no user, etc.)
      logger.e("Login failed: ${response.body}");
    }
  }
}