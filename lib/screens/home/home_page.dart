import 'package:flutter/material.dart';
import 'package:job_finder_app/widgets/custom_search_bar.dart';
import 'package:job_finder_app/widgets/category_list.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert'; // For JWT decoding
import '../signin_page.dart'; // Import SignInPage for logout redirect
import 'package:logger/logger.dart';
import '../../widgets/job_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final storage = FlutterSecureStorage();
  // bool _isLoading = false;
  final logger = Logger();
  String? userName;
  // dynamic payloads;

  @override
  void initState() {
    super.initState();
    _checkTokenExpiration(); // Check token on page load
  }

  Future<void> _checkTokenExpiration() async {
    final token = await storage.read(key: 'jwt_token');
    if (token != null) {
      if (!await _isTokenValid(token)) {
        // Token expired or invalid, clear and logout
        await storage.delete(key: 'jwt_token');
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SignInPage()),
        );
        logger.e("Token expired, logged out");
      }
    } else {
      // No token, redirect to sign-in
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SignInPage()),
      );
      logger.e("No token found, redirected to sign-in");
    }
  }

  Future<bool> _isTokenValid(String token) async {
    try {
      // Decode JWT to check expiration (assuming standard JWT format: header.payload.signature)
      final parts = token.split('.');
      if (parts.length != 3) return false; // Invalid JWT format
      final payload = jsonDecode(
        utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))),
      );
      setState(() {
        userName = payload['name'] ?? "User"; // fallback if null
        // payloads = payload;
      });
      logger.i("Logged in as $userName");
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

  // Dummy jobs for now, later this could come from an API
  final List<Map<String, String>> jobs = [
    {
      "title": "Senior UI Designer",
      "location": "San Francisco, USA",
      "salary": "\$2500/mo",
    },
    {
      "title": "Product Manager",
      "location": "New York, USA",
      "salary": "\$3000/mo",
    },
  ];



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text("Hello Kemi 👋"),
      //   actions: const [
      //     CircleAvatar(backgroundImage: AssetImage("assets/image_1.jpg")),
      //   ],
      // ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(Icons.menu),
                    CircleAvatar(
                      backgroundImage: AssetImage("assets/image_1.jpg"),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Text(
                  "Hello ${userName ?? "kemi"} 👋",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                Text(
                  "Let's find your dream job",
                  style: TextStyle(color: Colors.grey),
                ),
                SizedBox(height: 20),

                // Search Bar
                CustomSearchBar(),
                SizedBox(height: 20),

                // Category list
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Most Popular Jobs",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Show All",
                      style: TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.blue,
                        decorationThickness: 1,
                      ),
                    ),
                  ],
                ),

                // Category list
                SizedBox(height: 10),
                CategoryList(),
                SizedBox(height: 20),

                // job cards
                JobCard(),
                SizedBox(height: 20),

              ],
            ),
          ),
        )
      ),
    );
  }
}