import 'package:universe/models/user.dart';

class FollowingResponse {
  final Iterable<User> followings;
  final Future<FollowingResponse> Function() nextPage;

  FollowingResponse({required this.followings, required this.nextPage});
}
