// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_reaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostReaction _$PostReactionFromJson(Map<String, dynamic> json) => PostReaction(
      userId: json['userId'] as String?,
      reactionType: json['reactionType'] as String,
      reactionDate: DateTime.parse(json['reactionDate'] as String),
      postId: (json['postId'] as num).toInt(),
      id: (json['id'] as num?)?.toInt(),
    )..user = json['user'] == null
        ? null
        : User.fromJson(json['user'] as Map<String, dynamic>);

Map<String, dynamic> _$PostReactionToJson(PostReaction instance) =>
    <String, dynamic>{
      'user': instance.user,
      'id': instance.id,
      'userId': instance.userId,
      'reactionType': instance.reactionType,
      'reactionDate': instance.reactionDate.toIso8601String(),
      'postId': instance.postId,
    };
