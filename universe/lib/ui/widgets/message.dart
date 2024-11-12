import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:universe/models/data/message.dart';
import 'package:universe/repositories/authentication_repository.dart';
import 'package:universe/ui/styles/text_styles.dart';

class MessageWidget extends StatelessWidget {
  final Message message;

  const MessageWidget(this.message, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: message.authorId ==
                AuthenticationRepository()
                    .authenticationService
                    .currentUser()!
                    .id
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          if (message.authorId !=
              AuthenticationRepository()
                  .authenticationService
                  .currentUser()!
                  .id)
            CircleAvatar(
              radius: 16,
              backgroundImage: CachedNetworkImageProvider(
                message.author!.photoUrl ?? 'https://via.placeholder.com/150',
              ),
            ),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Column(
                crossAxisAlignment: message.authorId ==
                        AuthenticationRepository()
                            .authenticationService
                            .currentUser()!
                            .id
                    ? CrossAxisAlignment.start
                    : CrossAxisAlignment.end,
                children: [
                  Container(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.7,
                    ),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: message.authorId ==
                              AuthenticationRepository()
                                  .authenticationService
                                  .currentUser()!
                                  .id
                          ? Colors.blue[900]
                          : Colors.grey[850],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      message.body,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${(message.publishDate.hour > 12 ? message.publishDate.hour - 12 : message.publishDate.hour)}:${message.publishDate.minute < 10 ? 0 : ''}${message.publishDate.minute} ${message.publishDate.hour > 12 ? 'PM' : 'AM'}',
                    style: TextStyles.subtitleStyle,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
