import 'package:json_annotation/json_annotation.dart';
import 'package:universe/models/data/widget.dart';

part 'story.g.dart';

@JsonSerializable()
class Story {
  int id;
  String content;
  String? image;
  String? video;
  String? audio;
  DateTime publishDate;
  int sharedPostId;
  int sharedStoryId;
  List<Widget> widgets;

  Story({
    required this.id,
    required this.content,
    required this.image,
    required this.video,
    required this.audio,
    required this.publishDate,
    required this.sharedPostId,
    required this.sharedStoryId,
    required this.widgets,
  });

  factory Story.fromJson(Map<String, dynamic> json) => _$StoryFromJson(json);

  Map<String, dynamic> toJson() => _$StoryToJson(this);
}
