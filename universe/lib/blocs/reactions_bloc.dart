import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:universe/models/post.dart';
import 'package:universe/models/reaction.dart';
import 'package:universe/repositories/data_repository.dart';

enum ReactionsStates {
  loading,
  loaded,
  failed,
}

class ReactionsState {
  final ReactionsStates state;
  final ReactionsStates previousState;
  final List<Reaction>? reactions;
  final String? error;

  const ReactionsState(
      this.state, this.previousState, this.reactions, this.error);
}

class GetReactions {}

class ReactionsBloc extends Bloc<Object, ReactionsState> {
  final Post post;
  ReactionsBloc(this.post)
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
        var reactionsResponse = await DataRepository()
            .dataProvider
            .getPostReactions(post, null, 25);
        emit(
          ReactionsState(
            ReactionsStates.loaded,
            ReactionsStates.loading,
            reactionsResponse.reactions.toList(),
            null,
          ),
        );
      },
    );

    add(GetReactions());
  }
}
