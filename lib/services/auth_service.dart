// Import dart:convert for JSON encoding/decoding so we can send and parse JSON payloads
import 'dart:convert';

// Import http package to handle network requests between Flutter and backend
import 'package:http/http.dart' as http;

// Import logger package for structured logging (instead of using print statements)
import 'package:logger/logger.dart';

// Import flutter_dotenv so we can safely read sensitive values like API URLs from .env
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AuthService {
  // Logger instance for printing info/errors in a readable structured way
  final logger = Logger();

  // Instead of hardcoding the base URL, we now load it dynamically from the .env file;
  // this helps avoid leaking secrets in code and makes it easier to switch environments.
  final String baseUrl = dotenv.env['BASE_URL']!; 

  // ====================== SIGNUP ======================
  // Function to register a new user on the backend service
  // Returns: true if signup is successful, false otherwise
  Future<bool> signup(String name, String email, String phone, String password) async {
    // Construct the signup URL by appending /signup to the base URL
    final url = Uri.parse('$baseUrl/signup');

    // Make a POST request to the backend with user input serialized as JSON
    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json" // This tells the backend that we are sending JSON data
      },
      body: jsonEncode({
        "name": name,            // Name from the signup form
        "email": email,          // Email address
        "phonenumber": phone,    // Phone number as required by backend
        "password": password,    // Password string
      }),
    );

    // Evaluate backend response and handle accordingly
    if (response.statusCode == 201) {
      // 201 Created → The backend confirms that the new user record has been successfully added
      logger.i("Signup success: ${response.body}");
      return true; // Return true so UI can proceed (e.g., navigate to login page)
    } else {
      // Any other status code indicates signup failure (invalid data, existing user, etc.)
      logger.e("Signup failed: ${response.body}");
      return false; // Return false so UI can show error popup
    }
  }

  // ====================== LOGIN ======================
  // Function to authenticate an existing user against the backend service
  // Returns: true if login is successful, false otherwise
  Future<bool> login(String email, String password) async {
    // Build the complete login URL by appending /login to the base URL
    final url = Uri.parse('$baseUrl/login');

    // Make a POST request to backend with login credentials as JSON
    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json" // Ensure backend interprets the body as JSON
      },
      body: jsonEncode({
        "email": email,          // Email entered by the user
        "password": password,    // Password string
      }),
    );

    // Evaluate the backend response
    if (response.statusCode == 200) {
      // 200 OK → Login successful, so we can decode the response body for the token
      final data = jsonDecode(response.body); 
      logger.i("Login success, token: ${data['token']}");

      // In practice, you should securely store this token in SharedPreferences or secure storage
      // to persist login sessions and authorize future requests.
      return true; // Login succeeded
    } else {
      // If not 200, then login failed (wrong credentials, user not found, etc.)
      logger.e("Login failed: ${response.body}");
      return false; // Login failed
    }
  }
}