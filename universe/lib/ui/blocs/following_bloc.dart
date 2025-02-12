import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:universe/models/data/user.dart';
import 'package:universe/models/requests/users_api_call_start.dart';
import 'package:universe/repositories/users_repository.dart';

enum FollowingStates {
  notStarted,
  loading,
  success,
  failed,
}

class FollowingState {
  final FollowingStates previousState;
  final FollowingStates state;
  final List<User> following;
  String? error;

  FollowingState(
      {required this.previousState,
      required this.state,
      required this.following,
      this.error});
}

class GetFollowing {
  final User user;

  const GetFollowing(this.user);
}

class FollowingBloc extends Bloc<Object, FollowingState> {
  final User user;
  FollowingBloc(UsersRepository usersRepository, this.user)
      : super(
          FollowingState(
            previousState: FollowingStates.notStarted,
            state: FollowingStates.notStarted,
            following: [],
          ),
        ) {
    on<GetFollowing>(
      (event, emit) async {
        final currentPage = state.following;
        emit(
          FollowingState(
            previousState: state.state,
            state: FollowingStates.loading,
            following: [],
          ),
        );
        final following = await usersRepository.getFollowing(
          event.user.id,
          UsersApiCallStart(),
        );
        emit(
          FollowingState(
            previousState: state.state,
            state: FollowingStates.success,
            following: [...currentPage, ...following],
          ),
        );
      },
    );
    add(GetFollowing(user));
  }
}
