import 'package:universe/models/data/user.dart';
import 'package:universe/models/data/widget.dart';
import 'package:json_annotation/json_annotation.dart';

part 'post.g.dart';

@JsonSerializable()
class Post {
  int id;
  final String title;
  final String body;
  final List<dynamic> images;
  final List<dynamic> videos;
  final List<dynamic> audios;
  final DateTime publishDate;
  final int replyToPost;
  final int childPostId;
  final List<Widget> widgets;
  final User author;
  int reactionsCount;
  int repliesCount;
  bool reactedToByCaller;

  Post({
    this.id = -1,
    required this.title,
    required this.body,
    required this.images,
    required this.videos,
    required this.audios,
    required this.publishDate,
    this.replyToPost = -1,
    this.childPostId = -1,
    required this.widgets,
    required this.author,
    required this.reactionsCount,
    required this.repliesCount,
    required this.reactedToByCaller,
  });

  factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);

  Map<String, dynamic> toJson() => _$PostToJson(this);
}
