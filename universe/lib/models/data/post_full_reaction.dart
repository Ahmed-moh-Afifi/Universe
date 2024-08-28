import 'package:json_annotation/json_annotation.dart';
import 'package:universe/models/data/post_reaction.dart';
import 'package:universe/models/data/user.dart';

part 'post_full_reaction.g.dart';

@JsonSerializable()
class PostFullReaction extends PostReaction {
  final User user;

  PostFullReaction({
    required super.id,
    required super.userId,
    required super.reactionType,
    required super.reactionDate,
    required super.postId,
    required this.user,
  });

  factory PostFullReaction.fromJson(Map<String, dynamic> data) =>
      _$PostFullReactionFromJson(data);

  @override
  Map<String, dynamic> toJson() => _$PostFullReactionToJson(this);
}
