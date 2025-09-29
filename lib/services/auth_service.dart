// Import dart:convert for JSON encoding/decoding so we can send and parse JSON payloads
import 'dart:convert';

// Import http package to handle network requests between Flutter and backend
import 'package:http/http.dart' as http;

// Import logger package for structured logging (instead of using print statements)
import 'package:logger/logger.dart';

// Import flutter_dotenv so we can safely read sensitive values like API URLs from .env
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  // Logger instance for printing info/errors in a readable structured way
  final logger = Logger();

  // Instead of hardcoding the base URL, we now load it dynamically from the .env file;
  // this helps avoid leaking secrets in code and makes it easier to switch environments.
  final String baseUrl = dotenv.env['BASE_URL']!;

  // ====================== SIGNUP ======================
  // Function to register a new user on the backend service
  // Returns: a Map with both success (true/false) and a message from the backend
  Future<Map<String, dynamic>> signup(
      String name, String email, String phone, String password) async {
    // Construct the signup URL by appending /api/auth/signup to the base URL
    final url = Uri.parse('$baseUrl/api/auth/signup');

    try {
      // Make a POST request to the backend with user input serialized as JSON
      final response = await http.post(
        url,
        headers: {
          "Content-Type":
              "application/json" // This tells the backend that we are sending JSON data
        },
        body: jsonEncode({
          "name": name, // Name from the signup form
          "email": email, // Email address
          "phonenumber": phone, // Phone number as required by backend
          "password": password, // Password string
        }),
      );

      // Evaluate backend response and handle accordingly
      if (response.statusCode == 201) {
        // 201 Created → The backend confirms that the new user record has been successfully added
        logger.i("Signup success: ${response.body}");
        return {
          "success": true,
          "message": "Signup successful"
        }; // Return a Map for UI use
      } else {
        // Any other status code indicates signup failure (invalid data, existing user, etc.)
        // NOTE: response.body often contains JSON like { "message": "User already exists" }
        final errorData = jsonDecode(response.body);
        final errorMessage = errorData['message'] ?? "Signup failed";
        logger.e("Signup failed: $errorMessage");
        return {
          "success": false,
          "message": errorMessage
        }; // Pass back backend error message
      }
    } catch (e) {
      // Handle network errors, timeouts, or unexpected exceptions
      logger.e("Signup exception: $e");
      return {
        "success": false,
        "message": "Network error, please try again"
      };
    }
  }

  // ====================== LOGIN ======================
  // Function to authenticate an existing user against the backend service
  // Returns: a Map with success and message (e.g., Invalid password, Login successful, etc.)
  Future<Map<String, dynamic>> login(String email, String password) async {
    // Build the complete login URL by appending /api/auth/login to the base URL
    final url = Uri.parse('$baseUrl/api/auth/login');

    // For JWT storage
    final storage = FlutterSecureStorage();

    try {
      // Make a POST request to backend with login credentials as JSON
      final response = await http.post(
        url,
        headers: {
          "Content-Type":
              "application/json" // Ensure backend interprets the body as JSON
        },
        body: jsonEncode({
          "email": email, // Email entered by the user
          "password": password, // Password string
        }),
      );

      // Evaluate the backend response
      if (response.statusCode == 200) {
        // 200 OK → Login successful, so we can decode the response body for the token
        final data = jsonDecode(response.body);
        logger.i("Login success, token: ${data['token']}");

        final token = data['token']; // Extract the JWT token from the response
        await storage.write(key: 'jwt_token', value: token); // Save the token securely
        logger.i("Token saved: $token"); // Log the saved token for debugging

        return {
          "success": true,
          "message": "Login successful"
        };
      } else {
        // If not 200, then login failed (wrong credentials, user not found, etc.)
        // NOTE: Backend sends { "message": "Invalid email" } or { "message": "Invalid email or password" }
        final errorData = jsonDecode(response.body);
        final errorMessage = errorData['message'] ?? "Login failed";
        logger.e("Login failed: $errorMessage");
        return {
          "success": false,
          "message": errorMessage
        };
      }
    } catch (e) {
      // Handle offline, timeout, or parsing errors
      logger.e("Login exception: $e");
      return {
        "success": false,
        "message": "Network error, please try again"
      };
    }
  }
}