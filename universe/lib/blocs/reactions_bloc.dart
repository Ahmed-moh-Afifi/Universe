import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:universe/models/data/post.dart';
import 'package:universe/models/data/post_reaction.dart';

enum ReactionsStates {
  loading,
  loaded,
  failed,
}

class ReactionsState {
  final ReactionsStates state;
  final ReactionsStates previousState;
  final List<PostReaction>? reactions;
  final String? error;

  const ReactionsState(
      this.state, this.previousState, this.reactions, this.error);
}

class GetReactions {}

class ReactionsBloc extends Bloc<Object, ReactionsState> {
  final IPostsDataProvider postsDataProvider;
  final Post post;
  ReactionsBloc(this.postsDataProvider, this.post)
      : super(const ReactionsState(
            ReactionsStates.loading, ReactionsStates.loading, null, null)) {
    on<GetReactions>(
      (event, emit) async {
        emit(
          const ReactionsState(
            ReactionsStates.loading,
            ReactionsStates.loading,
            null,
            null,
          ),
        );
        var reactions =
            await postsDataProvider.getPostReactions(post, null, 25);
        emit(
          ReactionsState(
            ReactionsStates.loaded,
            ReactionsStates.loading,
            reactions,
            null,
          ),
        );
      },
    );

    add(GetReactions());
  }
}
