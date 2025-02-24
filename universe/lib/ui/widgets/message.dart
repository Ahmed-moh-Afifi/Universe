import 'package:auto_direction/auto_direction.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:universe/models/data/message.dart';
import 'package:universe/repositories/authentication_repository.dart';
import 'package:universe/ui/styles/text_styles.dart';

class MessageWidget extends StatelessWidget {
  final Message message;
  final bool showDate;
  final bool showProfileAvatar;
  final bool showName;

  const MessageWidget(
      this.message, this.showDate, this.showProfileAvatar, this.showName,
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
                ? message.author!.photoUrl != null
                    ? CircleAvatar(
                        radius: 16,
                        backgroundImage: CachedNetworkImageProvider(
                            message.author!.photoUrl!),
                      )
                    : SvgPicture.asset('lib/assets/icons/user.svg',
                        width: 30,
                        height: 30,
                        colorFilter:
                            ColorFilter.mode(Colors.white, BlendMode.srcIn))
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
                  showName
                      ? Text(
                          message.author!.userName,
                          style: TextStyles.subtitleStyle,
                        )
                      : SizedBox.shrink(),
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
                          : Color.fromRGBO(21, 26, 34, 1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: AutoDirection(
                      text: message.body,
                      child: Text(
                        message.body,
                        style: TextStyle(
                          color: Colors.white,
                        ),
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
