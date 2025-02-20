// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Chat _$ChatFromJson(Map<String, dynamic> json) => Chat(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      lastEdited: DateTime.parse(json['lastEdited'] as String),
      photoUrl: json['photoUrl'] as String?,
      messages: (json['messages'] as List<dynamic>?)
              ?.map((e) => Message.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      users: (json['users'] as List<dynamic>?)
              ?.map((e) => User.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$ChatToJson(Chat instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'lastEdited': instance.lastEdited.toIso8601String(),
      'photoUrl': instance.photoUrl,
      'messages': instance.messages,
      'users': instance.users,
    };
