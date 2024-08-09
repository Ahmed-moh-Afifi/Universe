import 'package:universe/models/responses/followers_response.dart';
import 'package:universe/models/responses/following_response.dart';
import 'package:universe/models/data/post.dart';
import 'package:universe/models/data/post_reaction.dart';
import 'package:universe/models/responses/reactions_response.dart';
import 'package:universe/models/responses/replies_response.dart';
import 'package:universe/models/responses/search_users_response.dart';
import 'package:universe/models/data/user.dart';
import 'package:universe/models/responses/user_posts_response.dart';

abstract class IDataProvider {
  Future createUser(User user);

  Future<SearchUsersResponse> searchUsers<T, G>(String query, T start, G limit);

  Future addFollower(User user, User follower);

  Future removeFollower(User user, User follower);

  Future<User> getUser(String userUid);

  Future<FollowersResponse> getUserFollowers<T, G>(User user, T start, G limit);

  Future<FollowingResponse> getUserFollowing<T, G>(User user, T start, G limit);

  Future<int> getUserFollowersCount(User user);

  Future<int> getUserFollowingCount(User user);

  Future<bool> isUserNameAvailable(String userName);

  Future<bool> isUserOneFollowingUserTwo(User userOne, User userTwo);

  Future<void> saveUserToken(String token, User user);

  Future addPost(User author, Post post);

  Future addReply(User user, Post post, Post reply);

  Future<UserPostsResponse> getUserPosts<T, G>(User user, T start, G limit);

  Future<RepliesResponse> getPostReplies<T, G>(Post post, T start, G limit);

  Future<int> getUserPostsCount(User user);

  Future addReaction(User user, Post post, PostReaction reaction);

  Future removeReaction(Post post, PostReaction reaction);

  Future<ReactionsResponse> getPostReactions<T, G>(Post post, T start, G limit);

  Future<int> getPostReactionsCount(Post post);

  Stream<int> getPostReactionsCountStream(Post post);

  Future<PostReaction?> isPostReactedToByUser(Post post, User user);
}
