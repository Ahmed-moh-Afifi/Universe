// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      id: json['id'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      userName: json['userName'] as String,
      email: json['email'] as String,
      photoUrl: json['photoUrl'] as String?,
      joinDate: DateTime.parse(json['joinDate'] as String),
      gender: json['gender'] as bool,
      verified: json['verified'] as bool,
      bio: json['bio'] as String?,
      links:
          (json['links'] as List<dynamic>?)?.map((e) => e as String).toList(),
      accountState:
          $enumDecodeNullable(_$AccountStateEnumMap, json['accountState']),
      accountPrivacy:
          $enumDecodeNullable(_$AccountPrivacyEnumMap, json['accountPrivacy']),
      onlineSessions: (json['onlineSessions'] as num).toInt(),
      lastOnline: json['lastOnline'] == null
          ? null
          : DateTime.parse(json['lastOnline'] as String),
      notificationToken: json['notificationToken'] as String?,
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'userName': instance.userName,
      'email': instance.email,
      'gender': instance.gender,
      'joinDate': instance.joinDate.toIso8601String(),
      'verified': instance.verified,
      'photoUrl': instance.photoUrl,
      'bio': instance.bio,
      'links': instance.links,
      'accountState': _$AccountStateEnumMap[instance.accountState],
      'accountPrivacy': _$AccountPrivacyEnumMap[instance.accountPrivacy],
      'onlineSessions': instance.onlineSessions,
      'lastOnline': instance.lastOnline?.toIso8601String(),
      'notificationToken': instance.notificationToken,
    };

const _$AccountStateEnumMap = {
  AccountState.active: 0,
  AccountState.suspended: 1,
  AccountState.banned: 2,
  AccountState.deleted: 3,
};

const _$AccountPrivacyEnumMap = {
  AccountPrivacy.public: 0,
  AccountPrivacy.private: 1,
};
