import 'package:json_annotation/json_annotation.dart';

part 'story_reaction.g.dart';

@JsonSerializable()
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

  factory StoryReaction.fromJson(Map<String, dynamic> data) =>
      _$StoryReactionFromJson(data);

  Map<String, dynamic> toJson() => _$StoryReactionToJson(this);
}
