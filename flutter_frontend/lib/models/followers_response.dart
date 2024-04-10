import 'package:universe/models/follower.dart';

class FollowersResponse {
  final Iterable<Follower> followers;
  final Future<FollowersResponse> Function() nextPage;

  const FollowersResponse({required this.followers, required this.nextPage});
}
