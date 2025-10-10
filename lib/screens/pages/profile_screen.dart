import 'package:flutter/material.dart';
import '../../widgets/profile_text_field.dart';
import '../../widgets/custom_tab_bar.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // To keep track of the selected tab
  int _selectedTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'My profile',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 25,
                          backgroundImage: AssetImage("assets/image_1.jpg"),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            child: const Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 12,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(width: 10),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Esther Kemi",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 2),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.add_circle,
                              color: Colors.blue,
                              size: 14,
                            ),
                            SizedBox(width: 4),
                            Text(
                              "Add status",
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),

                // Tabs for Personal Info and Teams
                const SizedBox(height: 20),

                // Custom Tab Bar
                CustomTabBar(
                  // 1. Pass the current state value DOWN to the child
                  selectedIndex: _selectedTabIndex,

                  // 2. Pass a function DOWN that the child can call UP
                  onTap: (index) {
                    setState(() {
                      _selectedTabIndex = index;
                    });
                  },
                ),

                const SizedBox(height: 32),

                _selectedTabIndex == 0
                    ? _buildPersonalInfoForm()
                    : _buildTeamsInfo(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// _buildPersonalInfoForm() and _buildTeamsInfo() methods.
Widget _buildPersonalInfoForm() {
  return const Column(
    children: [
      ProfileTextField(label: 'Name', value: 'Esther Kemi'),
      ProfileTextField(label: 'Email', value: 'estherkemi123@gmail.com'),
      ProfileTextField(label: 'Phone', value: '+234 90 545 89 40'),
      ProfileTextField(
        label: 'Password',
        value: '********',
        icon: Icons.visibility,
      ),
      ProfileTextField(
        label: 'Location',
        value: 'Los Angeles, California, USA',
      ),
    ],
  );
}

Widget _buildTeamsInfo() {
  return const Center(
    child: Text(
      'Teams Information',
      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    ),
  );
}
