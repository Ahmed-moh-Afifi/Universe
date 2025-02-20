import 'package:json_annotation/json_annotation.dart';
import 'package:universe/models/data/message.dart';
import 'package:universe/models/data/user.dart';

part 'chat.g.dart';

@JsonSerializable()
class Chat {
  int id;
  String name;
  DateTime lastEdited;
  String? photoUrl;
  List<Message> messages = [];
  List<User> users = [];

  Chat({
    required this.id,
    required this.name,
    required this.lastEdited,
    this.photoUrl,
    this.messages = const [],
    this.users = const [],
  });

  factory Chat.fromJson(Map<String, dynamic> json) => _$ChatFromJson(json);

  Map<String, dynamic> toJson() => _$ChatToJson(this);
}
