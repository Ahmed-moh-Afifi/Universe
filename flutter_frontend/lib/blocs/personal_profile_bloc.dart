import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:universe/models/post.dart';
import 'package:universe/models/user.dart';
import 'package:universe/repositories/authentication_repository.dart';
import 'package:universe/repositories/data_repository.dart';
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
  int postCount = 0;
  int followersCount = 0;
  int followingCount = 0;

  PersonalProfileState({
    required this.state,
    required this.user,
    required this.posts,
    this.postCount = 0,
    this.followersCount = 0,
    this.followingCount = 0,
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

class PersonalProfileBloc extends Bloc<Object, PersonalProfileState> {
  PersonalProfileBloc()
      : super(
          RouteGenerator.personalProfileState == null ||
                  RouteGenerator.personalProfileState!.state ==
                      PersonalProfileStates.notStarted
              ? PersonalProfileState(
                  state: PersonalProfileStates.notStarted,
                  user: AuthenticationRepository()
                      .authenticationService
                      .getUser()!,
                  posts: [],
                )
              : RouteGenerator.personalProfileState!,
        ) {
    on<GetUserEvent>(
      (event, emit) async {
        emit(
          PersonalProfileState(
            state: PersonalProfileStates.loading,
            user: AuthenticationRepository().authenticationService.getUser()!,
            posts: [],
          ),
        );

        final userPostsResponse = await DataRepository()
            .dataProvider
            .getUserPosts(event.user, null, 25);
        final newState = PersonalProfileState(
          state: PersonalProfileStates.success,
          user: state.user,
          posts: userPostsResponse.posts,
          postCount: userPostsResponse.posts.length,
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

    if (RouteGenerator.personalProfileState!.state ==
        PersonalProfileStates.notStarted) {
      add(GetUserEvent(
          user: AuthenticationRepository().authenticationService.getUser()!));
    }
  }
}
