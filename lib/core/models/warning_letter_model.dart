class WarningLetter {
  final String id;
  final String employeeId;
  final String employeeName;
  final String branchId;
  final String branchName;
  final int level;
  final DateTime issuedDate;
  final String reason;
  final String category;
  final String? notes;
  final String issuedBy;
  final String issuedByName;
  final String status;
  final DateTime? rescindedDate;
  final String? rescindedBy;
  final String? rescindReason;

  WarningLetter({
    required this.id,
    required this.employeeId,
    required this.employeeName,
    required this.branchId,
    required this.branchName,
    required this.level,
    required this.issuedDate,
    required this.reason,
    required this.category,
    this.notes,
    required this.issuedBy,
    required this.issuedByName,
    required this.status,
    this.rescindedDate,
    this.rescindedBy,
    this.rescindReason,
  });

  factory WarningLetter.fromJson(Map<String, dynamic> json) {
    return WarningLetter(
      id: json['id'] as String,
      employeeId: json['employeeId'] as String,
      employeeName: json['employeeName'] as String,
      branchId: json['branchId'] as String,
      branchName: json['branchName'] as String,
      level: json['level'] as int,
      issuedDate: DateTime.parse(json['issuedDate'] as String),
      reason: json['reason'] as String,
      category: json['category'] as String,
      notes: json['notes'] as String?,
      issuedBy: json['issuedBy'] as String,
      issuedByName: json['issuedByName'] as String,
      status: json['status'] as String,
      rescindedDate: json['rescindedDate'] != null 
          ? DateTime.parse(json['rescindedDate'] as String) 
          : null,
      rescindedBy: json['rescindedBy'] as String?,
      rescindReason: json['rescindReason'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'employeeId': employeeId,
    'employeeName': employeeName,
    'branchId': branchId,
    'branchName': branchName,
    'level': level,
    'issuedDate': issuedDate.toIso8601String(),
    'reason': reason,
    'category': category,
    'notes': notes,
    'issuedBy': issuedBy,
    'issuedByName': issuedByName,
    'status': status,
    'rescindedDate': rescindedDate?.toIso8601String(),
    'rescindedBy': rescindedBy,
    'rescindReason': rescindReason,
  };

  bool get isActive => status == 'ACTIVE';
  bool get isRescinded => status == 'RESCINDED';
}
