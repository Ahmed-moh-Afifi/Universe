import 'package:json_annotation/json_annotation.dart';

part 'post_reaction.g.dart';

@JsonSerializable()
class PostReaction {
  final int id;
  final String userId;
  final String reactionType;
  final DateTime reactionDate;
  final int postId;

  PostReaction({
    this.id = -1,
    required this.userId,
    required this.reactionType,
    required this.reactionDate,
    required this.postId,
  });

  factory PostReaction.fromJson(Map<String, dynamic> data) =>
      _$PostReactionFromJson(data);

  Map<String, dynamic> toJson() => _$PostReactionToJson(this);
}
