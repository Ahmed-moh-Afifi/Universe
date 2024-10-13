// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'string_list_wrapper.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StringListWrapper _$StringListWrapperFromJson(Map<String, dynamic> json) =>
    StringListWrapper(
      strings:
          (json['strings'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$StringListWrapperToJson(StringListWrapper instance) =>
    <String, dynamic>{
      'strings': instance.strings,
    };
