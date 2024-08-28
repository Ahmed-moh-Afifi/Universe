import 'package:universe/models/data/post.dart';
import 'package:universe/models/data/post_full_reaction.dart';
import 'package:universe/models/data/post_reaction.dart';
import 'package:universe/models/requests/api_call_start.dart';

abstract class IPostsRepository {
  Future<List<Post>> getUserPosts(
      String authorId, ApiCallStart start, int limit);

  Future addPost(Post post);

  Future<List<Post>> getPostReplies(
      String authorId, int postId, ApiCallStart start, int limit);

  Future addReply(String authorId, int postId, Post reply);

  Future updatePost(Post post);

  Future deletePost(String authorId, int postId);

  Future deleteReply(Post post, Post reply);

  Future sharePost(String sharedPostAuthorId, Post post);

  Future<int> getUserPostsCount(String userId);

  Future<List<PostFullReaction>> getPostReactions(
      String authorId, int postId, ApiCallStart start, int limit);

  Future addReaction(String postAuthorId, int postId, PostReaction reaction);

  Future<int> getPostReactionsCount(String authorId, int postId);

  Future removeReaction(String postAuthorId, int postId, int reactionId);

  Future<PostReaction?> isPostReactedToByUser(
      String postAuthorId, int postId, String userId);

  Future<List<Post>> getFollowingPosts(
      String userId, ApiCallStart start, int limit);
}
