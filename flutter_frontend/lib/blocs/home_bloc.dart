import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:universe/models/post.dart';
import 'package:universe/repositories/authentication_repository.dart';

enum HomeStates {
  loading,
  loaded,
  error,
}

class HomeState {
  HomeStates state;
  final user = AuthenticationRepository().authenticationService.getUser()!;
  final Iterable<Post>? data;
  final String? error;

  HomeState(this.state, [this.data, this.error]);
}

class DataLoaded {
  final Iterable<Post> data;

  DataLoaded(this.data);
}

class DataUpdated {
  final Iterable<Post> data;

  DataUpdated(this.data);
}

class HomeBloc extends Bloc<Object, HomeState> {
  HomeBloc() : super(HomeState(HomeStates.loading, null)) {
    on<DataLoaded>(
        (event, emit) => emit(HomeState(HomeStates.loaded, event.data)));
    on<DataUpdated>(
        (event, emit) => emit(HomeState(HomeStates.loaded, event.data)));
  }
}
