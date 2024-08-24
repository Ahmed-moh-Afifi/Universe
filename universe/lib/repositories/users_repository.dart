import 'dart:developer';

import 'package:universe/apis/api_client.dart';
import 'package:universe/apis/users_api.dart';
import 'package:universe/interfaces/iusers_repository.dart';
import 'package:universe/models/data/user.dart';
import 'package:universe/models/requests/users_api_call_start.dart';

class UsersRepository implements IUsersRepository {
  final UsersApi _usersApi = UsersApi(ApiClient('Users').dio);

  @override
  Future<User> getUser(String userId) async {
    log('Getting user with id: $userId', name: 'UsersRepository');
    return await _usersApi.getUser(userId);
  }

  @override
  Future<List<User>> searchUsers(
      String query, UsersApiCallStart start, int limit) async {
    log('Searching users with query: $query', name: 'UsersRepository');
    return await _usersApi.searchUsers(query, start.lastDate, start.lastId);
  }

  @override
  Future<List<User>> getFollowers(
      String userId, UsersApiCallStart start) async {
    log('Getting followers for user with id: $userId', name: 'UsersRepository');
    return await _usersApi.getFollowers(userId, start.lastDate, start.lastId);
  }

  @override
  Future<List<User>> getFollowing(
      String userId, UsersApiCallStart start) async {
    log('Getting following for user with id: $userId', name: 'UsersRepository');
    return await _usersApi.getFollowing(userId, start.lastDate, start.lastId);
  }

  @override
  Future followUser(String followedId, String followerId) async {
    log('Following user with id: $followedId', name: 'UsersRepository');
    return await _usersApi.followUser(followedId, followerId);
  }

  @override
  Future unfollowUser(String followedId, String followerId) async {
    log('Unfollowing user with id: $followedId', name: 'UsersRepository');
    return await _usersApi.unfollowUser(followedId, followerId);
  }

  @override
  Future<int> getFollowersCount(String userId) async {
    log('Getting followers count for user with id: $userId',
        name: 'UsersRepository');
    return await _usersApi.getFollowersCount(userId);
  }

  @override
  Future<int> getFollowingCount(String userId) async {
    log('Getting following count for user with id: $userId',
        name: 'UsersRepository');
    return await _usersApi.getFollowingCount(userId);
  }

  @override
  Future updateUser(String userId, User user) async {
    log('Updating user with id: $userId', name: 'UsersRepository');
    return await _usersApi.updateUser(userId, user);
  }

  @override
  Future<bool> isUsernameAvailable(String username) async {
    log('Checking if username is available: $username',
        name: 'UsersRepository');
    return await _usersApi.isUsernameAvailable(username);
  }

  @override
  Future<bool> isFollowing(String followerId, String followedId) async {
    log('Checking if user with id: $followerId is following user with id: $followedId',
        name: 'UsersRepository');
    return await _usersApi.isFollowing(followerId, followedId);
  }
}
