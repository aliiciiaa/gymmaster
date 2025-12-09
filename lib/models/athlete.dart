class Athlete {
  final int id;
  final String firstName;
  final String lastName;
  final String? image;
  final String? subscriptionName;
  final String? endDate;
  final String computedStatus;

  Athlete({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.image,
    this.subscriptionName,
    this.endDate,
    required this.computedStatus,
  });

  factory Athlete.fromJson(Map<String, dynamic> j) {
    return Athlete(
      id: int.parse(j['id'].toString()),
      firstName: j['first_name'] ?? '',
      lastName: j['last_name'] ?? '',
      image: j['image'] ?? '',
      subscriptionName: j['subscription_name'] ?? '',
      endDate: j['end_date'] ?? '',
      computedStatus:
          j['computed_status'] ?? (j['sub_status'] ?? 'No Sub'),
    );
  }
}
