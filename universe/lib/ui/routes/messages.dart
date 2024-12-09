import 'package:auto_direction/auto_direction.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:universe/extensions/date_time_extensions.dart';
import 'package:universe/repositories/authentication_repository.dart';
import 'package:universe/repositories/chats_repository.dart';
import 'package:universe/ui/blocs/messages_bloc.dart';
import 'package:universe/ui/styles/text_styles.dart';
import 'package:universe/ui/widgets/verified_badge.dart';

class Messages extends StatelessWidget {
  const Messages({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          MessagesBloc(ChatsRepository())..add(GetChatsEvent()),
      child: MessagesContent(),
    );
  }
}

class MessagesContent extends StatelessWidget {
  const MessagesContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
                  fillColor: const Color.fromRGBO(80, 80, 80, 0.3),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50.0),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            Expanded(child: BlocBuilder<MessagesBloc, MessagesState>(
              builder: (context, state) {
                return state.state == MessagesStates.loaded
                    ? ListView.builder(
                        itemBuilder: (context, index) => ChatTile(
                          name: state.chats![index].name,
                          message: state.chats![index].messages[0].body,
                          time: state.chats![index].messages.first.publishDate
                              .toEnglishString(),
                          image: state.chats![index].users.any((u) =>
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
                                      .photoUrl ??
                                  'https://via.placeholder.com/150'
                              : state.chats![index].users
                                      .where((u) =>
                                          u.id ==
                                          AuthenticationRepository()
                                              .authenticationService
                                              .currentUser()!
                                              .id)
                                      .first
                                      .photoUrl ??
                                  'https://via.placeholder.com/150',
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
                        ),
                        itemCount: state.chats?.length,
                      )
                    : const Center(
                        child: CircularProgressIndicator(),
                      );
              },
            )
                // ListView(
                //   children: const [
                //     ChatTile(
                //       name: 'Donna Gray',
                //       message: 'Hey! I saw you like hiking...',
                //       time: '3m ago',
                //       image:
                //           'https://via.placeholder.com/150', // Placeholder for avatar
                //       isOnline: true,
                //     ),
                //     ChatTile(
                //       name: 'Luciana Garcia',
                //       message: 'Your dog is adorable. What’s his name?',
                //       time: '7m ago',
                //       image: 'https://via.placeholder.com/150',
                //       isOnline: false,
                //     ),
                //     ChatTile(
                //       name: 'Amina Murphy',
                //       message: 'Hello! I noticed we both love sushi.',
                //       time: '22h ago',
                //       image: 'https://via.placeholder.com/150',
                //       isOnline: false,
                //     ),
                //     ChatTile(
                //       name: 'Aisha Ahmad',
                //       message: 'Hey there! I see you’re into photography',
                //       time: '3d ago',
                //       image: 'https://via.placeholder.com/150',
                //       isOnline: false,
                //     ),
                //   ],
                // ),
                ),
          ],
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 100),
          child: FloatingActionButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50.0),
            ),
            onPressed: () {},
            backgroundColor: Colors.white,
            child: const Icon(Icons.add, color: Colors.black),
          ),
        ),
      ),
    );
  }
}

class ChatTile extends StatelessWidget {
  final String name;
  final String message;
  final String time;
  final String image;
  final bool isOnline;
  final bool verified;

  const ChatTile({
    super.key,
    required this.name,
    required this.message,
    required this.time,
    required this.image,
    this.isOnline = false,
    this.verified = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Stack(
        children: [
          CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(image),
            radius: 25,
          ),
          if (isOnline)
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                height: 12,
                width: 12,
                decoration: BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.black, width: 2),
                ),
              ),
            ),
        ],
      ),
      title: Row(
        children: [
          Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
          verified
              ? Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: VerifiedBadge(
                    width: 15,
                    height: 15,
                  ),
                )
              : const SizedBox(width: 0, height: 0),
        ],
      ),
      subtitle: AutoDirection(
          text: message,
          child: Text(
            message,
            textAlign: TextAlign.left,
            softWrap: false,
            overflow: TextOverflow.ellipsis,
            style: TextStyles.subtitleStyle.copyWith(fontSize: 16),
          )),
      trailing: Text(
        time,
        style: const TextStyle(color: Colors.grey),
      ),
    );
  }
}
