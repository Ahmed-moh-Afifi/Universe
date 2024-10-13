import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:universe/models/data/chat.dart';
import 'package:universe/ui/blocs/notifications_bloc.dart';

class ChatScreen extends StatelessWidget {
  final Chat chat;

  const ChatScreen(this.chat, {super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NotificationsBloc(),
      child: ChatContent(chat),
    );
  }
}

class ChatContent extends StatelessWidget {
  final Chat chat;

  const ChatContent(this.chat, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<NotificationsBloc, NotificationsState>(
              builder: (context, state) {
                if (state.state == NotificationsStates.loading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state.state == NotificationsStates.loaded) {
                  // return ListView.builder(
                  //   itemCount: state.messages.length,
                  //   itemBuilder: (context, index) {
                  //     final message = state.messages[index];
                  //     return ListTile(
                  //       title: Text(message.sender),
                  //       subtitle: Text(message.content),
                  //     );
                  //   },
                  // );

                  return const Center(child: Text('Messages go here'));
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
                      BlocProvider.of<NotificationsBloc>(context)
                          .add(SendMessage(text));
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
