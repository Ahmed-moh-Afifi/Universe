import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

enum AccountState {
  @JsonValue(0)
  active,
  @JsonValue(1)
  suspended,
  @JsonValue(2)
  banned,
  @JsonValue(3)
  deleted,
}

enum OnlineStatus {
  @JsonValue(0)
  online,
  @JsonValue(1)
  offline,
}

enum AccountPrivacy {
  @JsonValue(0)
  public,
  @JsonValue(1)
  private,
}

@JsonSerializable()
class User {
  final String id;
  final String firstName;
  final String lastName;
  final String userName;
  final String email;
  final bool gender;
  final DateTime joinDate;
  final bool verified;
  String? photoUrl;
  String? bio;
  List<String>? links;
  AccountState? accountState;
  AccountPrivacy? accountPrivacy;
  OnlineStatus? onlineStatus;
  DateTime? lastOnline;
  String? notificationToken;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.userName,
    required this.email,
    required this.photoUrl,
    required this.joinDate,
    required this.gender,
    required this.verified,
    required this.bio,
    required this.links,
    required this.accountState,
    required this.accountPrivacy,
    required this.onlineStatus,
    required this.lastOnline,
    this.notificationToken,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
