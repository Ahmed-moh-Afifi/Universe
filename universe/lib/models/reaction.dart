import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:universe/models/user.dart';

class Reaction {
  User? user;
  final String? reactionId;
  final String? userId;
  final String reactionType;
  final DateTime reactionDate;

  Reaction({
    required this.userId,
    required this.reactionType,
    required this.reactionDate,
    this.reactionId,
  });

  factory Reaction.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Reaction(
      reactionId: snapshot.reference.path,
      userId: snapshot.reference.id,
      reactionType: data?['type'],
      reactionDate: data?['reactionDate'].toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'type': reactionType,
      'reactionDate': Timestamp.fromDate(reactionDate),
    };
  }
}
