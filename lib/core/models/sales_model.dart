class DailySales {
  final String id;
  final String branchId;
  final String branchName;
  final DateTime date;
  final String shiftType;
  final double totalSales;
  final double cashSales;
  final double cardSales;
  final double tips;
  final int transactionCount;
  final String recordedBy;

  DailySales({
    required this.id,
    required this.branchId,
    required this.branchName,
    required this.date,
    required this.shiftType,
    required this.totalSales,
    required this.cashSales,
    required this.cardSales,
    required this.tips,
    required this.transactionCount,
    required this.recordedBy,
  });

  factory DailySales.fromJson(Map<String, dynamic> json) => DailySales(
    id: json['id'] as String,
    branchId: json['branchId'] as String,
    branchName: json['branchName'] as String,
    date: DateTime.parse(json['date'] as String),
    shiftType: json['shiftType'] as String,
    totalSales: (json['totalSales'] as num).toDouble(),
    cashSales: (json['cashSales'] as num).toDouble(),
    cardSales: (json['cardSales'] as num).toDouble(),
    tips: (json['tips'] as num).toDouble(),
    transactionCount: json['transactionCount'] as int,
    recordedBy: json['recordedBy'] as String,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'branchId': branchId,
    'branchName': branchName,
    'date': date.toIso8601String(),
    'shiftType': shiftType,
    'totalSales': totalSales,
    'cashSales': cashSales,
    'cardSales': cardSales,
    'tips': tips,
    'transactionCount': transactionCount,
    'recordedBy': recordedBy,
  };
}
