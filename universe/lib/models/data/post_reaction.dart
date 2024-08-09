import 'package:universe/models/data/user.dart';

class PostReaction {
  User? user;
  final String? id;
  final String? userId;
  final String reactionType;
  final DateTime reactionDate;
  final String postId;

  PostReaction({
    required this.userId,
    required this.reactionType,
    required this.reactionDate,
    required this.postId,
    this.id,
  });

  factory PostReaction.fromJson(Map<String, dynamic> data) {
    return PostReaction(
      userId: data['userId'],
      reactionType: data['reactionType'],
      reactionDate: DateTime.parse(data['reactionDate']),
      postId: data['postId'],
      id: data['id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'reactionType': reactionType,
      'reactionDate': reactionDate.toIso8601String(),
      'postId': postId,
    };
  }
}
