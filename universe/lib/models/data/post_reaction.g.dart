// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_reaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostReaction _$PostReactionFromJson(Map<String, dynamic> json) => PostReaction(
      id: (json['id'] as num?)?.toInt() ?? -1,
      userId: json['userId'] as String,
      reactionType: json['reactionType'] as String,
      reactionDate: DateTime.parse(json['reactionDate'] as String),
      postId: (json['postId'] as num).toInt(),
    );

Map<String, dynamic> _$PostReactionToJson(PostReaction instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'reactionType': instance.reactionType,
      'reactionDate': instance.reactionDate.toIso8601String(),
      'postId': instance.postId,
    };
