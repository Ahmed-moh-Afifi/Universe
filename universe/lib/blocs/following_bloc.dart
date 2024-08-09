import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:universe/interfaces/iusers_data_provider.dart';
import 'package:universe/models/data/user.dart';

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
  FollowingBloc(IusersDataProvider usersDataProvider, this.user)
      : super(
          FollowingState(
            previousState: FollowingStates.notStarted,
            state: FollowingStates.notStarted,
            following: [],
          ),
        ) {
    on<GetFollowing>(
      (event, emit) async {
        final currenPage = state.following;
        emit(
          FollowingState(
            previousState: state.state,
            state: FollowingStates.loading,
            following: [],
          ),
        );
        final following =
            await usersDataProvider.getUserFollowing(event.user, null, 50);
        emit(
          FollowingState(
            previousState: state.state,
            state: FollowingStates.success,
            following: [...currenPage, ...following.followings],
          ),
        );
      },
    );
    add(GetFollowing(user));
  }
}
