class Announcement {
  final String id;
  final String title;
  final String content;
  final String createdBy;
  final String createdByName;
  final DateTime createdAt;
  final bool isPinned;
  final String? targetBranchId;
  final List<String> readBy;

  Announcement({
    required this.id,
    required this.title,
    required this.content,
    required this.createdBy,
    required this.createdByName,
    required this.createdAt,
    this.isPinned = false,
    this.targetBranchId,
    this.readBy = const [],
  });

  factory Announcement.fromJson(Map<String, dynamic> json) => Announcement(
    id: json['id'] as String,
    title: json['title'] as String,
    content: json['content'] as String,
    createdBy: json['createdBy'] as String,
    createdByName: json['createdByName'] as String,
    createdAt: DateTime.parse(json['createdAt'] as String),
    isPinned: json['isPinned'] as bool? ?? false,
    targetBranchId: json['targetBranchId'] as String?,
    readBy: List<String>.from(json['readBy'] as List? ?? []),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'content': content,
    'createdBy': createdBy,
    'createdByName': createdByName,
    'createdAt': createdAt.toIso8601String(),
    'isPinned': isPinned,
    'targetBranchId': targetBranchId,
    'readBy': readBy,
  };
}
