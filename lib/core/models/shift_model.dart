class Shift {
  final String id;
  final String employeeId;
  final String employeeName;
  final String branchId;
  final String branchName;
  final DateTime date;
  final String shiftType;
  final String startTime;
  final String endTime;
  final String status;
  final String? swapRequestId;
  final bool isOvertime;
  final int? overtimeMinutes;

  Shift({
    required this.id,
    required this.employeeId,
    required this.employeeName,
    required this.branchId,
    required this.branchName,
    required this.date,
    required this.shiftType,
    required this.startTime,
    required this.endTime,
    required this.status,
    this.swapRequestId,
    this.isOvertime = false,
    this.overtimeMinutes,
  });

  factory Shift.fromJson(Map<String, dynamic> json) => Shift(
    id: json['id'] as String,
    employeeId: json['employeeId'] as String,
    employeeName: json['employeeName'] as String,
    branchId: json['branchId'] as String,
    branchName: json['branchName'] as String,
    date: DateTime.parse(json['date'] as String),
    shiftType: json['shiftType'] as String,
    startTime: json['startTime'] as String,
    endTime: json['endTime'] as String,
    status: json['status'] as String,
    swapRequestId: json['swapRequestId'] as String?,
    isOvertime: json['isOvertime'] as bool? ?? false,
    overtimeMinutes: json['overtimeMinutes'] as int?,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'employeeId': employeeId,
    'employeeName': employeeName,
    'branchId': branchId,
    'branchName': branchName,
    'date': date.toIso8601String(),
    'shiftType': shiftType,
    'startTime': startTime,
    'endTime': endTime,
    'status': status,
    'swapRequestId': swapRequestId,
    'isOvertime': isOvertime,
    'overtimeMinutes': overtimeMinutes,
  };
}
