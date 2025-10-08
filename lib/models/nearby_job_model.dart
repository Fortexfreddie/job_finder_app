class Job {
  final String iconUrl;
  final String title;
  final String company;
  final String location;
  final String? salary;

  Job({
    required this.iconUrl,
    required this.title,
    required this.company,
    required this.location,
    this.salary,
  });
}