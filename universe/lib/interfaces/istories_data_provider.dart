import 'package:universe/models/responses/api_data_response.dart';
import 'package:universe/models/data/story.dart';
import 'package:universe/models/data/story_reaction.dart';
import 'package:universe/models/data/user.dart';

abstract class IStoriesDataProvider {
  Future<ApiDataResponse<List<Story>>> getActiveStories<T, G>(
      User user, T start, G limit);

  Future<ApiDataResponse<List<Story>>> getAllStories<T, G>(
      User user, T start, G limit);

  Future<ApiDataResponse<List<User>>> getFollowingWithActiveStories<T, G>(
      User user, T start, G limit);

  Future<ApiDataResponse<List<Story>>> getFollowingStories<T, G>(
      User user, T start, G limit);

  Future<Story> getStory(User author, int storyId);

  Future updateStory(User author, Story story);

  Future deleteStory(User author, int storyId);

  Future createStory(User author, Story story);

  Future getReactions<T, G>(User author, Story story, T start, G limit);

  Future addReaction(User storyAuthor, Story story, StoryReaction reaction);

  Future removeReaction(User user, Story story, StoryReaction reaction);

  Future<StoryReaction?> isStoryReactedToByUser(
      User author, Story story, User user);

  Future<int> getStoryReactionsCount(User author, Story story);
}
