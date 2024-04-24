import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:universe/apis/authentication/firebase_authentication.dart';
import 'package:universe/apis/firestore.dart';
import 'package:universe/models/following.dart';
import 'package:universe/models/user.dart';

enum FollowingStates {
  notStarted,
  loading,
  success,
  failed,
}

class FollowingState {
  final FollowingStates previousState;
  final FollowingStates state;
  final List<Following> following;
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
  FollowingBloc()
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
        final following = await FirestoreDataProvider()
            .getUserFollowing(event.user, null, 50);
        emit(
          FollowingState(
            previousState: state.state,
            state: FollowingStates.success,
            following: [...currenPage, ...following.followings],
          ),
        );
      },
    );
    add(GetFollowing(FirebaseAuthentication().user!));
  }
}
