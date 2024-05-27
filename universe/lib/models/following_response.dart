import 'package:universe/models/following.dart';

class FollowingResponse {
  final Iterable<Following> followings;
  final Future<FollowingResponse> Function() nextPage;

  FollowingResponse({required this.followings, required this.nextPage});
}
