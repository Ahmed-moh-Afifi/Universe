import 'package:flutter/material.dart';
import 'package:universe/models/user.dart';
import 'package:universe/route_generator.dart';
import 'package:universe/styles/text_styles.dart';
import 'package:universe/widgets/follow_button.dart';
import 'package:universe/widgets/verified_badge.dart';

class UserPresenter extends StatelessWidget {
  final User user;
  final EdgeInsets? contentPadding;
  final EdgeInsets? margin;
  final bool showFollowButton;
  const UserPresenter({
    required this.user,
    this.contentPadding,
    this.margin,
    this.showFollowButton = true,
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
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(
                overflow: TextOverflow.fade,
                softWrap: false,
                maxLines: 1,
                '${user.firstName} ${user.lastName}',
              ),
              user.verified
                  ? const Padding(
                      padding: EdgeInsets.only(left: 5),
                      child: VerifiedBadge(
                        width: 15,
                        height: 15,
                      ),
                    )
                  : const SizedBox(
                      width: 0,
                      height: 0,
                    ),
            ],
          ),
          subtitle: Text('@${user.userName}'),
          subtitleTextStyle: TextStyles.subtitleStyle,
          leading: Container(
            width: 50,
            height: 50,
            clipBehavior: Clip.antiAlias,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(27.5),
              ),
            ),
            child: Image.network(user.photoUrl!),
          ),
          trailing: showFollowButton
              ? SizedBox(width: 110, child: FollowButton(user))
              : const SizedBox(),
        ),
      ),
    );
  }
}
