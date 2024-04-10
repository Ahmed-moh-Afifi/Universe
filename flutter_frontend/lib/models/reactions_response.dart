import 'package:universe/models/reaction.dart';

class ReactionsResponse {
  final Iterable<Reaction> reactions;
  final Future<ReactionsResponse> Function() nextPage;

  ReactionsResponse({required this.reactions, required this.nextPage});
}
