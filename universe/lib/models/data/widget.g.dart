// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'widget.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Widget _$WidgetFromJson(Map<String, dynamic> json) => Widget(
      title: json['title'] as String,
      body: json['body'] as String,
      data: json['data'] as String,
      type: $enumDecode(_$WidgetTypeEnumMap, json['type']),
    );

Map<String, dynamic> _$WidgetToJson(Widget instance) => <String, dynamic>{
      'title': instance.title,
      'body': instance.body,
      'data': instance.data,
      'type': _$WidgetTypeEnumMap[instance.type]!,
    };

const _$WidgetTypeEnumMap = {
  WidgetType.music: 0,
  WidgetType.poll: 1,
  WidgetType.stopWatch: 2,
  WidgetType.rate: 3,
  WidgetType.location: 4,
  WidgetType.code: 5,
  WidgetType.question: 6,
  WidgetType.answer: 7,
};
