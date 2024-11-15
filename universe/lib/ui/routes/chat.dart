import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:universe/models/data/chat.dart';
import 'package:universe/models/data/message.dart';
import 'package:universe/models/data/user.dart';
import 'package:universe/repositories/authentication_repository.dart';
import 'package:universe/repositories/chats_repository.dart';
import 'package:universe/ui/blocs/chat_bloc.dart';
import 'package:universe/ui/widgets/message.dart';

class ChatScreen extends StatelessWidget {
  final Chat chat;
  final User user;

  const ChatScreen(this.user, this.chat, {super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChatBloc(chat, ChatsRepository()),
      child: ChatContent(user, chat),
    );
  }
}

class ChatContent extends StatelessWidget {
  final Chat chat;
  final User user;

  const ChatContent(this.user, this.chat, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Row(
        children: [
          CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(
                user.photoUrl ?? 'https://via.placeholder.com/150'),
          ),
          const SizedBox(width: 8),
          Text(user.userName),
        ],
      )),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<ChatBloc, ChatState>(
              builder: (context, state) {
                if (state.state == ChatStates.initial ||
                    state.state == ChatStates.loading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state.state == ChatStates.loaded ||
                    state.state == ChatStates.newMessage) {
                  return ListView.builder(
                    reverse: true,
                    itemCount: state.messages?.length,
                    itemBuilder: (context, index) {
                      final message = state.messages?[index];
                      message!.author = user;
                      return MessageWidget(message);
                    },
                  );
                } else {
                  return const Center(child: Text('Something went wrong!'));
                }
              },
            ),
          ),
          // Text('ahmedafifi took a screenshot.',
          //     style: TextStyles.subtitleStyle),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.transparent,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(1),
                          spreadRadius: 1,
                          blurRadius: 1,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color.fromRGBO(80, 80, 80, 0.3),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                          borderSide: BorderSide.none,
                        ),
                        hintText: 'Message',
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                      onSubmitted: (text) {
                        BlocProvider.of<ChatBloc>(context).add(SendMessage(
                            Message(
                              id: 0,
                              body: text,
                              images: [],
                              videos: [],
                              audios: [],
                              publishDate: DateTime.now(),
                              authorId: AuthenticationRepository()
                                  .authenticationService
                                  .currentUser()!
                                  .id,
                              reactionsCount: 0,
                              repliesCount: 0,
                              chatId: chat.id,
                            ),
                            user.id));
                      },
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    // Handle send button press
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
