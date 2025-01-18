import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:universe/models/data/user.dart';
import 'package:universe/route_generator.dart';
import 'package:universe/ui/styles/text_styles.dart';
import 'package:universe/ui/widgets/fading_circle_progress_indicator.dart';
import 'package:universe/ui/widgets/follow_button.dart';
import 'package:universe/ui/widgets/verified_badge.dart';

class UserPresenter extends StatelessWidget {
  final User user;
  final EdgeInsets? contentPadding;
  final EdgeInsets? margin;
  final bool showFollowButton;
  final bool loading;

  const UserPresenter({
    required this.user,
    this.contentPadding,
    this.margin,
    this.showFollowButton = false,
    this.loading = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: TextButton(
        style: const ButtonStyle(
          overlayColor: WidgetStatePropertyAll(Colors.transparent),
          splashFactory: NoSplash.splashFactory,
          padding: WidgetStatePropertyAll(EdgeInsets.zero),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ),
            ),
          ),
        ),
        onPressed: () => RouteGenerator.mainNavigatorkey.currentState!
            .pushNamed(RouteGenerator.profile, arguments: user),
        child: ListTile(
          contentPadding: contentPadding,
          dense: true,
          visualDensity: VisualDensity.compact,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(
                overflow: TextOverflow.fade,
                softWrap: false,
                maxLines: 1,
                style: TextStyle(fontSize: 12),
                '${user.firstName} ${user.lastName}',
              ),
              user.verified
                  ? const Padding(
                      padding: EdgeInsets.only(left: 5),
                      child: VerifiedBadge(
                        width: 10,
                        height: 10,
                      ),
                    )
                  : const SizedBox(
                      width: 0,
                      height: 0,
                    ),
            ],
          ),
          subtitle: Text('@${user.userName}',
              style: TextStyles.subtitleStyle.copyWith(fontSize: 10)),
          subtitleTextStyle: TextStyles.subtitleStyle.copyWith(fontSize: 10),
          leading: SizedBox(
            width: 34,
            height: 34,
            child: loading
                ? Stack(
                    children: [
                      FadingCircleLoader(
                        radius: 17,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: CircleAvatar(
                          radius: 15,
                          foregroundImage: CachedNetworkImageProvider(
                              user.photoUrl ??
                                  'https://via.placeholder.com/150'),
                        ),
                      ),
                    ],
                  )
                : CircleAvatar(
                    radius: 15,
                    foregroundImage: CachedNetworkImageProvider(
                        user.photoUrl ?? 'https://via.placeholder.com/150'),
                  ),
          ),
          // Container(
          //   width: 50,
          //   height: 50,
          //   clipBehavior: Clip.antiAlias,
          //   decoration: const BoxDecoration(
          //     borderRadius: BorderRadius.all(
          //       Radius.circular(27.5),
          //     ),
          //   ),
          //   child: CachedNetworkImage(
          //       imageUrl: user.photoUrl ?? 'https://via.placeholder.com/150'),
          // ),
          trailing: showFollowButton
              ? SizedBox(width: 110, child: FollowButton(user))
              : const SizedBox(),
        ),
      ),
    );
  }
}
