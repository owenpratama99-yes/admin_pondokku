class InventoryItem {
  final String id;
  final String name;
  final String category;
  final String unit;
  final double currentStock;
  final double minStock;
  final double maxStock;
  final String branchId;
  final String branchName;
  final DateTime lastUpdated;
  final String? lastUpdatedBy;

  InventoryItem({
    required this.id,
    required this.name,
    required this.category,
    required this.unit,
    required this.currentStock,
    required this.minStock,
    required this.maxStock,
    required this.branchId,
    required this.branchName,
    required this.lastUpdated,
    this.lastUpdatedBy,
  });

  factory InventoryItem.fromJson(Map<String, dynamic> json) => InventoryItem(
    id: json['id'] as String,
    name: json['name'] as String,
    category: json['category'] as String,
    unit: json['unit'] as String,
    currentStock: (json['currentStock'] as num).toDouble(),
    minStock: (json['minStock'] as num).toDouble(),
    maxStock: (json['maxStock'] as num).toDouble(),
    branchId: json['branchId'] as String,
    branchName: json['branchName'] as String,
    lastUpdated: DateTime.parse(json['lastUpdated'] as String),
    lastUpdatedBy: json['lastUpdatedBy'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'category': category,
    'unit': unit,
    'currentStock': currentStock,
    'minStock': minStock,
    'maxStock': maxStock,
    'branchId': branchId,
    'branchName': branchName,
    'lastUpdated': lastUpdated.toIso8601String(),
    'lastUpdatedBy': lastUpdatedBy,
  };

  bool get isLowStock => currentStock <= minStock;
  bool get isCritical => currentStock <= (minStock * 0.5);
  double get stockPercentage => (currentStock / maxStock * 100).clamp(0, 100);
}
