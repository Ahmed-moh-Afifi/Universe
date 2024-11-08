import 'package:json_annotation/json_annotation.dart';
import 'package:universe/models/data/chat.dart';
import 'package:universe/models/data/user.dart';
import 'package:universe/models/data/widget.dart';

part 'message.g.dart';

@JsonSerializable()
class Message {
  final int id;
  final String body;
  final List<String> images;
  final List<String> videos;
  final List<String> audios;
  final DateTime publishDate;
  int? childPostId;
  int? messageRepliedTo;
  final String authorId;
  List<Widget>? widgets;
  int reactionsCount;
  int repliesCount;
  final int chatId;
  Chat? chat;
  User? author;

  Message({
    required this.id,
    required this.body,
    required this.images,
    required this.videos,
    required this.audios,
    required this.publishDate,
    this.childPostId,
    this.messageRepliedTo,
    required this.authorId,
    this.widgets,
    required this.reactionsCount,
    required this.repliesCount,
    required this.chatId,
    this.chat,
    this.author,
  });

  factory Message.fromJson(Map<String, dynamic> json) =>
      _$MessageFromJson(json);

  Map<String, dynamic> toJson() => _$MessageToJson(this);
}
