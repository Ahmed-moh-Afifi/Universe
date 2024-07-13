import 'package:universe/models/user.dart';

class FollowersResponse {
  final Iterable<User> followers;
  final Future<FollowersResponse> Function() nextPage;

  const FollowersResponse({required this.followers, required this.nextPage});
}
