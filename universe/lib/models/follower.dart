import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:universe/models/user.dart';

class Follower {
  late User user;
  final String userReference;
  final Timestamp followDate;
  Follower({required this.userReference, required this.followDate});

  factory Follower.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options) {
    final data = snapshot.data();
    return Follower(
      userReference: data?['userReference'],
      followDate: data?['followDate'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {'userReference': userReference, 'followDate': followDate};
  }
}
