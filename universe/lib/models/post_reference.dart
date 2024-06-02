import 'package:cloud_firestore/cloud_firestore.dart';

class PostReference {
  final String postId;
  final String authorId;
  final DateTime publishDate;

  const PostReference({
    required this.postId,
    required this.authorId,
    required this.publishDate,
  });

  factory PostReference.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return PostReference(
      postId: snapshot.id,
      authorId: data?['authorId'],
      publishDate: data?['publishDate'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {'authorId': authorId, 'publishDate': publishDate};
  }
}
