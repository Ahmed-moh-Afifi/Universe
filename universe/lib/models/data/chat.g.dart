// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Chat _$ChatFromJson(Map<String, dynamic> json) => Chat(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      lastEdited: DateTime.parse(json['lastEdited'] as String),
    );

Map<String, dynamic> _$ChatToJson(Chat instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'lastEdited': instance.lastEdited.toIso8601String(),
    };
