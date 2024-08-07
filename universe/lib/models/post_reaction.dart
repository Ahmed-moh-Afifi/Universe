import 'package:universe/models/user.dart';

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

  // factory PostReaction.fromFirestore(
  //   DocumentSnapshot<Map<String, dynamic>> snapshot,
  //   SnapshotOptions? options,
  // ) {
  //   final data = snapshot.data();
  //   return PostReaction(
  //     reactionId: snapshot.reference.path,
  //     userId: snapshot.reference.id,
  //     reactionType: data?['type'],
  //     reactionDate: data?['reactionDate'].toDate(),
  //   );
  // }

  // Map<String, dynamic> toFirestore() {
  //   return {
  //     'type': reactionType,
  //     'reactionDate': Timestamp.fromDate(reactionDate),
  //   };
  // }
}
