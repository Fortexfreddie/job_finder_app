import 'package:flutter/material.dart';
import './nearby_job_card.dart';
import '../models/nearby_job_model.dart';

class NearbyJobs extends StatelessWidget {
  NearbyJobs({super.key});

  final List<Job> jobs = [
    Job(
      iconUrl:
          'https://imgs.search.brave.com/9anrNt7Uh-0Gss7Ht9IgvLqTmwju-1QSjBwoOkqQVZ0/rs:fit:500:0:1:0/g:ce/aHR0cHM6Ly9zdHls/ZXMucmVkZGl0bWVk/aWEuY29tL3Q1XzNt/YW93L3N0eWxlcy9j/b21tdW5pdHlJY29u/XzVtbW01dnN0eGo3/NjEucG5n',
      title: 'Senior UI Designer',
      company: 'Figma Inc.',
      location: 'Los Angeles, CA',
      salary: '\$4000/m',
    ),
    Job(
      iconUrl:
          'https://imgs.search.brave.com/-V_Y31V0tFZXQHOUkoZm2kRGur_DZywCppg7dyhQUpg/rs:fit:500:0:1:0/g:ce/aHR0cHM6Ly9jZG4t/aWNvbnMtcG5nLmZy/ZWVwaWsuY29tLzI1/Ni8zNTYvMzU2MDQ5/LnBuZz9zZW10PWFp/c193aGl0ZV9sYWJl/bA',
      title: 'Product Manager',
      company: 'Google LLC',
      location: 'Mountain View, CA',
      salary: '\$5500/m',
    ),
    Job(
      iconUrl:
          'https://imgs.search.brave.com/s4YPO7Fi1hJltTCUP3GRDc23HRqoaWFUdOC850zSB80/rs:fit:500:0:1:0/g:ce/aHR0cHM6Ly9wcmVz/dG1pdC5pby9ibG9n/L3dwLWNvbnRlbnQv/dXBsb2Fkcy8yMDI0/LzAyL3BheXN0YWNr/LW9wZW5ncmFwaC0x/LTEwMjR4NTM4LnBu/Zw',
      title: 'Flutter Developer',
      company: 'Paystack',
      location: 'Lagos, Nigeria',
      salary: '\$3500/m',
    ),
    Job(
      iconUrl:
          'https://imgs.search.brave.com/9FLf4E7kp19GksFwqMfaMyLlcsRR-tP3Yl-p27kTyj4/rs:fit:500:0:1:0/g:ce/aHR0cHM6Ly9jZG4u/YnJhbmRmZXRjaC5p/by9pZGNobWJvSEVa/L3cvNDAwL2gvNDAw/L3RoZW1lL2Rhcmsv/aWNvbi5qcGVnP2M9/MWJ4aWQ2NE11cDdh/Y3pld1NBWU1YJnQ9/MTcyNzcwNjY1ODk3/MQ',
      title: 'Backend Engineer',
      company: 'Microsoft',
      location: 'Remote',
      salary: '\$5000/m',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: jobs.length,
      itemBuilder: (context, index) {
        final job = jobs[index];

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
          child: NearbyJobCard(job: job),
        );
      },
    );
  }
}