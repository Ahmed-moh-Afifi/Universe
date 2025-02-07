import 'dart:ui';

import 'package:auto_direction/auto_direction.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:universe/models/data/chat.dart';
import 'package:universe/models/data/message.dart';
import 'package:universe/models/data/user.dart';
import 'package:universe/repositories/authentication_repository.dart';
import 'package:universe/repositories/chats_repository.dart';
import 'package:universe/ui/blocs/chat_bloc.dart';
import 'package:universe/ui/widgets/message.dart';
import 'package:universe/ui/widgets/user_presenter.dart';

class ChatScreen extends StatelessWidget {
  final Chat chat;
  final User user;

  const ChatScreen(this.user, this.chat, {super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChatBloc(chat, user, ChatsRepository()),
      child: ChatContent(user, chat),
    );
  }
}

class ChatContent extends StatefulWidget {
  final Chat chat;
  final User user;

  const ChatContent(this.user, this.chat, {super.key});

  @override
  State<ChatContent> createState() => _ChatContentState();
}

class _ChatContentState extends State<ChatContent> {
  final TextEditingController _messageController = TextEditingController();
  String text = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        forceMaterialTransparency: true,
        flexibleSpace: FlexibleSpaceBar(
          background: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
              child: Container(color: Colors.transparent)),
        ),
        title: BlocBuilder<ChatBloc, ChatState>(
          builder: (context, state) {
            return UserPresenter(
              user: widget.user,
              contentPadding: EdgeInsets.all(0),
              subtitle: state.isOnline != null
                  ? !state.isOnline!
                      ? "Offline"
                      : state.isTyping != null && state.isTyping!
                          ? "Typing..."
                          : "Online"
                  : '',
            );
          },
        ),
        titleSpacing: 0,
        // Row(
        //   children: [
        //     CircleAvatar(
        //       radius: 20,
        //       backgroundImage: CachedNetworkImageProvider(
        //           widget.user.photoUrl ?? 'https://via.placeholder.com/150'),
        //     ),
        //     const SizedBox(width: 8),
        //     Text(
        //       '${widget.user.firstName} ${widget.user.lastName}',
        //     ),
        //   ],
        // ),
      ),
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
                      Message? previousMessage =
                          index + 1 < state.messages!.length
                              ? state.messages![index + 1]
                              : null;
                      Message? nextMessage =
                          index - 1 >= 0 ? state.messages![index - 1] : null;
                      message!.author = widget.user;
                      if (previousMessage != null) {
                        return MessageWidget(
                          message,
                          (nextMessage == null ||
                                  nextMessage.publishDate
                                          .difference(message.publishDate)
                                          .inMinutes >=
                                      5) ||
                              nextMessage.authorId != message.authorId,
                          previousMessage.authorId != message.authorId,
                        );
                      } else {
                        return MessageWidget(
                            message,
                            (nextMessage == null ||
                                    nextMessage.publishDate
                                            .difference(message.publishDate)
                                            .inMinutes >=
                                        5) ||
                                nextMessage.authorId != message.authorId,
                            true);
                      }
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
                    child: Container(
                      constraints: BoxConstraints(
                          maxHeight: MediaQuery.of(context).size.height * 0.2),
                      child: AutoDirection(
                        text: text,
                        child: TextField(
                          onChanged: (value) {
                            BlocProvider.of<ChatBloc>(context)
                                .add(TextChangedEvent());
                            setState(() {
                              text = value;
                            });
                          },
                          controller: _messageController,
                          maxLines: null,
                          minLines: null,
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
                        ),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    BlocProvider.of<ChatBloc>(context).add(SendMessage(
                        Message(
                          id: 0,
                          body: _messageController.text,
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
                          chatId: widget.chat.id,
                        ),
                        widget.user.id));
                    _messageController.clear();
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
