import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:universe/models/data/chat.dart';
import 'package:universe/models/data/message.dart';
import 'package:universe/models/data/user.dart';
import 'package:universe/repositories/authentication_repository.dart';
import 'package:universe/ui/blocs/chat_bloc.dart';
import 'package:universe/ui/blocs/notifications_bloc.dart';

class ChatScreen extends StatelessWidget {
  final Chat chat;
  final User user;

  const ChatScreen(this.user, this.chat, {super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChatBloc(),
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
                    itemCount: state.messages?.length,
                    itemBuilder: (context, index) {
                      final message = state.messages?[index];
                      return ListTile(
                        title: Text(user.userName),
                        subtitle: Text(message?.body ?? ''),
                        leading: CircleAvatar(
                          backgroundImage: CachedNetworkImageProvider(
                              user.photoUrl ??
                                  'https://via.placeholder.com/150'),
                        ),
                      );
                    },
                  );

                  // return const Center(child: Text('Messages go here'));
                } else {
                  return const Center(child: Text('Something went wrong!'));
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: 'Enter your message',
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
                              chatId: chat.id),
                          user.id));
                    },
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
