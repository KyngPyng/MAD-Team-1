class FeedbackModel {
  final String id;
  final String type; // 'Bug Report', 'Feature Request', 'General Experience'
  final int rating;
  final String comments;
  final DateTime createdAt;

  FeedbackModel({
    required this.id,
    required this.type,
    required this.rating,
    required this.comments,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type,
        'rating': rating,
        'comments': comments,
        'createdAt': createdAt.toIso8601String(),
      };
}