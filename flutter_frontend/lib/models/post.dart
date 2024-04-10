import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:universe/models/user.dart';

class Post {
  User? user;
  final String id;
  final String title;
  final String body;
  final String authorId;
  final List<String> images;
  final List<String> videos;

  Post({
    required this.id,
    required this.title,
    required this.body,
    required this.authorId,
    required this.images,
    required this.videos,
  });

  factory Post.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Post(
      id: snapshot.reference.path,
      title: data?['title'],
      body: data?['body'],
      authorId: data?['author'],
      images: data?['images'],
      videos: data?['videos'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "title": title,
      "body": body,
      "author": authorId,
      "images": images,
      "videos": videos,
    };
  }
}
