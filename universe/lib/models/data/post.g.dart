// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Post _$PostFromJson(Map<String, dynamic> json) => Post(
      id: (json['id'] as num?)?.toInt() ?? -1,
      uid: json['uid'] as String?,
      title: json['title'] as String,
      body: json['body'] as String,
      images: json['images'] as List<dynamic>,
      videos: json['videos'] as List<dynamic>,
      audios: json['audios'] as List<dynamic>,
      publishDate: DateTime.parse(json['publishDate'] as String),
      replyToPostId: (json['replyToPostId'] as num?)?.toInt() ?? -1,
      childPostId: (json['childPostId'] as num?)?.toInt() ?? -1,
      widgets: (json['widgets'] as List<dynamic>)
          .map((e) => Widget.fromJson(e as Map<String, dynamic>))
          .toList(),
      author: User.fromJson(json['author'] as Map<String, dynamic>),
      reactionsCount: (json['reactionsCount'] as num).toInt(),
      repliesCount: (json['repliesCount'] as num).toInt(),
      reactedToByCaller: json['reactedToByCaller'] as bool,
      childPost: json['childPost'] == null
          ? null
          : Post.fromJson(json['childPost'] as Map<String, dynamic>),
      replyToPost: json['replyToPost'] == null
          ? null
          : Post.fromJson(json['replyToPost'] as Map<String, dynamic>),
    )..callerReaction = json['callerReaction'] == null
        ? null
        : PostReaction.fromJson(json['callerReaction'] as Map<String, dynamic>);

Map<String, dynamic> _$PostToJson(Post instance) => <String, dynamic>{
      'id': instance.id,
      'uid': instance.uid,
      'title': instance.title,
      'body': instance.body,
      'images': instance.images,
      'videos': instance.videos,
      'audios': instance.audios,
      'publishDate': instance.publishDate.toIso8601String(),
      'replyToPostId': instance.replyToPostId,
      'childPostId': instance.childPostId,
      'widgets': instance.widgets,
      'author': instance.author,
      'reactionsCount': instance.reactionsCount,
      'repliesCount': instance.repliesCount,
      'reactedToByCaller': instance.reactedToByCaller,
      'callerReaction': instance.callerReaction,
      'childPost': instance.childPost,
      'replyToPost': instance.replyToPost,
    };
