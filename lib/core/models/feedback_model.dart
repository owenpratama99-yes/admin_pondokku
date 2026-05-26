class CustomerFeedback {
  final String id;
  final String branchId;
  final String branchName;
  final String customerName;
  final String category;
  final String description;
  final int rating;
  final DateTime createdAt;
  final String status;
  final String? response;
  final String? respondedBy;
  final DateTime? respondedAt;

  CustomerFeedback({
    required this.id,
    required this.branchId,
    required this.branchName,
    required this.customerName,
    required this.category,
    required this.description,
    required this.rating,
    required this.createdAt,
    required this.status,
    this.response,
    this.respondedBy,
    this.respondedAt,
  });

  factory CustomerFeedback.fromJson(Map<String, dynamic> json) => CustomerFeedback(
    id: json['id'] as String,
    branchId: json['branchId'] as String,
    branchName: json['branchName'] as String,
    customerName: json['customerName'] as String,
    category: json['category'] as String,
    description: json['description'] as String,
    rating: json['rating'] as int,
    createdAt: DateTime.parse(json['createdAt'] as String),
    status: json['status'] as String,
    response: json['response'] as String?,
    respondedBy: json['respondedBy'] as String?,
    respondedAt: json['respondedAt'] != null 
        ? DateTime.parse(json['respondedAt'] as String) 
        : null,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'branchId': branchId,
    'branchName': branchName,
    'customerName': customerName,
    'category': category,
    'description': description,
    'rating': rating,
    'createdAt': createdAt.toIso8601String(),
    'status': status,
    'response': response,
    'respondedBy': respondedBy,
    'respondedAt': respondedAt?.toIso8601String(),
  };
}
