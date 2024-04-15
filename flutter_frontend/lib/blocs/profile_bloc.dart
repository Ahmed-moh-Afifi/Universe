import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:universe/models/user.dart';
import 'package:universe/repositories/data_repository.dart';

class ProfileState {
  final User user;
  int postCount = 0;
  int followersCount = 0;
  int followingCount = 0;

  ProfileState(
      {required this.user,
      this.postCount = 0,
      this.followersCount = 0,
      this.followingCount = 0});
}

class GetUserEvent {
  final User user;

  const GetUserEvent({required this.user});
}

class ProfileBloc extends Bloc<Object, ProfileState> {
  ProfileBloc(User user) : super(ProfileState(user: user)) {
    on<GetUserEvent>(
      (event, emit) async {
        final newState = ProfileState(
          user: user,
          postCount:
              await DataRepository().dataProvider.getUserPostsCount(user),
          followersCount:
              await DataRepository().dataProvider.getUserFollowersCount(user),
          followingCount:
              await DataRepository().dataProvider.getUserFollowingCount(user),
        );
        emit(newState);
      },
    );

    add(GetUserEvent(user: user));
  }
}
