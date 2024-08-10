import 'package:universe/models/data/post.dart';
import 'package:universe/models/data/post_reaction.dart';

abstract class IpostsRepository {
  Future<List<Post>> getUserPosts<T>(String authorId, T start, int limit);

  Future addPost(Post post);

  Future<List<Post>> getPostReplies<T>(
      String authorId, Post post, T start, int limit);

  Future addReply(Post post, Post reply);

  Future updatePost(Post post);

  Future deletePost(String authorId, int postId);

  Future deleteReply(Post post, Post reply);

  Future sharePost(String sharedPostAuthorId, Post post);

  Future<int> getUserPostsCount(String userId);

  Future<List<PostReaction>> getPostReactions<T>(
      String authorId, int postId, T start, int limit);

  Future addReaction(String postAuthorId, int postId, PostReaction reaction);

  Future<int> getPostReactionsCount(String authorId, int postId);

  Future removeReaction(String postAuthorId, int postId, int reactionId);

  Future<PostReaction?> isPostReactedToByUser(
      String postAuthorId, int postId, String userId);

  Future<List<Post>> getFollowingPosts<T>(String userId, T start, int limit);
}
