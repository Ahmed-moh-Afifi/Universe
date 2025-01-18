// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_status.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserStatus _$UserStatusFromJson(Map<String, dynamic> json) => UserStatus(
      status: json['status'] as String,
      lastOnline: DateTime.parse(json['lastOnline'] as String),
    );

Map<String, dynamic> _$UserStatusToJson(UserStatus instance) =>
    <String, dynamic>{
      'status': instance.status,
      'lastOnline': instance.lastOnline.toIso8601String(),
    };
