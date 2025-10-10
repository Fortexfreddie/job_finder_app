import 'package:flutter/material.dart';

class CustomTabBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTap;

  const CustomTabBar({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          _buildTabItem(0, 'Personal info'),
          _buildTabItem(1, 'Teams'),
        ],
      ),
    );
  }

  // Helper method to avoid repeating code for the tabs
  Widget _buildTabItem(int index, String text) {
    bool isSelected = selectedIndex == index;
    return Expanded(
      child: GestureDetector(
        // When tapped, it calls the function passed from the parent
        onTap: () => onTap(index),
        child: Container(
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.blue : Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}