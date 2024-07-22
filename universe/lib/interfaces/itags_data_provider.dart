import 'dart:async';

import 'package:universe/models/post.dart';
import 'package:universe/models/tag.dart';

abstract class ITagsDataProvider {
  Future<List<Tag>> searchTags<T, G>(String query, T start, G limit);

  Future<Post> getTagPosts<T, G>(Tag tag, T start, G limit);

  Future<int> getTagPostsCount(Tag tag);

  Future getTagStories<T, G>(Tag tag, T start, G limit);

  Future followTag(Tag tag);

  Future unfollowTag(Tag tag);

  Future<bool> isTagFollowed(Tag tag);

  Future createTag(Tag tag);
}
