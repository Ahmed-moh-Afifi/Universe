import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:universe/interfaces/iposts_repository.dart';
import 'package:universe/models/data/post.dart';
import 'package:universe/models/data/post_full_reaction.dart';
import 'package:universe/models/requests/api_call_start.dart';

enum ReactionsStates {
  loading,
  loaded,
  failed,
}

class ReactionsState {
  final ReactionsStates state;
  final ReactionsStates previousState;
  final List<PostFullReaction>? reactions;
  final String? error;

  const ReactionsState(
      this.state, this.previousState, this.reactions, this.error);
}

class GetReactions {}

class ReactionsBloc extends Bloc<Object, ReactionsState> {
  final IPostsRepository postsRepository;
  final Post post;
  ReactionsBloc(this.postsRepository, this.post)
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
        var reactions = await postsRepository.getPostReactions(
          post.author.id,
          post.id,
          ApiCallStart(),
          25,
        );
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
