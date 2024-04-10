import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:universe/models/user.dart';

class Following {
  late User user;
  final String userReference;
  final Timestamp followDate;

  Following({required this.userReference, required this.followDate});

  factory Following.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options) {
    final data = snapshot.data();
    return Following(
      userReference: data?['userReference'],
      followDate: data?['followDate'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {'userReference': userReference, 'followDate': followDate};
  }
}
