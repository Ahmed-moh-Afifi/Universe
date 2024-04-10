import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:universe/models/user.dart';

class Reaction {
  User? user;
  final String userReference;
  final String reactionType;
  final Timestamp reactionDate;

  Reaction({
    required this.userReference,
    required this.reactionType,
    required this.reactionDate,
  });

  factory Reaction.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Reaction(
      userReference: data?['userReference'],
      reactionType: data?['type'],
      reactionDate: data?['reactionDate'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userReference': userReference,
      'type': reactionType,
      'reactionDate': reactionDate,
    };
  }
}
