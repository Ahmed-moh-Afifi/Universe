// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'users_api_call_start.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UsersApiCallStart _$UsersApiCallStartFromJson(Map<String, dynamic> json) =>
    UsersApiCallStart(
      lastId: json['lastId'] as String?,
      lastDate: json['lastDate'] == null
          ? null
          : DateTime.parse(json['lastDate'] as String),
    );

Map<String, dynamic> _$UsersApiCallStartToJson(UsersApiCallStart instance) =>
    <String, dynamic>{
      'lastId': instance.lastId,
      'lastDate': instance.lastDate?.toIso8601String(),
    };
