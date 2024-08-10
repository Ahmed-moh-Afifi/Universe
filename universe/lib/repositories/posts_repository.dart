import 'package:universe/apis/api_client.dart';
import 'package:universe/apis/posts_api.dart';
import 'package:universe/interfaces/iposts_repository.dart';
import 'package:universe/models/data/post.dart';
import 'package:universe/models/data/post_reaction.dart';
import 'package:universe/models/requests/api_call_start.dart';

class PostsRepository implements IpostsRepository {
  final _postsApi = PostsApi(ApiClient('').dio);

  @override
  Future<List<Post>> getUserPosts<T>(
      String authorId, T start, int limit) async {
    return await _postsApi.getUserPosts(authorId, start as ApiCallStart);
  }

  @override
  Future addPost(Post post) async {
    await _postsApi.addPost(post.author.id, post);
  }

  @override
  Future<List<Post>> getPostReplies<T>(
      String authorId, Post post, T start, int limit) async {
    return await _postsApi.getPostReplies(
      authorId,
      post.id!,
      start as ApiCallStart,
    );
  }

  @override
  Future addReply(Post post, Post reply) async {
    await _postsApi.addReply(post.author.id, post.id!, reply);
  }

  @override
  Future updatePost(Post post) async {
    await _postsApi.updatePost(post.author.id, post);
  }

  @override
  Future deletePost(String authorId, int postId) async {
    await _postsApi.deletePost(authorId, postId);
  }

  @override
  Future deleteReply(Post post, Post reply) async {
    await _postsApi.deleteReply(post.author.id, post.id!, reply.id!);
  }

  @override
  Future sharePost(String sharedPostAuthorId, Post post) async {
    await _postsApi.sharePost(sharedPostAuthorId, post.childPostId!, post);
  }

  @override
  Future<int> getUserPostsCount(String userId) async {
    return await _postsApi.getUserPostsCount(userId);
  }

  @override
  Future<List<PostReaction>> getPostReactions<T>(
      String authorId, int postId, T start, int limit) async {
    return await _postsApi.getPostReactions(
        authorId, postId, start as ApiCallStart);
  }

  @override
  Future addReaction(
      String postAuthorId, int postId, PostReaction reaction) async {
    await _postsApi.addReaction(postAuthorId, postId, reaction);
  }

  @override
  Future<int> getPostReactionsCount(String authorId, int postId) async {
    return await _postsApi.getPostReactionsCount(authorId, postId);
  }

  @override
  Future removeReaction(String postAuthorId, int postId, int reactionId) async {
    await _postsApi.removeReaction(postAuthorId, postId, reactionId);
  }

  @override
  Future<PostReaction?> isPostReactedToByUser(
      String postAuthorId, int postId, String userId) async {
    return await _postsApi.isPostReactedToByUser(postAuthorId, postId, userId);
  }

  @override
  Future<List<Post>> getFollowingPosts<T>(
      String userId, T start, int limit) async {
    return await _postsApi.getFollowingPosts(userId, start as ApiCallStart);
  }
}
