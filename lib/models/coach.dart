// models/coach.dart
class Coach {
  final int id;
  final String firstName;
  final String lastName;
  final String role;
  final String? phone;
  final String? hireDate;
  final int? salary;
  final String? image;
  final int? attendanceRate;
  final int? yearsService;

  Coach({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.role,
    this.phone,
    this.hireDate,
    this.salary,
    this.image,
    this.attendanceRate,
    this.yearsService,
  });

  factory Coach.fromJson(Map<String, dynamic> json) {
    return Coach(
      id: int.parse(json['id'].toString()),
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      role: json['role'] ?? '',
      phone: json['phone'],
      hireDate: json['hire_date'],
      salary: json['salary'] != null ? int.parse(json['salary'].toString()) : null,
      image: json['image'] != null ? json['image'].toString().trim() : null,
      attendanceRate: json['attendance_rate'] != null ? int.parse(json['attendance_rate'].toString()) : null,
      yearsService: json['years_service'] != null ? int.parse(json['years_service'].toString()) : null,
    );
  }

  String get fullName => '$firstName $lastName';
}