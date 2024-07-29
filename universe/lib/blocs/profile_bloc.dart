import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:universe/interfaces/iposts_data_provider.dart';
import 'package:universe/interfaces/iusers_data_provider.dart';
import 'package:universe/models/post.dart';
import 'package:universe/models/user.dart';
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
  final IusersDataProvider usersDataProvider;
  final IPostsDataProvider postsDataProvider;

  ProfileBloc(this.usersDataProvider, this.postsDataProvider, User user)
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
    final userPostsResponse =
        await postsDataProvider.getUserPosts(state.user, null, 25);
    final newState = ProfileState(
      user: state.user,
      posts: userPostsResponse.data,
      postCount: userPostsResponse.data.length,
      followersCount: await usersDataProvider.getUserFollowersCount(state.user),
      followingCount: await usersDataProvider.getUserFollowingCount(state.user),
    );

    add(GotUserEvent(state: newState));
  }
}
