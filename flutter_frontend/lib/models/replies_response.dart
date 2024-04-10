import 'package:universe/models/post.dart';

class RepliesResponse {
  Iterable<Post> replies;
  Future<RepliesResponse> Function() nextPage;

  RepliesResponse({required this.replies, required this.nextPage});
}
