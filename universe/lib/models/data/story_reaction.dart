class StoryReaction {
  int id;
  String userId;
  String reactionType;
  DateTime reactionDate;
  int storyId;

  StoryReaction({
    required this.id,
    required this.userId,
    required this.reactionType,
    required this.reactionDate,
    required this.storyId,
  });
}
