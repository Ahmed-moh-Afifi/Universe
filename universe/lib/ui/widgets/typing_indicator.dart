import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:universe/models/data/user.dart';

class TypingIndicator extends StatelessWidget {
  final User user;
  const TypingIndicator(this.user, {super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 8,
      children: [
        CircleAvatar(
          radius: 16,
          backgroundImage: CachedNetworkImageProvider(
            user.photoUrl ?? 'https://via.placeholder.com/150',
          ),
        ),
        Container(
          width: 61,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Color.fromRGBO(21, 26, 34, 1),
          ),
          child: SpinKitThreeBounce(
            size: 20,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}
