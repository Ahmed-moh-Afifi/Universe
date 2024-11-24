import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:universe/interfaces/iposts_repository.dart';
import 'package:universe/interfaces/iusers_repository.dart';
import 'package:universe/models/data/post.dart';
import 'package:universe/models/data/user.dart';
import 'package:universe/models/requests/api_call_start.dart';
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
  final IUsersRepository usersRepository;
  final IPostsRepository postsRepository;

  PersonalProfileBloc(this.usersRepository, this.postsRepository)
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
    final posts =
        await postsRepository.getUserPosts(state.user.id, ApiCallStart(), 50);
    final newState = PersonalProfileState(
      state: PersonalProfileStates.success,
      user: state.user,
      posts: posts,
      postCount: posts.length,
      followersCount: await usersRepository.getFollowersCount(state.user.id),
      followingCount: await usersRepository.getFollowingCount(state.user.id),
    );

    if (!isClosed) {
      add(GotUserEvent(state: newState));
    }
  }
}
