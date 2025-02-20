import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:universe/extensions/date_time_extensions.dart';
import 'package:universe/repositories/authentication_repository.dart';
import 'package:universe/repositories/chats_repository.dart';
import 'package:universe/repositories/users_repository.dart';
import 'package:universe/ui/blocs/messages_bloc.dart';
import 'package:universe/ui/styles/text_styles.dart';
import 'package:universe/ui/widgets/chat_tile.dart';

class Messages extends StatelessWidget {
  const Messages({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MessagesBloc(ChatsRepository(), UsersRepository())
        ..add(GetChatsEvent()),
      child: MessagesContent(),
    );
  }
}

class MessagesContent extends StatelessWidget {
  const MessagesContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: false,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 115,
          elevation: 0,
          flexibleSpace: Padding(
            padding: const EdgeInsets.only(top: 0.0, left: 16.0, right: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: SvgPicture.asset(
                        'lib/assets/icons/settings.svg',
                        colorFilter: ColorFilter.mode(
                            Theme.of(context).colorScheme.primary,
                            BlendMode.srcIn),
                      ),
                      onPressed: () {},
                    ),
                  ],
                ),
                const SizedBox(height: 10.0),
                Text(
                  'Chats',
                  style: TextStyles.hugeStyle,
                ),
              ],
            ),
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
              child: TextField(
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  hintText: 'Search',
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50.0),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            Expanded(
              child: BlocBuilder<MessagesBloc, MessagesState>(
                builder: (context, state) {
                  return state.state == MessagesStates.loaded
                      ? state.chats?.length != null && state.chats!.isNotEmpty
                          ? ListView.builder(
                              itemCount:
                                  state.chats != null ? state.chats!.length : 0,
                              itemBuilder: (context, index) => GestureDetector(
                                onTap: () =>
                                    BlocProvider.of<MessagesBloc>(context).add(
                                        OpenChatEvent(state.chats![index].id)),
                                child: ChatTile(
                                  lastOnline: state.chats![index].users.any(
                                          (u) =>
                                              u.id !=
                                              AuthenticationRepository()
                                                  .authenticationService
                                                  .currentUser()!
                                                  .id)
                                      ? state.chats![index].users
                                          .where((u) =>
                                              u.id !=
                                              AuthenticationRepository()
                                                  .authenticationService
                                                  .currentUser()!
                                                  .id)
                                          .first
                                          .lastOnline!
                                      : state.chats![index].users
                                          .where((u) =>
                                              u.id ==
                                              AuthenticationRepository()
                                                  .authenticationService
                                                  .currentUser()!
                                                  .id)
                                          .first
                                          .lastOnline!,
                                  userIds: state.chats![index].users
                                      .map((u) => u.id)
                                      .where((u) =>
                                          u !=
                                          AuthenticationRepository()
                                              .authenticationService
                                              .currentUser()!
                                              .id)
                                      .toList(),
                                  name: state.chats?[index].name ?? '',
                                  message: state.chats != null &&
                                          state
                                              .chats![index].messages.isNotEmpty
                                      ? (state.chats?[index].messages[0].body ??
                                          '')
                                      : '',
                                  time: state.chats != null &&
                                          state
                                              .chats![index].messages.isNotEmpty
                                      ? (state.chats?[index].messages.first
                                              .publishDate
                                              .toEnglishString() ??
                                          '')
                                      : '',
                                  image: state.chats![index].photoUrl,
                                  verified: state.chats![index].users.any((u) =>
                                          u.id !=
                                          AuthenticationRepository()
                                              .authenticationService
                                              .currentUser()!
                                              .id)
                                      ? state.chats![index].users
                                          .where((u) =>
                                              u.id !=
                                              AuthenticationRepository()
                                                  .authenticationService
                                                  .currentUser()!
                                                  .id)
                                          .first
                                          .verified
                                      : state.chats![index].users
                                          .where((u) =>
                                              u.id ==
                                              AuthenticationRepository()
                                                  .authenticationService
                                                  .currentUser()!
                                                  .id)
                                          .first
                                          .verified,
                                  isOnline: state.chats![index].users.any((u) =>
                                          u.id !=
                                          AuthenticationRepository()
                                              .authenticationService
                                              .currentUser()!
                                              .id)
                                      ? state.chats![index].users
                                              .where((u) =>
                                                  u.id !=
                                                  AuthenticationRepository()
                                                      .authenticationService
                                                      .currentUser()!
                                                      .id)
                                              .first
                                              .onlineSessions >
                                          0
                                      : state.chats![index].users
                                              .where((u) =>
                                                  u.id ==
                                                  AuthenticationRepository()
                                                      .authenticationService
                                                      .currentUser()!
                                                      .id)
                                              .first
                                              .onlineSessions >
                                          0,
                                ),
                              ),
                            )
                          : const Center(
                              child: Text('No chats yet!'),
                            )
                      : const Center(
                          child: CircularProgressIndicator(),
                        );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
