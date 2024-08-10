import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:universe/interfaces/iusers_data_provider.dart';
import 'package:universe/models/data/post.dart';
import 'package:universe/models/data/user.dart';
import 'package:universe/repositories/authentication_repository.dart';
import 'package:universe/route_generator.dart';

enum PersonalProfileStates {
  notStarted,
  loading,
  success,
  failed,
}

class PersonalProfileState {
  final PersonalProfileStates state;
  final User user;
  final Iterable<Post> posts;
  final int? postCount;
  final int? followersCount;
  final int? followingCount;

  PersonalProfileState({
    required this.state,
    required this.user,
    required this.posts,
    this.postCount,
    this.followersCount,
    this.followingCount,
  }) {
    saveState();
  }

  void saveState() {
    RouteGenerator.personalProfileState = this;
  }
}

class GetUserEvent {
  final User user;

  const GetUserEvent({required this.user});
}

class GotUserEvent {
  final PersonalProfileState state;

  const GotUserEvent({required this.state});
}

class PersonalProfileBloc extends Bloc<Object, PersonalProfileState> {
  final IusersDataProvider usersDataProvider;
  final IPostsDataProvider postsDataProvider;
  PersonalProfileBloc(this.usersDataProvider, this.postsDataProvider)
      : super(
          RouteGenerator.personalProfileState == null ||
                  RouteGenerator.personalProfileState!.state ==
                      PersonalProfileStates.notStarted
              ? PersonalProfileState(
                  state: PersonalProfileStates.notStarted,
                  user: AuthenticationRepository()
                      .authenticationService
                      .currentUser()!,
                  posts: [],
                )
              : RouteGenerator.personalProfileState!,
        ) {
    on<GetUserEvent>(
      (event, emit) async {
        emit(
          PersonalProfileState(
            state: PersonalProfileStates.loading,
            user:
                AuthenticationRepository().authenticationService.currentUser()!,
            posts: [],
          ),
        );
        await getUserData();
      },
    );

    on<GotUserEvent>(
      (event, emit) => emit(event.state),
    );

    if (RouteGenerator.personalProfileState!.state ==
        PersonalProfileStates.notStarted) {
      add(GetUserEvent(
          user:
              AuthenticationRepository().authenticationService.currentUser()!));
    }
  }

  Future<void> getUserData() async {
    final posts = await postsDataProvider.getUserPosts(state.user, null, 25);
    final newState = PersonalProfileState(
      state: PersonalProfileStates.success,
      user: state.user,
      posts: posts,
      postCount: posts.length,
      followersCount: await usersDataProvider.getUserFollowersCount(state.user),
      followingCount: await usersDataProvider.getUserFollowingCount(state.user),
    );

    add(GotUserEvent(state: newState));
  }
}
