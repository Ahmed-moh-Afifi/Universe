import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:universe/models/data/message.dart';
import 'package:universe/repositories/authentication_repository.dart';
import 'package:universe/ui/styles/text_styles.dart';

class MessageWidget extends StatelessWidget {
  final Message message;
  final bool showDate;
  final bool showProfileAvatar;

  const MessageWidget(this.message, this.showDate, this.showProfileAvatar,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: showDate ? 16 : 0, left: 8, right: 8),
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
            showProfileAvatar
                ? CircleAvatar(
                    radius: 16,
                    backgroundImage: CachedNetworkImageProvider(
                      message.author!.photoUrl ??
                          'https://via.placeholder.com/150',
                    ),
                  )
                : const SizedBox(width: 32),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Column(
                crossAxisAlignment: message.authorId ==
                        AuthenticationRepository()
                            .authenticationService
                            .currentUser()!
                            .id
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
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
                  showDate
                      ? Text(
                          '${(message.publishDate.hour > 12 && message.publishDate.hour != 0 ? message.publishDate.hour - 12 : message.publishDate.hour == 0 ? 12 : message.publishDate.hour)}:${message.publishDate.minute < 10 ? 0 : ''}${message.publishDate.minute} ${message.publishDate.hour >= 12 ? 'PM' : 'AM'}',
                          style: TextStyles.subtitleStyle,
                        )
                      : const SizedBox.shrink(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
