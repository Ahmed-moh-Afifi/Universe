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
  final SearchStates state;
  final Iterable<User>? data;
  final String? error;

  const SearchState({required this.state, this.data, this.error});
}

class SearchBloc extends Bloc<Object, SearchState> {
  SearchBloc() : super(const SearchState(state: SearchStates.notStarted)) {
    on<SearchEvent>(
      (event, emit) async {
        if (event.query != '') {
          emit(const SearchState(state: SearchStates.loading));
          try {
            final results =
                await DataRepository().searchUsers(event.query, null, 25);
            emit(SearchState(state: SearchStates.loaded, data: results.users));
          } catch (e) {
            emit(const SearchState(
                state: SearchStates.failed,
                error: 'something\'s gone wrong :('));
          }
        } else {
          emit(const SearchState(
              state: SearchStates.failed, error: 'invalid or no input'));
        }
      },
    );
  }
}
