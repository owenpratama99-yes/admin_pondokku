class TaskTemplate {
  final String id;
  final String title;
  final String description;
  final String category;
  final int pointValue;
  final bool isRecurring;
  final String? recurrencePattern;

  TaskTemplate({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.pointValue,
    this.isRecurring = false,
    this.recurrencePattern,
  });

  factory TaskTemplate.fromJson(Map<String, dynamic> json) => TaskTemplate(
    id: json['id'] as String,
    title: json['title'] as String,
    description: json['description'] as String,
    category: json['category'] as String,
    pointValue: json['pointValue'] as int,
    isRecurring: json['isRecurring'] as bool? ?? false,
    recurrencePattern: json['recurrencePattern'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'category': category,
    'pointValue': pointValue,
    'isRecurring': isRecurring,
    'recurrencePattern': recurrencePattern,
  };
}
