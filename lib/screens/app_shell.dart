import 'package:flutter/material.dart';
import './pages/home_page.dart';
import './pages/profile_screen.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert'; // For JWT decoding
import './signin_page.dart'; // Import SignInPage for logout redirect
import 'package:logger/logger.dart';

class ChartPage extends StatelessWidget {
  const ChartPage({super.key});
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(child: Text('Chart Page', style: TextStyle(fontSize: 24))),
    );
  }
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(child: Text('Settings Page', style: TextStyle(fontSize: 24))),
    );
  }
}



class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {

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

  // This variable holds the currently selected ICON index
  int _selectedIndex = 0;

  // This is the list of pages that correspond to the icons
  static const List<Widget> _pages = <Widget>[
    HomePage(),
    ChartPage(),
    ProfileScreen(),
    SettingsPage(),
  ];

  // This function is called when an icon is tapped
  void _onItemTapped(int index) {
    if (index == 2) {
    
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Add button tapped!')),
      );
    } else {
      // For all other icons, update the state
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  // Helper to map the icon index to the correct page index
  int _getPageIndex(int iconIndex) {
    if (iconIndex > 2) {
      return iconIndex - 1;
    }
    return iconIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // The body now shows the correct page based on the selected index
      body: _pages[_getPageIndex(_selectedIndex)],
      
      // The bottom navigation bar UI is built directly here
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                // FIX: Use .withOpacity() for transparency
                color: Colors.grey.withValues(alpha: 0.2),
                spreadRadius: 2,
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: const Icon(Icons.home),
                // Color changes based on the state variable
                color: _selectedIndex == 0 ? Colors.blue : Colors.grey,
                // onPressed calls the function that updates the state
                onPressed: () => _onItemTapped(0),
              ),
              IconButton(
                icon: const Icon(Icons.pie_chart_outline),
                color: _selectedIndex == 1 ? Colors.blue : Colors.grey,
                onPressed: () => _onItemTapped(1),
              ),
              Container(
                height: 45,
                width: 45,
                decoration: BoxDecoration(
                  color: _selectedIndex == 2 ? Colors.blue : Colors.deepPurple,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.add, color: Colors.white),
                  onPressed: () => _onItemTapped(2),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.person_outline),
                color: _selectedIndex == 3 ? Colors.blue : Colors.grey,
                onPressed: () => _onItemTapped(3),
              ),
              IconButton(
                icon: const Icon(Icons.settings_outlined),
                color: _selectedIndex == 4 ? Colors.blue : Colors.grey,
                onPressed: () => _onItemTapped(4),
              ),
            ],
          ),
        ),
      ),
    );
  }
}