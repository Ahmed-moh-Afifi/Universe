import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:universe/interfaces/iusers_data_provider.dart';
import 'package:universe/models/user.dart';

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
  final IusersDataProvider usersDataProvider;
  SearchBloc(this.usersDataProvider, super.initialState) {
    on<SearchEvent>(
      (event, emit) async {
        if (event.query != '') {
          emit(
            SearchState(
                state: SearchStates.loading, previousState: state.state),
          );
          try {
            final results =
                await usersDataProvider.searchUsers(event.query, null, 25);
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
