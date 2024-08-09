import 'package:universe/models/data/user.dart';
import 'package:universe/models/data/widget.dart';

class Post {
  String? id;
  final String title;
  final String body;
  final List<dynamic> images;
  final List<dynamic> videos;
  final List<dynamic> audios;
  final DateTime publishDate;
  final String? replyToPost;
  final String? childPostId;
  final List<Widget> widgets;
  User? author;

  Post({
    this.id,
    required this.title,
    required this.body,
    required this.images,
    required this.videos,
    required this.audios,
    required this.publishDate,
    required this.replyToPost,
    required this.childPostId,
    required this.widgets,
    this.author,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'].toString(),
      title: json['title'],
      body: json['body'],
      images: json['images'],
      videos: json['videos'],
      audios: json['audios'],
      publishDate: DateTime.parse(json['publishDate']),
      replyToPost: json['replyToPost'].toString(),
      childPostId: json['childPostId'].toString(),
      widgets: json['widgets']
          .map<Widget>((widget) => Widget.fromJson(widget))
          .toList(),
      author: User.fromJson(json['author']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id ?? 0,
      'title': title,
      'body': body,
      'images': images,
      'videos': videos,
      'audios': audios,
      'publishDate': publishDate.toIso8601String(),
      'replyToPost': replyToPost,
      'childPostId': childPostId,
      'widgets': widgets.map((widget) => widget.toJson()).toList(),
      'author': author?.toJson(),
    };
  }

  // factory Post.fromFirestore(
  //   DocumentSnapshot<Map<String, dynamic>> snapshot,
  //   SnapshotOptions? options,
  // ) {
  //   final data = snapshot.data();
  //   return Post(
  //     id: snapshot.reference.path,
  //     title: data?['title'],
  //     body: data?['body'],
  //     authorId: data?['author'],
  //     images: data?['images'],
  //     videos: data?['videos'],
  //     publishDate: data?['publishDate'].toDate(),
  //   );
  // }

  // Map<String, dynamic> toFirestore() {
  //   return {
  //     "title": title,
  //     "body": body,
  //     "author": authorId,
  //     "images": images,
  //     "videos": videos,
  //     "publishDate": Timestamp.fromDate(publishDate),
  //   };
  // }
}
