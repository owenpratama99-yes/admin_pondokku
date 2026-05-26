class Employee {
  final String id;
  final String name;
  final String email;
  final String role; // BARISTA, MANAGER, OWNER
  final String branchId;
  final String branchName;
  final int currentPoints;
  final int yearlyPoints;
  final int spCount;
  final String status; // ACTIVE, INACTIVE, SUSPENDED
  final String? photoUrl;
  final DateTime joinDate;
  final DateTime? lastAttendance;

  Employee({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.branchId,
    required this.branchName,
    required this.currentPoints,
    required this.yearlyPoints,
    required this.spCount,
    required this.status,
    this.photoUrl,
    required this.joinDate,
    this.lastAttendance,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      role: json['role'] as String,
      branchId: json['branchId'] as String,
      branchName: json['branchName'] as String,
      currentPoints: json['currentPoints'] as int,
      yearlyPoints: json['yearlyPoints'] as int,
      spCount: json['spCount'] as int,
      status: json['status'] as String,
      photoUrl: json['photoUrl'] as String?,
      joinDate: DateTime.parse(json['joinDate'] as String),
      lastAttendance: json['lastAttendance'] != null
          ? DateTime.parse(json['lastAttendance'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
      'branchId': branchId,
      'branchName': branchName,
      'currentPoints': currentPoints,
      'yearlyPoints': yearlyPoints,
      'spCount': spCount,
      'status': status,
      'photoUrl': photoUrl,
      'joinDate': joinDate.toIso8601String(),
      'lastAttendance': lastAttendance?.toIso8601String(),
    };
  }

  bool get isAtRisk => currentPoints < -100;
  bool get isActive => status == 'ACTIVE';
  String get initials {
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.substring(0, 2).toUpperCase();
  }
}
