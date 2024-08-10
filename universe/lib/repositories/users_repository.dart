import 'package:universe/apis/api_client.dart';
import 'package:universe/apis/users_api.dart';
import 'package:universe/interfaces/iusers_repository.dart';
import 'package:universe/models/data/user.dart';
import 'package:universe/models/requests/users_api_call_start.dart';

class UsersRepository implements IUsersRepository {
  final UsersApi _usersApi = UsersApi(ApiClient('Users').dio);

  @override
  Future<User> getUser(String userId) async {
    return await _usersApi.getUser(userId);
  }

  @override
  Future<List<User>> searchUsers(
      String query, UsersApiCallStart start, int limit) async {
    return await _usersApi.searchUsers(query, start);
  }

  @override
  Future<List<User>> getFollowers(
      String userId, UsersApiCallStart start) async {
    return await _usersApi.getFollowers(userId, start);
  }

  @override
  Future<List<User>> getFollowing(
      String userId, UsersApiCallStart start) async {
    return await _usersApi.getFollowing(userId, start);
  }

  @override
  Future followUser(String followedId, String followerId) async {
    return await _usersApi.followUser(followedId, followerId);
  }

  @override
  Future unfollowUser(String followedId, String followerId) async {
    return await _usersApi.unfollowUser(followedId, followerId);
  }

  @override
  Future<int> getFollowersCount(String userId) async {
    return await _usersApi.getFollowersCount(userId);
  }

  @override
  Future<int> getFollowingCount(String userId) async {
    return await _usersApi.getFollowingCount(userId);
  }

  @override
  Future updateUser(String userId, User user) async {
    return await _usersApi.updateUser(userId, user);
  }

  @override
  Future<bool> isUsernameAvailable(String username) async {
    return await _usersApi.isUsernameAvailable(username);
  }

  @override
  Future<bool> isFollowing(String followerId, String followedId) async {
    return await _usersApi.isFollowing(followerId, followedId);
  }
}
