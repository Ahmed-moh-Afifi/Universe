import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:universe/interfaces/iposts_repository.dart';
import 'package:universe/interfaces/iusers_repository.dart';
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
  final IUsersRepository usersRepository;
  final IPostsRepository postsRepository;

  ProfileCardBloc(this.usersRepository, this.postsRepository, User user)
      : super(ProfileCardState(user: user)) {
    on<GetUserEvent>(
      (event, emit) async {
        final newState = ProfileCardState(
          user: user,
          postCount: await postsRepository.getUserPostsCount(user.id),
          followersCount: await usersRepository.getFollowersCount(user.id),
          followingCount: await usersRepository.getFollowingCount(user.id),
        );
        emit(newState);
      },
    );

    add(GetUserEvent(user: user));
  }
}
