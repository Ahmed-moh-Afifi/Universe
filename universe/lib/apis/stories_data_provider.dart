import 'package:universe/apis/api_client.dart';
import 'package:universe/interfaces/istories_data_provider.dart';
import 'package:universe/models/api_call_start.dart';
import 'package:universe/models/api_data_response.dart';
import 'package:universe/models/story.dart';
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
    await _apiClient.put('/${story.id}');
  }
}
