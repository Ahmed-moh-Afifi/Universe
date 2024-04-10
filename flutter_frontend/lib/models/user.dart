import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String uid;
  final String firstName;
  final String lastName;
  final String userName;
  final String email;
  final String? photoUrl;

  const User(
      {required this.uid,
      required this.firstName,
      required this.lastName,
      required this.userName,
      required this.email,
      required this.photoUrl});

  factory User.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return User(
      uid: data?['uid'],
      firstName: data?['firstName'],
      lastName: data?['lastName'],
      userName: data?['firstName'] + ' ' + data?['lastName'],
      email: data?['email'],
      photoUrl: data?['photoUrl'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "uid": uid,
      "firstName": firstName,
      "lastName": lastName,
      "email": email,
      "photoUrl": photoUrl,
    };
  }
}
