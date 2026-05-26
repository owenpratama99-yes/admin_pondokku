class Branch {
  final String id;
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final int radiusMeters;
  final String? managerId;
  final String? managerName;
  final int employeeCount;
  final String status; // ACTIVE, INACTIVE
  final String? phoneNumber;
  final Map<String, String>? operatingHours; // {"monday": "08:00-22:00", ...}

  Branch({
    required this.id,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.radiusMeters,
    this.managerId,
    this.managerName,
    required this.employeeCount,
    required this.status,
    this.phoneNumber,
    this.operatingHours,
  });

  factory Branch.fromJson(Map<String, dynamic> json) {
    return Branch(
      id: json['id'] as String,
      name: json['name'] as String,
      address: json['address'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      radiusMeters: json['radiusMeters'] as int,
      managerId: json['managerId'] as String?,
      managerName: json['managerName'] as String?,
      employeeCount: json['employeeCount'] as int,
      status: json['status'] as String,
      phoneNumber: json['phoneNumber'] as String?,
      operatingHours: json['operatingHours'] != null
          ? Map<String, String>.from(json['operatingHours'] as Map)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'radiusMeters': radiusMeters,
      'managerId': managerId,
      'managerName': managerName,
      'employeeCount': employeeCount,
      'status': status,
      'phoneNumber': phoneNumber,
      'operatingHours': operatingHours,
    };
  }

  bool get isActive => status == 'ACTIVE';
  bool get hasManager => managerId != null;
}
