import 'package:auto_direction/auto_direction.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:universe/ui/blocs/online_status_bloc.dart';
import 'package:universe/ui/styles/text_styles.dart';
import 'package:universe/ui/widgets/verified_badge.dart';

class ChatTile extends StatelessWidget {
  final String name;
  final String message;
  final String time;
  final String image;
  final bool isOnline;
  final bool verified;
  final List<String> userIds;

  const ChatTile({
    super.key,
    required this.name,
    required this.message,
    required this.time,
    required this.image,
    required this.userIds,
    this.isOnline = false,
    this.verified = false,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          OnlineStatusBloc(userIds: userIds, isOnline: isOnline),
      child: ChatTileContent(
        name: name,
        message: message,
        time: time,
        image: image,
        verified: verified,
      ),
    );
  }
}

class ChatTileContent extends StatelessWidget {
  final String name;
  final String message;
  final String time;
  final String image;
  final bool verified;

  const ChatTileContent({
    super.key,
    required this.name,
    required this.message,
    required this.time,
    required this.image,
    this.verified = false,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnlineStatusBloc, OnlineState>(
      builder: (context, state) {
        return ListTile(
          leading: Stack(
            children: [
              CircleAvatar(
                backgroundImage: CachedNetworkImageProvider(image),
                radius: 25,
              ),
              if (state.isOnline)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    height: 15,
                    width: 15,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 0, 255, 64),
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
      },
    );
  }
}
