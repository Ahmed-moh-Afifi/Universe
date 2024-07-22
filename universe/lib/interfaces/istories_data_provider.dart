import 'package:universe/models/story.dart';
import 'package:universe/models/story_reaction.dart';
import 'package:universe/models/user.dart';

abstract class IStoriesDataProvider {
  Future<List<Story>> getActiveStories(String userId);
  Future<List<Story>> getAllStories(String userId, int start, int limit);
  Future<List<User>> getFollowingWithActiveStories(String userId);
  Future<List<Story>> getFollowingStories(String userId, int start, int limit);
  Future<Story> getStory(String userId, int storyId);
  Future updateStory(String userId, Story story);
  Future deleteStory(String userId, int storyId);
  Future createStory(String userId, Story story);
  Future addStoryReaction(User user, Story story, StoryReaction reaction);
}
