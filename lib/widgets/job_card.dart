import 'package:flutter/material.dart';


class JobCard extends StatefulWidget {
  const JobCard({super.key});

  @override
  State<JobCard> createState() => _JobCardState();
}

class _JobCardState extends State<JobCard> {


  final List<Map<String, dynamic>> jobs = [
    {
      "title": "UI/UX Designer",
      "company": "Tech Solutions",
      "location": "New York, NY",
      "logoUrl":
          "https://images.unsplash.com/photo-1599305445671-ac291c95aaa9?q=80&w=869&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D", // Placeholder image URL
      "isBookmarked": false,
      "tags": ["Full-time", "Remote", "Senior"],
    },
    {
      "title": "Software Engineer",
      "company": "Innovatech",
      "location": "San Francisco, CA",
      "logoUrl":
          "https://images.unsplash.com/photo-1599305445671-ac291c95aaa9?q=80&w=869&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D", // Placeholder image URL
      "isBookmarked": true,
      "tags": ["Full-time", "On-site", "Mid-level"],
    },
    {
      "title": "Product Manager",
      "company": "Creative Minds",
      "location": "Austin, TX",
      "logoUrl":
          "https://images.unsplash.com/photo-1599305445671-ac291c95aaa9?q=80&w=869&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D", // Placeholder image URL
      "isBookmarked": false,
      "tags": ["Contract", "Remote", "Senior"],
    },
    {
      "title": "Data Analyst",
      "company": "DataWorks",
      "location": "Seattle, WA",
      "logoUrl":
          "https://images.unsplash.com/photo-1599305445671-ac291c95aaa9?q=80&w=869&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D", // Placeholder image URL
      "isBookmarked": true,
      "tags": ["Part-time", "On-site", "Junior"],
    },
    {
      "title": "Marketing Specialist",
      "company": "MarketGuru",
      "location": "Chicago, IL",
      "logoUrl":
          "https://images.unsplash.com/photo-1599305445671-ac291c95aaa9?q=80&w=869&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D", // Placeholder image URL
      "isBookmarked": false,
      "tags": ["Full-time", "Remote", "Mid-level"],
    },
  ];

  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: jobs.length,
        separatorBuilder: (context, _) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final isSelected = index == selectedIndex;
          final job = jobs[index];

          return GestureDetector(
            onTap: () {
              setState(() {
                selectedIndex = index;
              });
            },
            child: Container(
              padding: EdgeInsets.all(16),
              width: 250,
              decoration: BoxDecoration(
                color: isSelected ? Colors.blue[50] : Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected ? Colors.blue : Colors.grey.shade300,
                  width: 1.2,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CircleAvatar(
                        radius: 22,
                        backgroundImage: NetworkImage(job["logoUrl"]),
                      ),
                      Icon(
                        job["isBookmarked"]
                            ? Icons.bookmark_added_sharp
                            : Icons.bookmark_add_outlined,
                        color: job["isBookmarked"] ? Colors.red : Colors.grey,
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        }
      ),
    );
  }
}