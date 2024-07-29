enum AccountState { active, suspended, banned, deleted }

enum OnlineStatus { online, offline }

enum AccountPrivacy { public, private }

class User {
  final String uid;
  final String firstName;
  final String lastName;
  final String userName;
  final String email;
  final bool gender;
  final DateTime joinDate;
  String? photoUrl;
  final bool verified;
  String? bio;
  AccountState? accountState;
  AccountPrivacy? accountPrivacy;
  OnlineStatus? onlineStatus;
  DateTime? lastOnline;
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
    required this.bio,
    required this.accountState,
    required this.accountPrivacy,
    required this.onlineStatus,
    required this.lastOnline,
    this.notificationToken,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      uid: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      userName: json['userName'],
      email: json['email'],
      photoUrl: json['photoUrl'],
      joinDate: DateTime.parse(json['joinDate']),
      gender: json['gender'],
      verified: json['verified'],
      bio: json['bio'],
      accountState: AccountState.values[json['accountState']],
      accountPrivacy: AccountPrivacy.values[json['accountPrivacy']],
      onlineStatus: OnlineStatus.values[json['onlineStatus']],
      lastOnline: json['lastOnline'] == null
          ? null
          : DateTime.parse(json['lastOnline']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'firstName': firstName,
      'lastName': lastName,
      'userName': userName,
      'email': email,
      'photoUrl': photoUrl,
      'joinDate': joinDate,
      'gender': gender,
      'verified': verified,
      'bio': bio,
      'accountState': accountState,
      'accountPrivacy': accountPrivacy,
      'onlineStatus': onlineStatus,
      'lastOnline': lastOnline,
    };
  }

  // factory User.fromFirestore(
  //   DocumentSnapshot<Map<String, dynamic>> snapshot,
  //   SnapshotOptions? options,
  // ) {
  //   final data = snapshot.data();
  //   final firstNameProgressiveSubStrings = data?['firstName'];
  //   final lastNameProgressiveSubStrings = data?['lastName'];
  //   return User(
  //     uid: data?['uid'],
  //     firstName: StringExtensionsClass.capitalizeWords(
  //       firstNameProgressiveSubStrings
  //           .elementAt(firstNameProgressiveSubStrings.length - 1),
  //     ),
  //     lastName: StringExtensionsClass.capitalizeWords(
  //       lastNameProgressiveSubStrings
  //           .elementAt(lastNameProgressiveSubStrings.length - 1),
  //     ),
  //     userName: data?['userName'],
  //     email: data?['email'],
  //     photoUrl: data?['photoUrl'],
  //     joinDate: (data?['joinDate'] as Timestamp).toDate(),
  //     gender: data?['gender'],
  //     verified: data?['verified'],
  //   );
  // }

  // Map<String, dynamic> toFirestore() {
  //   return {
  //     "uid": uid,
  //     "firstName": firstName.toLowerCase().progressiveSubstrings(),
  //     "lastName": lastName.toLowerCase().progressiveSubstrings(),
  //     "email": email,
  //     "userName": userName,
  //     "photoUrl": photoUrl,
  //     "joinDate": joinDate,
  //     "gender": gender,
  //     "verified": verified,
  //     "fcmToken": notificationToken,
  //   };
  // }
}
