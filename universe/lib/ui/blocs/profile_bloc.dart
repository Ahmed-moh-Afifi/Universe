import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:universe/interfaces/ichats_repository.dart';
import 'package:universe/interfaces/iposts_repository.dart';
import 'package:universe/interfaces/iusers_repository.dart';
import 'package:universe/models/data/post.dart';
import 'package:universe/models/data/user.dart';
import 'package:universe/models/requests/api_call_start.dart';
import 'package:universe/repositories/authentication_repository.dart';
import 'package:universe/route_generator.dart';

enum ProfileStates {
  notStarted,
  loading,
  success,
  failed,
}

class ProfileState {
  ProfileStates state;
  final User user;
  final Iterable<Post> posts;
  final int? postCount;
  final int? followersCount;
  final int? followingCount;

  ProfileState({
    this.state = ProfileStates.success,
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

class ChatEvent {
  const ChatEvent();
}

class ProfileBloc extends Bloc<Object, ProfileState> {
  final IUsersRepository usersRepository;
  final IPostsRepository postsRepository;
  final IChatsRepository chatsRepository;

  ProfileBloc(this.usersRepository, this.postsRepository, this.chatsRepository,
      User user)
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

    on<ChatEvent>(
      (event, emit) async {
        emit(state..state = ProfileStates.loading);
        final chat = await chatsRepository.getChatByParticipants(
          AuthenticationRepository().authenticationService.currentUser()!.id,
          user.id,
        );

        // RouteGenerator.mainNavigatorkey.currentState!.pop();

        RouteGenerator.mainNavigatorkey.currentState!.pushNamed(
          RouteGenerator.chat,
          arguments: chat,
        );
      },
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
