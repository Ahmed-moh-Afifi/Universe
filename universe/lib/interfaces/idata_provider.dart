import 'package:universe/models/followers_response.dart';
import 'package:universe/models/following_response.dart';
import 'package:universe/models/post.dart';
import 'package:universe/models/reaction.dart';
import 'package:universe/models/reactions_response.dart';
import 'package:universe/models/replies_response.dart';
import 'package:universe/models/search_users_response.dart';
import 'package:universe/models/user.dart';
import 'package:universe/models/user_posts_response.dart';

abstract class IDataProvider {
  Future createUser(User user);
  Future addPost(User author, Post post);
  Future addFollower(User user, User follower);
  Future addReaction(User user, Post post, Reaction reaction);
  Future addReply(User user, Post post, Post reply);
  Future removeFollower(User user, User follower);
  Future removeReaction(Post post, Reaction reaction);
  Future<User> getUser(String userUid);
  Future<FollowersResponse> getUserFollowers<T, G>(User user, T start, G limit);
  Future<FollowingResponse> getUserFollowing<T, G>(User user, T start, G limit);
  Future<UserPostsResponse> getUserPosts<T, G>(User user, T start, G limit);
  Future<ReactionsResponse> getPostReactions<T, G>(Post post, T start, G limit);
  Future<RepliesResponse> getPostReplies<T, G>(Post post, T start, G limit);
  Future<int> getUserPostsCount(User user);
  Future<int> getUserFollowersCount(User user);
  Future<int> getUserFollowingCount(User user);
  Future<int> getPostReactionsCount(Post post);
  Stream<int> getPostReactionsCountStream(Post post);
  Future<SearchUsersResponse> searchUsers<T, G>(String query, T start, G limit);
  Future<bool> isUserNameAvailable(String userName);
  Future<bool> isUserOneFollowingUserTwo(User userOne, User userTwo);
  Future<Reaction?> isPostReactedToByUser(Post post, User user);
  Future<void> saveUserToken(String token, User user);
}
