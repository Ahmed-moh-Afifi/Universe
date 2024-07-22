import 'package:universe/models/following_posts_response.dart';
import 'package:universe/models/post.dart';
import 'package:universe/models/reaction.dart';
import 'package:universe/models/reactions_response.dart';
import 'package:universe/models/replies_response.dart';
import 'package:universe/models/user.dart';
import 'package:universe/models/user_posts_response.dart';

abstract class IPostsDataProvider {
  Future<UserPostsResponse> getUserPosts<T, G>(User user, T start, G limit);
  Future addPost(User author, Post post);
  Future<RepliesResponse> getPostReplies<T, G>(Post post, T start, G limit);
  Future addReply(User user, Post post, Post reply);
  Future updatePost(Post post);
  Future deletePost(Post post);
  Future deleteReply(Post post, Post reply);
  Future sharePost(User user, Post post);
  Future<int> getUserPostsCount(User user);
  Future<ReactionsResponse> getPostReactions<T, G>(Post post, T start, G limit);
  Future addReaction(User user, Post post, Reaction reaction);
  Future<int> getPostReactionsCount(Post post);
  Future removeReaction(Post post, Reaction reaction);
  Stream<int> getPostReactionsCountStream(Post post);
  Future<Reaction?> isPostReactedToByUser(Post post, User user);
  Future<FollowingPostsResponse> getFollowingPosts<T, G>(
      User user, T start, G limit);
}
