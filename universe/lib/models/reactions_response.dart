import 'package:universe/models/post_reaction.dart';

class ReactionsResponse {
  final Iterable<PostReaction> reactions;
  final Future<ReactionsResponse> Function() nextPage;

  ReactionsResponse({required this.reactions, required this.nextPage});
}
