import 'package:universe/apis/api_client.dart';
import 'package:universe/interfaces/istories_data_provider.dart';
import 'package:universe/models/api_call_start.dart';
import 'package:universe/models/api_data_response.dart';
import 'package:universe/models/story.dart';
import 'package:universe/models/story_reaction.dart';
import 'package:universe/models/user.dart';

class StoriesDataProvider implements IStoriesDataProvider {
  late ApiClient _apiClient;

  StoriesDataProvider._privateConstructor();

  static final StoriesDataProvider _instance =
      StoriesDataProvider._privateConstructor();

  factory StoriesDataProvider(String userId) {
    _instance._apiClient = ApiClient('$userId/Stories');
    return _instance;
  }

  @override
  Future<ApiDataResponse<List<Story>>> getActiveStories<T, G>(
      User user, T start, G limit) async {
    var response = await _apiClient.get<List<Story>>(
      '/Active',
      (start as ApiCallStart).lastDate,
      {
        'lastId': (start as ApiCallStart).lastId,
      },
    );

    return ApiDataResponse<List<Story>>(
      data: response.data!,
      nextPage: () => getActiveStories(
        user,
        ApiCallStart(
          lastId: response.data!.last.id.toString(),
          lastDate: response.data!.last.publishDate,
        ),
        limit,
      ),
    );
  }

  @override
  Future<ApiDataResponse<List<Story>>> getAllStories<T, G>(
      User user, T start, G limit) async {
    var response = await _apiClient.get<List<Story>>(
      '/',
      (start as ApiCallStart).lastDate,
      {
        'lastId': (start as ApiCallStart).lastId,
      },
    );

    return ApiDataResponse<List<Story>>(
      data: response.data!,
      nextPage: () => getAllStories(
        user,
        ApiCallStart(
          lastId: response.data!.last.id.toString(),
          lastDate: response.data!.last.publishDate,
        ),
        limit,
      ),
    );
  }

  @override
  Future<ApiDataResponse<List<User>>> getFollowingWithActiveStories<T, G>(
      User user, T start, G limit) async {
    var response = await _apiClient.get<List<User>>(
      '/Following/Active',
      (start as ApiCallStart).lastDate,
      {
        'lastId': (start as ApiCallStart).lastId,
      },
    );

    return ApiDataResponse<List<User>>(
      data: response.data!,
      nextPage: () => getFollowingWithActiveStories(
        user,
        ApiCallStart(
          lastId: response.data!.last.uid,
          lastDate: response.data!.last.joinDate,
        ),
        limit,
      ),
    );
  }

  @override
  Future<ApiDataResponse<List<Story>>> getFollowingStories<T, G>(
      User user, T start, G limit) async {
    var response = await _apiClient.get<List<Story>>(
      '/Following',
      (start as ApiCallStart).lastDate,
      {
        'lastId': (start as ApiCallStart).lastId,
      },
    );

    return ApiDataResponse<List<Story>>(
      data: response.data!,
      nextPage: () => getFollowingStories(
        user,
        ApiCallStart(
          lastId: response.data!.last.id.toString(),
          lastDate: response.data!.last.publishDate,
        ),
        limit,
      ),
    );
  }

  @override
  Future<Story> getStory(User author, int storyId) async {
    var response = await _apiClient.get<Story>('/$storyId', null, {});
    return response.data!;
  }

  @override
  Future updateStory(User author, Story story) async {
    await _apiClient.put('/${story.id}', story, {});
  }

  @override
  Future deleteStory(User author, int storyId) async {
    await _apiClient.delete('/$storyId', null, {});
  }

  @override
  Future createStory(User author, Story story) async {
    await _apiClient.post('/', story, {});
  }

  @override
  Future<ApiDataResponse<List<StoryReaction>>> getReactions<T, G>(
      User author, Story story, T start, G limit) async {
    var response = await _apiClient.get<List<StoryReaction>>(
      '/${story.id}/Reactions',
      (start as ApiCallStart).lastDate,
      {
        'lastId': (start as ApiCallStart).lastId,
      },
    );

    return ApiDataResponse<List<StoryReaction>>(
      data: response.data!,
      nextPage: () => getReactions(
        author,
        story,
        ApiCallStart(
          lastId: response.data!.last.id.toString(),
          lastDate: response.data!.last.reactionDate,
        ),
        limit,
      ),
    );
  }

  @override
  Future addReaction(
      User storyAuthor, Story story, StoryReaction reaction) async {
    await _apiClient.post('/${story.id}/Reactions', reaction, {});
  }

  @override
  Future removeReaction(User user, Story story, StoryReaction reaction) async {
    await _apiClient.delete('/${story.id}/Reactions/${reaction.id}', null, {});
  }

  @override
  Future<StoryReaction?> isStoryReactedToByUser(
      User author, Story story, User user) async {
    //TODO: Implement isStoryReactedToByUser method
    throw UnimplementedError();
    // var response = await _apiClient.get<StoryReaction>(
    //   '/${story.id}/Reactions/${user.uid}',
    //   null,
    //   {},
    // );

    // return response.data;
  }

  @override
  Future<int> getStoryReactionsCount(User author, Story story) async {
    var response = await _apiClient.get<int>(
      '/${story.id}/Reactions/Count',
      null,
      {},
    );

    return response.data!;
  }
}
