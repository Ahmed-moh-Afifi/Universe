// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_call_start.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApiCallStart _$ApiCallStartFromJson(Map<String, dynamic> json) => ApiCallStart(
      lastDate: DateTime.parse(json['lastDate'] as String),
      lastId: json['lastId'] as String,
    );

Map<String, dynamic> _$ApiCallStartToJson(ApiCallStart instance) =>
    <String, dynamic>{
      'lastDate': instance.lastDate.toIso8601String(),
      'lastId': instance.lastId,
    };
