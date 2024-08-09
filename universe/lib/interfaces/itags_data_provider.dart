import 'dart:async';

import 'package:universe/models/responses/api_data_response.dart';
import 'package:universe/models/data/post.dart';
import 'package:universe/models/data/story.dart';
import 'package:universe/models/data/tag.dart';

abstract class ITagsDataProvider {
  Future<ApiDataResponse<List<Tag>>> searchTags<T, G>(
      String query, T start, G limit);

  Future<ApiDataResponse<List<Post>>> getTagPosts<T, G>(
      Tag tag, T start, G limit);

  Future<int> getTagPostsCount(Tag tag);

  Future<ApiDataResponse<List<Story>>> getTagStories<T, G>(
      Tag tag, T start, G limit);

  Future followTag(Tag tag);

  Future unfollowTag(Tag tag);

  Future<bool> isTagFollowed(Tag tag);

  Future createTag(Tag tag);
}
