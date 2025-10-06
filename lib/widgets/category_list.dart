import 'package:flutter/material.dart';

class CategoryList extends StatefulWidget {
  const CategoryList({super.key});

  @override
  State<CategoryList> createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  final List<Map<String, dynamic>> categories = [
    {"name": "Music", "icon": Icons.music_note},
    {"name": "Design", "icon": Icons.design_services},
    {"name": "Fashion", "icon": Icons.checkroom},
    {"name": "Tech", "icon": Icons.computer},
    {"name": "Finance", "icon": Icons.attach_money},
    {"name": "Health", "icon": Icons.favorite},
  ];

  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (context, _) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final isSelected = index == selectedIndex;
          final category = categories[index];

          return GestureDetector(
            onTap: () {
              setState(() {
                selectedIndex = index;
              });
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? Colors.blue[50] : Colors.grey[100],
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: isSelected ? Colors.blue : Colors.grey.shade300,
                  width: 1.2,
                ),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 14,
                    backgroundColor: isSelected
                        ? Colors.blue[100]
                        : Colors.grey[300],
                    child: Icon(
                      category["icon"],
                      color: isSelected ? Colors.blue : Colors.grey[700],
                      size: 18,
                    ),
                  ),
                  SizedBox(width: 6),
                  Text(
                    category["name"],
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: isSelected ? Colors.blue : Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}