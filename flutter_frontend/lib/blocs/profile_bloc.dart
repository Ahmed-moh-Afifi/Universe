import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:universe/models/post.dart';
import 'package:universe/models/user.dart';
import 'package:universe/repositories/data_repository.dart';

enum ProfileStates {
  loading,
  success,
  failed,
}

class ProfileState {
  final ProfileStates state;
  final User user;
  final Iterable<Post> posts;
  int postCount = 0;
  int followersCount = 0;
  int followingCount = 0;

  ProfileState({
    required this.state,
    required this.user,
    required this.posts,
    this.postCount = 0,
    this.followersCount = 0,
    this.followingCount = 0,
  });
}

class GetUserEvent {
  final User user;

  const GetUserEvent({required this.user});
}

class ProfileBloc extends Bloc<Object, ProfileState> {
  ProfileBloc(User user)
      : super(
            ProfileState(user: user, state: ProfileStates.loading, posts: [])) {
    on<GetUserEvent>(
      (event, emit) async {
        final userPostsResponse =
            await DataRepository().dataProvider.getUserPosts(user, null, 25);
        final newState = ProfileState(
          state: ProfileStates.success,
          posts: userPostsResponse.posts,
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
