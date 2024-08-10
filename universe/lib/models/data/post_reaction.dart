import 'package:json_annotation/json_annotation.dart';
import 'package:universe/models/data/user.dart';

part 'post_reaction.g.dart';

@JsonSerializable()
class PostReaction {
  User? user;
  final int? id;
  final String? userId;
  final String reactionType;
  final DateTime reactionDate;
  final int postId;

  PostReaction({
    required this.userId,
    required this.reactionType,
    required this.reactionDate,
    required this.postId,
    this.id,
  });

  factory PostReaction.fromJson(Map<String, dynamic> data) =>
      _$PostReactionFromJson(data);

  Map<String, dynamic> toJson() => _$PostReactionToJson(this);
}
