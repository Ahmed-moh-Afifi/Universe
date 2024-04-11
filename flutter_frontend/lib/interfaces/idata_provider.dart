import 'package:universe/models/followers_response.dart';
import 'package:universe/models/following_response.dart';
import 'package:universe/models/post.dart';
import 'package:universe/models/reaction.dart';
import 'package:universe/models/reactions_response.dart';
import 'package:universe/models/replies_response.dart';
import 'package:universe/models/user.dart';
import 'package:universe/models/user_posts_response.dart';

abstract class IDataProvider {
  Future createUser(User user);
  Future addPost(User author, Post post);
  Future addFollower(User user, User follower);
  Future addReaction(Post post, Reaction reaction);
  Future addReply(Post post, Post reply);
  Future<User> getUser(String userUid);
  Future<FollowersResponse> getUserFollowers<T, G>(User user, T start, G limit);
  Future<FollowingResponse> getUserFollowing<T, G>(User user, T start, G limit);
  Future<UserPostsResponse> getUserPosts<T, G>(User user, T start, G limit);
  Future<ReactionsResponse> getPostReactions<T, G>(Post post, T start, G limit);
  Future<RepliesResponse> getPostReplies<T, G>(Post post, T start, G limit);
}
