import 'package:universe/models/followers_response.dart';
import 'package:universe/models/following_response.dart';
import 'package:universe/models/search_users_response.dart';
import 'package:universe/models/user.dart';

abstract class IusersDataProvider {
  Future<SearchUsersResponse> searchUsers<T, G>(String query, T start, G limit);
  Future<User> getUser(String userUid);
  Future addFollower(User user, User follower);
  Future removeFollower(User user, User follower);
  Future<FollowersResponse> getUserFollowers<T, G>(User user, T start, G limit);
  Future<FollowingResponse> getUserFollowing<T, G>(User user, T start, G limit);
  Future<int> getUserFollowersCount(User user);
  Future<int> getUserFollowingCount(User user);
  Future<bool> isUserNameAvailable(String userName);
  Future<bool> isUserOneFollowingUserTwo(User userOne, User userTwo);
}