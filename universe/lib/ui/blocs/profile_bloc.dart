import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:universe/interfaces/iposts_repository.dart';
import 'package:universe/interfaces/iusers_repository.dart';
import 'package:universe/models/data/post.dart';
import 'package:universe/models/data/user.dart';
import 'package:universe/models/requests/api_call_start.dart';
import 'package:universe/repositories/authentication_repository.dart';

enum ProfileStates {
  notStarted,
  loading,
  success,
  failed,
}

class ProfileState {
  final User user;
  final Iterable<Post> posts;
  final int? postCount;
  final int? followersCount;
  final int? followingCount;

  ProfileState({
    required this.user,
    required this.posts,
    this.postCount,
    this.followersCount,
    this.followingCount,
  });
}

class GetUserEvent {
  final User user;

  const GetUserEvent({required this.user});
}

class GotUserEvent {
  final ProfileState state;

  const GotUserEvent({required this.state});
}

class ProfileBloc extends Bloc<Object, ProfileState> {
  final IUsersRepository usersRepository;
  final IPostsRepository postsRepository;

  ProfileBloc(this.usersRepository, this.postsRepository, User user)
      : super(ProfileState(user: user, posts: [])) {
    on<GetUserEvent>(
      (event, emit) async {
        emit(
          ProfileState(
            user: user,
            posts: [],
          ),
        );
        await getUserData();
      },
    );

    on<GotUserEvent>(
      (event, emit) => emit(event.state),
    );

    add(GetUserEvent(
        user: AuthenticationRepository().authenticationService.currentUser()!));
  }

  Future<void> getUserData() async {
    final posts =
        await postsRepository.getUserPosts(state.user.id, ApiCallStart(), 25);
    final newState = ProfileState(
      user: state.user,
      posts: posts,
      postCount: posts.length,
      followersCount: await usersRepository.getFollowersCount(state.user.id),
      followingCount: await usersRepository.getFollowersCount(state.user.id),
    );

    add(GotUserEvent(state: newState));
  }
}
