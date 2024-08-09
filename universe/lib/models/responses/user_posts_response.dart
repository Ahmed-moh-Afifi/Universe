import 'package:universe/models/data/post.dart';

class UserPostsResponse {
  final Iterable<Post> posts;
  final Future<UserPostsResponse> Function() nextPage;

  const UserPostsResponse({required this.posts, required this.nextPage});
}
