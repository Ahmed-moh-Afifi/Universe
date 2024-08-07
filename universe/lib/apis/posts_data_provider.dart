import 'dart:convert';
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
    log('Adding post: ${jsonEncode(post.toJson())}', name: 'PostsDataProvider');
    ApiClient apiClient = ApiClient('/${author.uid}/Posts');
    // response = await _apiClient.post('/', post.toJson(), {});
    await apiClient.post('/', post.toJson(), {});
  }

  @override
  Future addReaction(User user, Post post, PostReaction reaction) async {
    log('Adding reaction: ${reaction.toJson()} to post: ${post.toJson()}',
        name: 'PostsDataProvider');
    await _apiClient.post('/${post.id}/Reactions', reaction.toJson(), {});
  }

  @override
  Future addReply(User user, Post post, Post reply) async {
    log('Adding reply: ${reply.toJson()}', name: 'PostsDataProvider');
    await _apiClient.post('/${post.id}/Replies', reply.toJson(), {});
  }

  @override
  Future deletePost(Post post) async {
    log('Deleting post: ${post.toJson()}', name: 'PostsDataProvider');
    await _apiClient.delete('/${post.id}', null, {});
  }

  @override
  Future deleteReply(Post post, Post reply) async {
    log('Deleting reply: ${reply.toJson()}', name: 'PostsDataProvider');
    await _apiClient.delete('/${post.id}/Replies/${reply.id}', null, {});
  }

  @override
  Future<PostReaction?> isPostReactedToByUser(Post post, User user) async {
    log('Checking if post: ${post.toJson()} is reacted to by user: ${user.toJson()}',
        name: 'PostsDataProvider');
    return (await _apiClient
            .get<PostReaction>('/${post.id}/Reactions/${user.uid}', null, {}))
        .data;
  }

  @override
  Future<int> getPostReactionsCount(Post post) async {
    log('Getting post reactions count: ${post.toJson()}',
        name: 'PostsDataProvider');
    return (await _apiClient.get<int>('/${post.id}/Reactions/Count', null, {}))
        .data!;
  }

  @override
  Future<ApiDataResponse<List<PostReaction>>> getPostReactions<T, G>(
      Post post, T start, G limit) async {
    log('Getting post reactions: ${post.toJson()}', name: 'PostsDataProvider');
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
    log('Getting post replies: ${post.toJson()}', name: 'PostsDataProvider');
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
    log('Getting user posts: ${user.toJson()}', name: 'PostsDataProvider');
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
    log('Getting user posts count of user: ${user.toJson()}',
        name: 'PostsDataProvider');
    return (await _apiClient.get<int>('/Count', null, {})).data!;
  }

  @override
  Future<ApiDataResponse<List<Post>>> getFollowingPosts<T, G>(
      User user, T start, G limit) async {
    log('Getting following posts of user: ${user.toJson()}',
        name: 'PostsDataProvider');
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
    log('Removing reaction: ${reaction.toJson()} from post: ${post.toJson()}',
        name: 'PostsDataProvider');
    await _apiClient.delete('/${post.id}/Reactions/${reaction.id}', null, {});
  }

  @override
  Future sharePost(User user, Post post) async {
    log('Sharing post: ${post.toJson()}', name: 'PostsDataProvider');

    var newPost = Post(
      title: 'title',
      body: 'body',
      images: [],
      videos: [],
      audios: [],
      publishDate: DateTime.now(),
      replyToPost: null,
      childPostId: post.id,
      widgets: [],
    );

    addPost(user, newPost);
  }

  @override
  Future updatePost(Post post) async {
    log('Updating post: ${post.toJson()}', name: 'PostsDataProvider');
    await _apiClient.put('/${post.id}', post.toJson(), {});
  }

  @override
  Stream<int> getPostReactionsCountStream(Post post) {
    log('Getting post reactions count stream: ${post.toJson()}',
        name: 'PostsDataProvider');
    // TODO: implement getPostReactionsCountStream
    throw UnimplementedError();
  }
}
