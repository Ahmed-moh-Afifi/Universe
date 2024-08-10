import 'package:universe/models/data/user.dart';
import 'package:universe/models/requests/users_api_call_start.dart';

abstract class IUsersRepository {
  Future<User> getUser(String userId);

  Future<List<User>> searchUsers(
      String query, UsersApiCallStart start, int limit);

  Future<List<User>> getFollowers(String userId, UsersApiCallStart start);

  Future<List<User>> getFollowing(String userId, UsersApiCallStart start);

  Future followUser(String followedId, String followerId);

  Future unfollowUser(String followedId, String followerId);

  Future<int> getFollowersCount(String userId);

  Future<int> getFollowingCount(String userId);

  Future updateUser(String userId, User user);

  Future<bool> isUsernameAvailable(String username);

  Future<bool> isFollowing(String followerId, String followedId);
}
