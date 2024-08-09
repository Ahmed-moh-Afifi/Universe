import 'package:universe/models/data/post.dart';

class FollowingPostsResponse {
  List<Post> posts;
  final Future<FollowingPostsResponse> Function() nextPage;

  FollowingPostsResponse({required this.posts, required this.nextPage});
}
