import 'package:dio/dio.dart';
import 'package:universe/interfaces/iusers_data_provider.dart';
import 'package:universe/models/api_call_start.dart';
import 'package:universe/models/followers_response.dart';
import 'package:universe/models/following_response.dart';
import 'package:universe/models/search_users_response.dart';
import 'package:universe/models/user.dart';

class UsersDataProvider implements IusersDataProvider {
  final dioClient = Dio();

  UsersDataProvider() {
    dioClient.options.baseUrl = 'https://localhost:5149/users';
  }

  @override
  Future<SearchUsersResponse> searchUsers<T, G>(
      String query, T start, G limit) async {
    var response = await dioClient.get<List<User>>('/', queryParameters: {
      'query': query,
      'lastDate': (start as ApiCallStart).lastDate,
      'lastId': (start as ApiCallStart).lastId,
    });

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
    var response = await dioClient.get<User>('/$uid');
    return response.data!;
  }

  @override
  Future addFollower(User user, User follower) async {
    await dioClient.post('/${user.uid}/followers/${follower.uid}');
  }

  @override
  Future removeFollower(User user, User follower) async {
    await dioClient.delete('/${user.uid}/followers/${follower.uid}');
  }

  @override
  Future<int> getUserFollowersCount(User user) async {
    var response = await dioClient.get<int>('/${user.uid}/followers/count');
    return response.data!;
  }

  @override
  Future<int> getUserFollowingCount(User user) async {
    var response = await dioClient.get<int>('/${user.uid}/following/count');
    return response.data!;
  }

  @override
  Future<FollowersResponse> getUserFollowers<T, G>(
      User user, T start, G limit) async {
    var response = await dioClient
        .get<Iterable<User>>('/${user.uid}/followers', queryParameters: {
      'lastDate': (start as ApiCallStart).lastDate,
      'lastId': (start as ApiCallStart).lastId,
      'limit': limit,
    });

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
    var response = await dioClient.get<bool>('/userName/$userName/available');
    return response.data!;
  }

  @override
  Future<bool> isUserOneFollowingUserTwo(User userOne, User userTwo) async {
    var response = await dioClient
        .get<bool>('/${userOne.uid}/following/${userTwo.uid}/exists');
    return response.data!;
  }

  @override
  Future<FollowingResponse> getUserFollowing<T, G>(
      User user, T start, G limit) async {
    var response = await dioClient
        .get<Iterable<User>>('/${user.uid}/following', queryParameters: {
      'lastDate': (start as ApiCallStart).lastDate,
      'lastId': (start as ApiCallStart).lastId,
      'limit': limit,
    });

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
