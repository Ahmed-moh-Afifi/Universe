// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'story.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Story _$StoryFromJson(Map<String, dynamic> json) => Story(
      id: (json['id'] as num).toInt(),
      content: json['content'] as String,
      image: json['image'] as String?,
      video: json['video'] as String?,
      audio: json['audio'] as String?,
      publishDate: DateTime.parse(json['publishDate'] as String),
      sharedPostId: (json['sharedPostId'] as num).toInt(),
      sharedStoryId: (json['sharedStoryId'] as num).toInt(),
      widgets: (json['widgets'] as List<dynamic>)
          .map((e) => Widget.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$StoryToJson(Story instance) => <String, dynamic>{
      'id': instance.id,
      'content': instance.content,
      'image': instance.image,
      'video': instance.video,
      'audio': instance.audio,
      'publishDate': instance.publishDate.toIso8601String(),
      'sharedPostId': instance.sharedPostId,
      'sharedStoryId': instance.sharedStoryId,
      'widgets': instance.widgets,
    };
