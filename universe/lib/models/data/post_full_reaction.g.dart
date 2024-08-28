// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_full_reaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostFullReaction _$PostFullReactionFromJson(Map<String, dynamic> json) =>
    PostFullReaction(
      id: (json['id'] as num).toInt(),
      userId: json['userId'] as String,
      reactionType: json['reactionType'] as String,
      reactionDate: DateTime.parse(json['reactionDate'] as String),
      postId: (json['postId'] as num).toInt(),
      user: User.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PostFullReactionToJson(PostFullReaction instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'reactionType': instance.reactionType,
      'reactionDate': instance.reactionDate.toIso8601String(),
      'postId': instance.postId,
      'user': instance.user,
    };
