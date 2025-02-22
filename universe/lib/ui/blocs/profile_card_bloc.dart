import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:universe/interfaces/ichats_repository.dart';
import 'package:universe/interfaces/iposts_repository.dart';
import 'package:universe/interfaces/iusers_repository.dart';
import 'package:universe/models/data/user.dart';
import 'package:universe/repositories/authentication_repository.dart';
import 'package:universe/route_generator.dart';
import 'package:url_launcher/url_launcher.dart';

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

enum LinkType {
  http,
  mail,
  phone,
}

class OpenLinkEvent {
  final LinkType type;
  final String link;

  const OpenLinkEvent({required this.type, required this.link});
}

class ChatEvent {
  const ChatEvent();
}

class ProfileCardBloc extends Bloc<Object, ProfileCardState> {
  final IUsersRepository usersRepository;
  final IPostsRepository postsRepository;
  final IChatsRepository chatsRepository;

  ProfileCardBloc(this.usersRepository, this.postsRepository,
      this.chatsRepository, User user)
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

    on<OpenLinkEvent>(
      (event, emit) async {
        if (event.type == LinkType.mail) {
          var uri = Uri.tryParse('mailto:${event.link}');
          if (uri != null && await canLaunchUrl(uri)) {
            await launchUrl(uri);
          }
        } else if (event.type == LinkType.phone) {
          var uri = Uri.tryParse('tel:${event.link}');
          if (uri != null && await canLaunchUrl(uri)) {
            await launchUrl(uri);
          }
        } else if (event.type == LinkType.http) {
          var uri = Uri.tryParse(event.link);
          if (uri != null && await canLaunchUrl(uri)) {
            await launchUrl(uri);
          }
        }
      },
    );

    on<ChatEvent>(
      (event, emit) async {
        // emit(state..state = ProfileStates.loading);
        var chat = await chatsRepository.getChatByParticipants(
          AuthenticationRepository().authenticationService.currentUser()!.id,
          user.id,
        );

        chat = await chatsRepository.getChat(
          AuthenticationRepository().authenticationService.currentUser()!.id,
          chat.id,
        );

        RouteGenerator.mainNavigatorkey.currentState!.pushNamed(
          RouteGenerator.chat,
          arguments: [chat],
        );
      },
    );

    add(GetUserEvent(user: user));
  }
}
