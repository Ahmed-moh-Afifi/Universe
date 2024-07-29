import 'dart:developer';

import 'package:universe/apis/api_client.dart';
import 'package:universe/interfaces/iposts_data_provider.dart';
import 'package:universe/models/api_call_start.dart';
import 'package:universe/models/api_data_response.dart';
import 'package:universe/models/post.dart';
import 'package:universe/models/post_reaction.dart';
import 'package:universe/models/user.dart';

class PostsDataProvider implements IPostsDataProvider {
  late ApiClient _apiClient;

  PostsDataProvider._privateConstructor();

  static final PostsDataProvider _instance =
      PostsDataProvider._privateConstructor();

  factory PostsDataProvider(String userId) {
    _instance._apiClient = ApiClient('$userId/Posts');
    return _instance;
  }

  @override
  Future addPost(User author, Post post) async {
    await _apiClient.post('/', post, {});
  }

  @override
  Future addReaction(User user, Post post, PostReaction reaction) async {
    await _apiClient.post('/${post.id}/Reactions', reaction, {});
  }

  @override
  Future addReply(User user, Post post, Post reply) async {
    await _apiClient.post('/${post.id}/Replies', reply, {});
  }

  @override
  Future deletePost(Post post) async {
    await _apiClient.delete('/${post.id}', null, {});
  }

  @override
  Future deleteReply(Post post, Post reply) async {
    await _apiClient.delete('/${post.id}/Replies/${reply.id}', null, {});
  }

  @override
  Future<PostReaction?> isPostReactedToByUser(Post post, User user) async {
    return (await _apiClient
            .get<PostReaction>('/${post.id}/Reactions/${user.uid}', null, {}))
        .data;
  }

  @override
  Future<int> getPostReactionsCount(Post post) async {
    return (await _apiClient.get<int>('/${post.id}/Reactions/Count', null, {}))
        .data!;
  }

  @override
  Future<ApiDataResponse<List<PostReaction>>> getPostReactions<T, G>(
      Post post, T start, G limit) async {
    var reactions = await _apiClient.get<List<PostReaction>>(
      '/${post.id}/Reactions',
      (start as ApiCallStart).lastDate,
      {
        'lastId': (start as ApiCallStart).lastId,
      },
    );

    return ApiDataResponse<List<PostReaction>>(
      data: reactions.data!,
      nextPage: () => getPostReactions<ApiCallStart, int>(
        post,
        ApiCallStart(
            lastDate: reactions.data!.last.reactionDate,
            lastId: reactions.data!.last.id),
        limit as int,
      ),
    );
  }

  @override
  Future<ApiDataResponse<List<Post>>> getPostReplies<T, G>(
      Post post, T start, G limit) async {
    var replies = await _apiClient.get<List<Post>>(
      '/${post.id}/Replies',
      (start as ApiCallStart).lastDate,
      {
        'lastId': (start as ApiCallStart).lastId,
      },
    );

    return ApiDataResponse<List<Post>>(
      data: replies.data!,
      nextPage: () => getPostReplies<ApiCallStart, int>(
        post,
        ApiCallStart(
            lastDate: replies.data!.last.publishDate,
            lastId: replies.data!.last.id),
        limit as int,
      ),
    );
  }

  @override
  Future<ApiDataResponse<List<Post>>> getUserPosts<T, G>(
      User user, T start, G limit) async {
    var response = await _apiClient.get(
      '/',
      (start as ApiCallStart?)?.lastDate,
      {
        'lastId': (start as ApiCallStart?)?.lastId,
      },
    );

    List<Post> posts =
        (response.data! as List<dynamic>).map((e) => Post.fromJson(e)).toList();

    log(response.data.toString(), name: 'PostsDataProvider');

    return ApiDataResponse<List<Post>>(
      data: posts,
      nextPage: () => getUserPosts<ApiCallStart, int>(
        user,
        ApiCallStart(lastDate: posts.last.publishDate, lastId: posts.last.id),
        limit as int,
      ),
    );
  }

  @override
  Future<int> getUserPostsCount(User user) async {
    return (await _apiClient.get<int>('/Count', null, {})).data!;
  }

  @override
  Future<ApiDataResponse<List<Post>>> getFollowingPosts<T, G>(
      User user, T start, G limit) async {
    var posts = await _apiClient.get<List<Post>>(
      '/Following',
      (start as ApiCallStart).lastDate,
      {
        'lastId': (start as ApiCallStart).lastId,
      },
    );

    return ApiDataResponse<List<Post>>(
      data: posts.data!,
      nextPage: () => getFollowingPosts<ApiCallStart, int>(
        user,
        ApiCallStart(
            lastDate: posts.data!.last.publishDate,
            lastId: posts.data!.last.id),
        limit as int,
      ),
    );
  }

  @override
  Future removeReaction(Post post, PostReaction reaction) async {
    await _apiClient.delete('/${post.id}/Reactions/${reaction.id}', null, {});
  }

  @override
  Future sharePost(User user, Post post) async {
    await _apiClient.post('/${post.id}/Shares', null, {});
  }

  @override
  Future updatePost(Post post) async {
    await _apiClient.put('/${post.id}', post, {});
  }

  @override
  Stream<int> getPostReactionsCountStream(Post post) {
    // TODO: implement getPostReactionsCountStream
    throw UnimplementedError();
  }
}
