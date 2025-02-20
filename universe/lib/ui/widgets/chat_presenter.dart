import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_svg/svg.dart';
import 'package:universe/models/data/chat.dart';
import 'package:universe/route_generator.dart';
import 'package:universe/ui/styles/text_styles.dart';
import 'package:universe/ui/widgets/fading_circle_progress_indicator.dart';
import 'package:universe/ui/widgets/verified_badge.dart';

class ChatPresenter extends StatelessWidget {
  final Chat chat;
  final bool verified;
  final EdgeInsets? contentPadding;
  final EdgeInsets? margin;
  final bool showFollowButton;
  final bool loading;
  final String subtitle;
  final Widget? subtitleWidget;

  const ChatPresenter({
    required this.chat,
    this.verified = false,
    this.contentPadding,
    this.margin,
    this.showFollowButton = false,
    this.loading = false,
    this.subtitle = '',
    this.subtitleWidget,
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
            .pushNamed(RouteGenerator.profile, arguments: chat),
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
                chat.name,
              ),
              verified
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
          subtitle: Row(
            spacing: 3,
            children: [
              Text(subtitle,
                  style: TextStyles.subtitleStyle.copyWith(fontSize: 10)),
              subtitleWidget != null ? subtitleWidget! : SizedBox.shrink(),
            ],
          ),
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
                        child: chat.photoUrl != null
                            ? CircleAvatar(
                                radius: 15,
                                foregroundImage:
                                    CachedNetworkImageProvider(chat.photoUrl!),
                              )
                            : SvgPicture.asset('lib/assets/icons/user.svg',
                                width: 30,
                                height: 30,
                                colorFilter: ColorFilter.mode(
                                    Colors.white, BlendMode.srcIn)),
                      ),
                    ],
                  )
                : chat.photoUrl != null
                    ? CircleAvatar(
                        radius: 15,
                        foregroundImage:
                            CachedNetworkImageProvider(chat.photoUrl!),
                      )
                    : SvgPicture.asset('lib/assets/icons/user.svg',
                        width: 30,
                        height: 30,
                        colorFilter:
                            ColorFilter.mode(Colors.white, BlendMode.srcIn)),
          ),
        ),
      ),
    );
  }
}
