import 'package:flutter/material.dart';
import 'package:job_finder_app/widgets/custom_search_bar.dart';
import 'package:job_finder_app/widgets/category_list.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert'; // For JWT decoding
import '../signin_page.dart'; // Import SignInPage for logout redirect
import 'package:logger/logger.dart';
import '../../widgets/job_card.dart';
import '../../widgets/nearby_jobs.dart';
import './profile_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

// Testing the extension, just say yes if it works
class _HomePageState extends State<HomePage> {
  final storage = FlutterSecureStorage();
  // bool _isLoading = false;
  final logger = Logger();
  String? userName;
  Map<String, dynamic>? payloads;

  @override
  void initState() {
    super.initState();
    _loadUserData(); // Load user data when the page starts
  }

  Future<void> _loadUserData() async {
    final token = await storage.read(key: 'jwt_token');

    if (token == null) {
      logger.e("No token found. Redirecting to sign-in.");
      _logout();
      return;
    }

    try {
      final parts = token.split('.');
      if (parts.length != 3) {
        logger.e("Invalid token format.");
        _logout();
        return;
      }

      final payloadString = utf8.decode(
        base64Url.decode(base64Url.normalize(parts[1])),
      );
      final payload = jsonDecode(payloadString) as Map<String, dynamic>;

      // Check for token expiration
      final exp = payload['exp'] as int?;
      final nowInSeconds = DateTime.now().millisecondsSinceEpoch ~/ 1000;

      if (exp == null || exp <= nowInSeconds) {
        logger.e("Token has expired.");
        _logout();
        return;
      }

      if (mounted) {
        // Check if the widget is still visible
        setState(() {
          userName = payload['name'] as String? ?? "User";
          this.payloads = payload;
        });
        logger.i("Successfully loaded user: $userName");
      }
    } catch (e) {
      logger.e("Failed to decode token: $e");
      _logout();
    }
  }

  Future<void> _logout() async {
    await storage.delete(key: 'jwt_token');
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const SignInPage()),
    );
  }


  // Show confirmation dialog before logging out
  Future<void> _showLogoutDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // User must tap a button
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Logout'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[Text('Are you sure you want to log out?')],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.red, // Make the text red
              ),
              child: const Text('Logout'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                _logout(); // Call your existing logout function
              },
            ),
          ],
        );
      },
    );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text("Hello Kemi 👋"),
      //   actions: const [
      //     CircleAvatar(backgroundImage: AssetImage("assets/image_1.jpg")),
      //   ],
      // ),
      drawer: MyDrawer(
        onLogoutTapped: _showLogoutDialog, // Pass the dialog function here
        payloads: payloads,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(
              left: 16.0,
              right: 16.0,
              top: 16.0,
              bottom: 0.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Builder(
                      builder: (context) {
                        return IconButton(
                          icon: const Icon(Icons.menu, color: Colors.grey),
                          onPressed: () {
                            // This command opens the drawer
                            Scaffold.of(context).openDrawer();
                          },
                        );
                      },
                    ),
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

                // Nearby jobs
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Nearby jobs",
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

                // Nearby jobs
                NearbyJobs(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MyDrawer extends StatelessWidget {
  final VoidCallback onLogoutTapped;
  final Map<String, dynamic>? payloads;

  const MyDrawer({super.key, required this.onLogoutTapped, this.payloads});

  @override
  Widget build(BuildContext context) {
    final String userName = payloads?['name'] as String? ?? 'Guest';
    final String userEmail = payloads?['email'] as String? ?? 'guest@gmail.com';


    return Drawer(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: Colors.blue),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage("assets/image_1.jpg"),
                ),
                const SizedBox(height: 12),
                Text(
                  userName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  userEmail,
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              // Just close the drawer
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Profile'),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              Navigator.pop(context); // Close the drawer
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Logout', style: TextStyle(color: Colors.red)),
            onTap: () {
              // 1. Close the drawer first
              Navigator.pop(context);
              // 2. Then call the logout dialog function
              onLogoutTapped();
            },
          ),
        ],
      ),
    );
  }
}