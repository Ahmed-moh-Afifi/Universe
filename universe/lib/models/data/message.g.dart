// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Message _$MessageFromJson(Map<String, dynamic> json) => Message(
      id: (json['id'] as num).toInt(),
      uid: json['uid'] as String?,
      body: json['body'] as String,
      images:
          (json['images'] as List<dynamic>).map((e) => e as String).toList(),
      videos:
          (json['videos'] as List<dynamic>).map((e) => e as String).toList(),
      audios:
          (json['audios'] as List<dynamic>).map((e) => e as String).toList(),
      publishDate: DateTime.parse(json['publishDate'] as String),
      childPostId: (json['childPostId'] as num?)?.toInt(),
      messageRepliedTo: (json['messageRepliedTo'] as num?)?.toInt(),
      authorId: json['authorId'] as String,
      widgets: (json['widgets'] as List<dynamic>?)
          ?.map((e) => Widget.fromJson(e as Map<String, dynamic>))
          .toList(),
      reactionsCount: (json['reactionsCount'] as num).toInt(),
      repliesCount: (json['repliesCount'] as num).toInt(),
      chatId: (json['chatId'] as num).toInt(),
      chat: json['chat'] == null
          ? null
          : Chat.fromJson(json['chat'] as Map<String, dynamic>),
      author: json['author'] == null
          ? null
          : User.fromJson(json['author'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MessageToJson(Message instance) => <String, dynamic>{
      'id': instance.id,
      'uid': instance.uid,
      'body': instance.body,
      'images': instance.images,
      'videos': instance.videos,
      'audios': instance.audios,
      'publishDate': instance.publishDate.toIso8601String(),
      'childPostId': instance.childPostId,
      'messageRepliedTo': instance.messageRepliedTo,
      'authorId': instance.authorId,
      'widgets': instance.widgets,
      'reactionsCount': instance.reactionsCount,
      'repliesCount': instance.repliesCount,
      'chatId': instance.chatId,
      'chat': instance.chat,
      'author': instance.author,
    };
