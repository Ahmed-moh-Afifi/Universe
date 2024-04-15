import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:universe/models/user.dart';
import 'package:universe/repositories/authentication_repository.dart';
import 'package:universe/repositories/data_repository.dart';

class PersonalProfileState {
  final User user;
  int postCount = 0;
  int followersCount = 0;
  int followingCount = 0;

  PersonalProfileState({
    required this.user,
    this.postCount = 0,
    this.followersCount = 0,
    this.followingCount = 0,
  });
}

class GetUserEvent {
  final User user;

  const GetUserEvent({required this.user});
}

class PersonalProfileBloc extends Bloc<Object, PersonalProfileState> {
  PersonalProfileBloc()
      : super(PersonalProfileState(
            user:
                AuthenticationRepository().authenticationService.getUser()!)) {
    on<GetUserEvent>(
      (event, emit) async {
        final newState = PersonalProfileState(
          user: state.user,
          postCount:
              await DataRepository().dataProvider.getUserPostsCount(state.user),
          followersCount: await DataRepository()
              .dataProvider
              .getUserFollowersCount(state.user),
          followingCount: await DataRepository()
              .dataProvider
              .getUserFollowingCount(state.user),
        );
        emit(newState);
      },
    );

    add(GetUserEvent(
        user: AuthenticationRepository().authenticationService.getUser()!));
  }
}
