import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:universe/models/data/user.dart';
import 'package:universe/models/requests/users_api_call_start.dart';
import 'package:universe/repositories/users_repository.dart';

enum FollowersStates {
  notStarted,
  loading,
  success,
  failed,
}

class FollowersState {
  final FollowersStates previousState;
  final FollowersStates state;
  final List<User> followers;
  String? error;

  FollowersState(
      {required this.previousState,
      required this.state,
      required this.followers,
      this.error});
}

class GetFollowers {
  final User user;

  const GetFollowers(this.user);
}

class FollowersBloc extends Bloc<Object, FollowersState> {
  final User user;
  FollowersBloc(UsersRepository usersRepository, this.user)
      : super(
          FollowersState(
            previousState: FollowersStates.notStarted,
            state: FollowersStates.notStarted,
            followers: [],
          ),
        ) {
    on<GetFollowers>(
      (event, emit) async {
        final currentPage = state.followers;
        emit(
          FollowersState(
            previousState: state.state,
            state: FollowersStates.loading,
            followers: [],
          ),
        );
        final followers = await usersRepository.getFollowers(
          event.user.id,
          UsersApiCallStart(),
        );
        emit(
          FollowersState(
            previousState: state.state,
            state: FollowersStates.success,
            followers: [...currentPage, ...followers],
          ),
        );
      },
    );
    add(GetFollowers(user));
  }
}
