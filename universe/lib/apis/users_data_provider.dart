import 'dart:developer';

import 'package:universe/apis/api_client.dart';
import 'package:universe/interfaces/iusers_data_provider.dart';
import 'package:universe/models/requests/api_call_start.dart';
import 'package:universe/models/responses/followers_response.dart';
import 'package:universe/models/responses/following_response.dart';
import 'package:universe/models/responses/search_users_response.dart';
import 'package:universe/models/data/user.dart';

class UsersDataProvider implements IusersDataProvider {
  final ApiClient _apiClient = ApiClient("/Users");
  @override
  Future<SearchUsersResponse> searchUsers<T, G>(
      String query, T start, G limit) async {
    log("Searching users", name: "UsersDataProvider");
    var response = await _apiClient.get<List<User>>(
      '/',
      (start as ApiCallStart).lastDate,
      {
        'query': query,
        'lastId': (start as ApiCallStart).lastId,
      },
    );

    SearchUsersResponse searchUsersResponse = SearchUsersResponse(
      users: response.data!,
      nextPage: () async {
        return await searchUsers<ApiCallStart, int>(
            query,
            ApiCallStart(
                lastDate: response.data!.last.joinDate,
                lastId: response.data!.last.uid),
            limit as int);
      },
    );

    return searchUsersResponse;
  }

  @override
  Future<User> getUser(String uid) async {
    log("Getting user", name: "UsersDataProvider");
    var response =
        await _apiClient.get<Map<String, dynamic>>('/$uid', null, {});
    log(response.data.toString(), name: "UsersDataProvider");
    return User.fromJson(response.data!);
  }

  @override
  Future addFollower(User user, User follower) async {
    log("Adding follower", name: "UsersDataProvider");
    await _apiClient.post('/${user.uid}/Followers/${follower.uid}', null, {});
    log("Follower added", name: "UsersDataProvider");
  }

  @override
  Future removeFollower(User user, User follower) async {
    log("Removing follower", name: "UsersDataProvider");
    await _apiClient.delete('/${user.uid}/Followers/${follower.uid}', null, {});
    log("Follower removed", name: "UsersDataProvider");
  }

  @override
  Future<int> getUserFollowersCount(User user) async {
    var response =
        await _apiClient.get<int>('/${user.uid}/Followers/Count', null, {});
    return response.data!;
  }

  @override
  Future<int> getUserFollowingCount(User user) async {
    var response =
        await _apiClient.get<int>('/${user.uid}/Following/Count', null, {});
    return response.data!;
  }

  @override
  Future<FollowersResponse> getUserFollowers<T, G>(
      User user, T start, G limit) async {
    var response = await _apiClient.get<Iterable<User>>(
      '/${user.uid}/Followers',
      (start as ApiCallStart).lastId,
      {
        'lastDate': (start as ApiCallStart).lastDate,
        'limit': limit,
      },
    );

    FollowersResponse followersResponse = FollowersResponse(
      followers: response.data!,
      nextPage: () async {
        return await getUserFollowers<ApiCallStart, int>(
            user,
            ApiCallStart(
                lastDate: response.data!.last.joinDate,
                lastId: response.data!.last.uid),
            limit as int);
      },
    );

    return followersResponse;
  }

  @override
  Future<bool> isUserNameAvailable(String userName) async {
    var response =
        await _apiClient.get<bool>('/UserName/$userName/Available', null, {});
    return response.data!;
  }

  @override
  Future<bool> isUserOneFollowingUserTwo(User userOne, User userTwo) async {
    var response = await _apiClient
        .get<bool>('/${userOne.uid}/Following/${userTwo.uid}/Exists', null, {});
    return response.data!;
  }

  @override
  Future<FollowingResponse> getUserFollowing<T, G>(
      User user, T start, G limit) async {
    var response = await _apiClient.get<Iterable<User>>(
      '/${user.uid}/Following',
      (start as ApiCallStart).lastDate,
      {
        'lastId': (start as ApiCallStart).lastId,
        'limit': limit,
      },
    );

    FollowingResponse followersResponse = FollowingResponse(
      followings: response.data!,
      nextPage: () async {
        return await getUserFollowing<ApiCallStart, int>(
            user,
            ApiCallStart(
                lastDate: response.data!.last.joinDate,
                lastId: response.data!.last.uid),
            limit as int);
      },
    );

    return followersResponse;
  }
}
