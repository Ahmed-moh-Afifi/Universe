import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:universe/models/user.dart';
import 'package:universe/repositories/data_repository.dart';

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
  FollowersBloc(this.user)
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
        final followers = await DataRepository()
            .dataProvider
            .getUserFollowers(event.user, null, 50);
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
