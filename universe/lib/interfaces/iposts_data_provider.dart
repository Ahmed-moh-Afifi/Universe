import 'package:universe/models/api_data_response.dart';
import 'package:universe/models/post.dart';
import 'package:universe/models/post_reaction.dart';
import 'package:universe/models/user.dart';

abstract class IPostsDataProvider {
  Future<ApiDataResponse<List<Post>>> getUserPosts<T, G>(
      User user, T start, G limit);

  Future addPost(User author, Post post);

  Future<ApiDataResponse<List<Post>>> getPostReplies<T, G>(
      Post post, T start, G limit);

  Future addReply(User user, Post post, Post reply);

  Future updatePost(Post post);

  Future deletePost(Post post);

  Future deleteReply(Post post, Post reply);

  Future sharePost(User user, Post post);

  Future<int> getUserPostsCount(User user);

  Future<ApiDataResponse<List<PostReaction>>> getPostReactions<T, G>(
      Post post, T start, G limit);

  Future addReaction(User user, Post post, PostReaction reaction);

  Future<int> getPostReactionsCount(Post post);

  Future removeReaction(Post post, PostReaction reaction);

  Stream<int> getPostReactionsCountStream(Post post);

  Future<PostReaction?> isPostReactedToByUser(Post post, User user);

  Future<ApiDataResponse<List<Post>>> getFollowingPosts<T, G>(
      User user, T start, G limit);
}
