import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:universe/models/user.dart';
import 'package:universe/repositories/data_repository.dart';

enum SearchStates {
  notStarted,
  loading,
  loaded,
  failed,
}

class SearchEvent {
  final String query;

  const SearchEvent(this.query);
}

class SearchState {
  final SearchStates previousState;
  final SearchStates state;
  final Iterable<User>? data;
  final String? error;

  const SearchState(
      {required this.previousState,
      required this.state,
      this.data,
      this.error});
}

class SearchBloc extends Bloc<Object, SearchState> {
  SearchBloc(super.initialState) {
    on<SearchEvent>(
      (event, emit) async {
        if (event.query != '') {
          emit(
            SearchState(
                state: SearchStates.loading, previousState: state.state),
          );
          try {
            final results =
                await DataRepository().searchUsers(event.query, null, 25);
            emit(
              SearchState(
                  state: SearchStates.loaded,
                  previousState: state.state,
                  data: results.users),
            );
          } catch (e) {
            emit(
              SearchState(
                  state: SearchStates.failed,
                  previousState: state.state,
                  error: 'something\'s gone wrong :('),
            );
          }
        } else {
          emit(
            SearchState(
                previousState: state.state,
                state: SearchStates.failed,
                error: 'invalid or no input'),
          );
        }
      },
    );
  }
}
