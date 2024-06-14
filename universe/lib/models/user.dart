import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:universe/extensions/string_extensions.dart';

class User {
  final String uid;
  final String firstName;
  final String lastName;
  final String userName;
  final String email;
  final String? photoUrl;
  final Timestamp joinDate;
  final bool gender;
  final bool verified;
  String? notificationToken;

  User({
    required this.uid,
    required this.firstName,
    required this.lastName,
    required this.userName,
    required this.email,
    required this.photoUrl,
    required this.joinDate,
    required this.gender,
    required this.verified,
    this.notificationToken,
  });

  factory User.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    final firstNameProgressiveSubStrings = data?['firstName'];
    final lastNameProgressiveSubStrings = data?['lastName'];
    return User(
      uid: data?['uid'],
      firstName: StringExtensionsClass.capitalizeWords(
        firstNameProgressiveSubStrings
            .elementAt(firstNameProgressiveSubStrings.length - 1),
      ),
      lastName: StringExtensionsClass.capitalizeWords(
        lastNameProgressiveSubStrings
            .elementAt(lastNameProgressiveSubStrings.length - 1),
      ),
      userName: data?['userName'],
      email: data?['email'],
      photoUrl: data?['photoUrl'],
      joinDate: data?['joinDate'],
      gender: data?['gender'],
      verified: data?['verified'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "uid": uid,
      "firstName": firstName.toLowerCase().progressiveSubstrings(),
      "lastName": lastName.toLowerCase().progressiveSubstrings(),
      "email": email,
      "userName": userName,
      "photoUrl": photoUrl,
      "joinDate": joinDate,
      "gender": gender,
      "verified": verified,
      "fcmToken": notificationToken,
    };
  }
}
