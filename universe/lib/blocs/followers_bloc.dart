import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:universe/interfaces/iusers_data_provider.dart';
import 'package:universe/models/data/user.dart';

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
  FollowersBloc(IusersDataProvider usersDataProvider, this.user)
      : super(
          FollowersState(
            previousState: FollowersStates.notStarted,
            state: FollowersStates.notStarted,
            followers: [],
          ),
        ) {
    on<GetFollowers>(
      (event, emit) async {
        final currenPage = state.followers;
        emit(
          FollowersState(
            previousState: state.state,
            state: FollowersStates.loading,
            followers: [],
          ),
        );
        final followers =
            await usersDataProvider.getUserFollowers(event.user, null, 50);
        emit(
          FollowersState(
            previousState: state.state,
            state: FollowersStates.success,
            followers: [...currenPage, ...followers.followers],
          ),
        );
      },
    );
    add(GetFollowers(user));
  }
}
