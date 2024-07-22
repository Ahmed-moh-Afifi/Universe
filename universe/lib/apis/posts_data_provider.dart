import 'package:universe/apis/api_client.dart';
import 'package:universe/interfaces/iposts_data_provider.dart';
import 'package:universe/models/api_call_start.dart';
import 'package:universe/models/following_posts_response.dart';
import 'package:universe/models/post.dart';
import 'package:universe/models/reaction.dart';
import 'package:universe/models/reactions_response.dart';
import 'package:universe/models/replies_response.dart';
import 'package:universe/models/user.dart';
import 'package:universe/models/user_posts_response.dart';

class PostsDataProvider implements IPostsDataProvider {
  late ApiClient _apiClient;

  PostsDataProvider.privateConstructor();

  static final PostsDataProvider _instance =
      PostsDataProvider.privateConstructor();

  factory PostsDataProvider(String userId) {
    _instance._apiClient = ApiClient('$userId/Posts');
    return _instance;
  }

  @override
  Future addPost(User author, Post post) async {
    await _apiClient.post('/', post, {});
  }

  @override
  Future addReaction(User user, Post post, Reaction reaction) async {
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
  Future<Reaction?> isPostReactedToByUser(Post post, User user) {
    // TODO: implement isPostReactedToByUser
    throw UnimplementedError();
  }

  @override
  Future<int> getPostReactionsCount(Post post) async {
    return (await _apiClient.get<int>('/${post.id}/Reactions/Count', null, {}))
        .data!;
  }

  @override
  Future<ReactionsResponse> getPostReactions<T, G>(
      Post post, T start, G limit) async {
    var reactions = await _apiClient.get<List<Reaction>>(
      '/${post.id}/Reactions',
      (start as ApiCallStart).lastDate,
      {
        'lastId': (start as ApiCallStart).lastId,
      },
    );

    return ReactionsResponse(
        reactions: reactions.data!,
        nextPage: () async {
          return await getPostReactions<ApiCallStart, int>(
              post,
              ApiCallStart(
                  lastDate: reactions.data!.last.reactionDate,
                  lastId: reactions.data!.last.reactionId),
              limit as int);
        });
  }

  @override
  Future<RepliesResponse> getPostReplies<T, G>(
      Post post, T start, G limit) async {
    var replies = await _apiClient.get<List<Post>>(
      '/${post.id}/Replies',
      (start as ApiCallStart).lastDate,
      {
        'lastId': (start as ApiCallStart).lastId,
      },
    );

    return RepliesResponse(
        replies: replies.data!,
        nextPage: () async {
          return await getPostReplies<ApiCallStart, int>(
              post,
              ApiCallStart(
                  lastDate: replies.data!.last.publishDate,
                  lastId: replies.data!.last.id),
              limit as int);
        });
  }

  @override
  Future<UserPostsResponse> getUserPosts<T, G>(
      User user, T start, G limit) async {
    var posts = await _apiClient.get<List<Post>>(
      '/',
      (start as ApiCallStart).lastDate,
      {
        'lastId': (start as ApiCallStart).lastId,
      },
    );

    return UserPostsResponse(
      posts: posts.data!,
      nextPage: () async {
        return await getUserPosts<ApiCallStart, int>(
            user,
            ApiCallStart(
                lastDate: posts.data!.last.publishDate,
                lastId: posts.data!.last.id),
            limit as int);
      },
    );
  }

  @override
  Future<int> getUserPostsCount(User user) async {
    return (await _apiClient.get<int>('/Count', null, {})).data!;
  }

  @override
  Future<FollowingPostsResponse> getFollowingPosts<T, G>(
      User user, T start, G limit) async {
    var posts = await _apiClient.get<List<Post>>(
      '/Following',
      (start as ApiCallStart).lastDate,
      {
        'lastId': (start as ApiCallStart).lastId,
      },
    );

    return FollowingPostsResponse(
      posts: posts.data!,
      nextPage: () async {
        return await getFollowingPosts<ApiCallStart, int>(
            user,
            ApiCallStart(
                lastDate: posts.data!.last.publishDate,
                lastId: posts.data!.last.id),
            limit as int);
      },
    );
  }

  @override
  Future removeReaction(Post post, Reaction reaction) async {
    await _apiClient
        .delete('/${post.id}/Reactions/${reaction.reactionId}', null, {});
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
