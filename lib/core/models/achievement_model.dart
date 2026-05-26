class Achievement {
  final String id;
  final String title;
  final String description;
  final String badgeIcon;
  final int requiredPoints;
  final String category;

  Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.badgeIcon,
    required this.requiredPoints,
    required this.category,
  });

  factory Achievement.fromJson(Map<String, dynamic> json) => Achievement(
    id: json['id'] as String,
    title: json['title'] as String,
    description: json['description'] as String,
    badgeIcon: json['badgeIcon'] as String,
    requiredPoints: json['requiredPoints'] as int,
    category: json['category'] as String,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'badgeIcon': badgeIcon,
    'requiredPoints': requiredPoints,
    'category': category,
  };
}
