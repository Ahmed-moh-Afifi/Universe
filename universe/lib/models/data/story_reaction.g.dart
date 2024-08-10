// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'story_reaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StoryReaction _$StoryReactionFromJson(Map<String, dynamic> json) =>
    StoryReaction(
      id: (json['id'] as num).toInt(),
      userId: json['userId'] as String,
      reactionType: json['reactionType'] as String,
      reactionDate: DateTime.parse(json['reactionDate'] as String),
      storyId: (json['storyId'] as num).toInt(),
    );

Map<String, dynamic> _$StoryReactionToJson(StoryReaction instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'reactionType': instance.reactionType,
      'reactionDate': instance.reactionDate.toIso8601String(),
      'storyId': instance.storyId,
    };
