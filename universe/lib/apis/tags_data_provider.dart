import 'package:universe/apis/api_client.dart';
import 'package:universe/interfaces/itags_data_provider.dart';
import 'package:universe/models/responses/api_data_response.dart';
import 'package:universe/models/data/post.dart';
import 'package:universe/models/data/story.dart';
import 'package:universe/models/data/tag.dart';

class TagsDataProvider implements ITagsDataProvider {
  late ApiClient _apiClient;

  TagsDataProvider._privateConstructor();

  static final TagsDataProvider _instance =
      TagsDataProvider._privateConstructor();

  factory TagsDataProvider(String userId) {
    _instance._apiClient = ApiClient('$userId/Tags');
    return _instance;
  }

  @override
  Future createTag(Tag tag) async {
    await _apiClient.post('/', tag, {});
  }

  @override
  Future followTag(Tag tag) async {
    //TODO: Implement followTag method
    throw UnimplementedError();
    // await _apiClient.post('/${tag.id}/Follow', null, {});
  }

  @override
  Future<ApiDataResponse<List<Post>>> getTagPosts<T, G>(
      Tag tag, T start, G limit) async {
    var response = await _apiClient.get<List<Post>>(
      '/${tag.id}/Posts',
      (start as int),
      {
        'limit': limit,
      },
    );

    return ApiDataResponse<List<Post>>(
      data: response.data!,
      nextPage: () => getTagPosts(
        tag,
        response.data!.last.id,
        limit,
      ),
    );
  }

  @override
  Future<ApiDataResponse<List<Story>>> getTagStories<T, G>(
      Tag tag, T start, G limit) async {
    var response = await _apiClient.get<List<Story>>(
      '/${tag.id}/Stories',
      (start as int),
      {
        'limit': limit,
      },
    );

    return ApiDataResponse<List<Story>>(
      data: response.data!,
      nextPage: () => getTagStories(
        tag,
        response.data!.last.id,
        limit,
      ),
    );
  }

  @override
  Future<int> getTagPostsCount(Tag tag) async {
    //TODO: Implement getTagPostsCount method
    throw UnimplementedError();
    // var response =
    //     await _apiClient.get<int>('/${tag.id}/Posts/Count', null, {});
    // return response.data!;
  }

  @override
  Future<ApiDataResponse<List<Tag>>> searchTags<T, G>(
      String query, T start, G limit) async {
    var response = await _apiClient.get<List<Tag>>(
      '/Search',
      (start as int),
      {
        'query': query,
        'limit': limit,
      },
    );

    return ApiDataResponse<List<Tag>>(
      data: response.data!,
      nextPage: () => searchTags(
        query,
        response.data!.last.id,
        limit,
      ),
    );
  }

  @override
  Future unfollowTag(Tag tag) async {
    //TODO: Implement unfollowTag method
    throw UnimplementedError();
    // await _apiClient.delete('/${tag.id}/Follow', null, {});
  }

  @override
  Future<bool> isTagFollowed(Tag tag) async {
    //TODO: Implement isTagFollowed method
    throw UnimplementedError();
    // var response = await _apiClient.get<bool>('/${tag.id}/IsFollowed', null, {});
    // return response.data!;
  }
}
