import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:universe/interfaces/iposts_data_provider.dart';
import 'package:universe/interfaces/iusers_data_provider.dart';
import 'package:universe/models/data/user.dart';

class ProfileCardState {
  final User user;
  int postCount = 0;
  int followersCount = 0;
  int followingCount = 0;

  ProfileCardState({
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

class ProfileCardBloc extends Bloc<Object, ProfileCardState> {
  final IusersDataProvider usersDataProvider;
  final IPostsDataProvider postsDataProvider;

  ProfileCardBloc(this.usersDataProvider, this.postsDataProvider, User user)
      : super(ProfileCardState(user: user)) {
    on<GetUserEvent>(
      (event, emit) async {
        final newState = ProfileCardState(
          user: user,
          postCount: await postsDataProvider.getUserPostsCount(user),
          followersCount: await usersDataProvider.getUserFollowersCount(user),
          followingCount: await usersDataProvider.getUserFollowingCount(user),
        );
        emit(newState);
      },
    );

    add(GetUserEvent(user: user));
  }
}
