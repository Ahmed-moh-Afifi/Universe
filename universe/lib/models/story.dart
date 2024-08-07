import 'package:universe/models/widget.dart';

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

  factory Story.fromJson(Map<String, dynamic> json) {
    return Story(
      id: json['id'],
      content: json['content'],
      image: json['image'],
      video: json['video'],
      audio: json['audio'],
      publishDate: DateTime.parse(json['publishDate']),
      sharedPostId: json['sharedPostId'],
      sharedStoryId: json['sharedStoryId'],
      widgets: json['widgets'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'image': image,
      'video': video,
      'audio': audio,
      'publishDate': publishDate.toIso8601String(),
      'sharedPostId': sharedPostId,
      'sharedStoryId': sharedStoryId,
      'widgets': widgets,
    };
  }
}
