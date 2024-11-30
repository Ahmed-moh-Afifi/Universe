import 'package:universe/models/data/post_reaction.dart';
import 'package:universe/models/data/user.dart';
import 'package:universe/models/data/widget.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

part 'post.g.dart';

@JsonSerializable()
class Post {
  int id;
  String? uid;
  final String title;
  final String body;
  List<dynamic> images;
  List<dynamic> videos;
  List<dynamic> audios;
  final DateTime publishDate;
  final int replyToPostId;
  final int childPostId;
  final List<Widget> widgets;
  final User author;
  int reactionsCount;
  int repliesCount;
  bool reactedToByCaller;
  PostReaction? callerReaction;
  Post? childPost;
  Post? replyToPost;

  Post({
    this.id = -1,
    this.uid,
    required this.title,
    required this.body,
    required this.images,
    required this.videos,
    required this.audios,
    required this.publishDate,
    this.replyToPostId = -1,
    this.childPostId = -1,
    required this.widgets,
    required this.author,
    required this.reactionsCount,
    required this.repliesCount,
    required this.reactedToByCaller,
    this.childPost,
    this.replyToPost,
  }) {
    uid ??= const Uuid().v4();
  }

  Post copyWith({
    int? id,
    String? uid,
    String? title,
    String? body,
    List<dynamic>? images,
    List<dynamic>? videos,
    List<dynamic>? audios,
    DateTime? publishDate,
    int? replyToPostId,
    int? childPostId,
    List<Widget>? widgets,
    User? author,
    int? reactionsCount,
    int? repliesCount,
    bool? reactedToByCaller,
    PostReaction? callerReaction,
  }) {
    return Post(
      id: id ?? this.id,
      uid: uid ?? this.uid,
      title: title ?? this.title,
      body: body ?? this.body,
      images: images ?? this.images,
      videos: videos ?? this.videos,
      audios: audios ?? this.audios,
      publishDate: publishDate ?? this.publishDate,
      replyToPostId: replyToPostId ?? this.replyToPostId,
      childPostId: childPostId ?? this.childPostId,
      widgets: widgets ?? this.widgets,
      author: author ?? this.author,
      reactionsCount: reactionsCount ?? this.reactionsCount,
      repliesCount: repliesCount ?? this.repliesCount,
      reactedToByCaller: reactedToByCaller ?? this.reactedToByCaller,
    )..callerReaction = callerReaction ?? this.callerReaction;
  }

  factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);

  Map<String, dynamic> toJson() => _$PostToJson(this);
}
