import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';
import 'package:universe/models/data/post.dart';
import 'package:universe/models/data/post_reaction.dart';

part 'posts_api.g.dart';

@RestApi()
abstract class PostsApi {
  factory PostsApi(Dio dio) = _PostsApi;

  @POST('/{userId}/Posts')
  Future addPost(
    @Path() String userId,
    @Body() Post post,
  );

  @POST('/{userId}/Posts/{postId}/Reactions')
  Future<int> addReaction(
    @Path() String userId,
    @Path() int postId,
    @Body() PostReaction reaction,
  );

  @POST('/{userId}/Posts/{postId}/Replies')
  Future addReply(
    @Path() String userId,
    @Path() int postId,
    @Body() Post reply,
  );

  @DELETE('/{userId}/Posts/{postId}')
  Future deletePost(
    @Path() String userId,
    @Path() int postId,
  );

  @DELETE('/{userId}/Posts/{postId}/Replies/{replyId}')
  Future deleteReply(
    @Path() String userId,
    @Path() int postId,
    @Path() int replyId,
  );

  @GET('/{userId}/Posts/{postId}/Reactions/{reactionAuthorId}')
  Future<PostReaction?> isPostReactedToByUser(
    @Path() String userId,
    @Path() int postId,
    @Path() String reactionAuthorId,
  );

  @GET('/{userId}/Posts/{postId}/Reactions/Count')
  Future<int> getPostReactionsCount(
    @Path() String userId,
    @Path() int postId,
  );

  @GET('/{userId}/Posts/{postId}/Reactions')
  Future<List<PostReaction>> getPostReactions(
    @Path() String userId,
    @Path() int postId,
    @Query('lastDate') DateTime? lastDate,
    @Query('lastId') String? lastId,
  );

  @GET('/{userId}/Posts/{postId}/Replies')
  Future<List<Post>> getPostReplies(
    @Path() String userId,
    @Path() int postId,
    @Query('lastDate') DateTime? lastDate,
    @Query('lastId') String? lastId,
  );

  @GET('/{userId}/Posts')
  Future<List<Post>> getUserPosts(
    @Path() String userId,
    @Query('lastDate') DateTime? lastDate,
    @Query('lastId') String? lastId,
  );

  @GET('/{userId}/Posts/Count')
  Future<int> getUserPostsCount(
    @Path() String userId,
  );

  @GET('/{userId}/Posts/Following')
  Future<List<Post>> getFollowingPosts(
    @Path() String userId,
    @Query('lastDate') DateTime? lastDate,
    @Query('lastId') String? lastId,
  );

  @DELETE('/{userId}/Posts/{postId}/Reactions/{reactionId}')
  Future removeReaction(
    @Path() String userId,
    @Path() int postId,
    @Path() int reactionId,
  );

  @GET('/{userId}/Posts/Share/{sharedPostId}')
  Future sharePost(
    @Path() String userId,
    @Path() int sharedPostId,
    @Body() Post post,
  );

  @PUT('/{userId}/Posts/{postId}')
  Future updatePost(
    @Path() String userId,
    @Body() Post post,
  );
}
