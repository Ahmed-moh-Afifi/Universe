import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:universe/blocs/user_presenter_bloc.dart';
import 'package:universe/models/user.dart';
import 'package:universe/route_generator.dart';
import 'package:universe/styles/text_styles.dart';
import 'package:universe/widgets/follow_button.dart';

class UserPresenter extends StatelessWidget {
  final User user;
  final UserPresenterBloc bloc;
  final EdgeInsets? contentPadding;
  final EdgeInsets? margin;
  final bool showFollowButton;
  UserPresenter(
      {required this.user,
      this.contentPadding,
      this.margin,
      this.showFollowButton = true,
      super.key})
      : bloc = UserPresenterBloc(user);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: TextButton(
        style: const ButtonStyle(
          overlayColor: MaterialStatePropertyAll(Colors.transparent),
          padding: MaterialStatePropertyAll(EdgeInsets.zero),
          shape: MaterialStatePropertyAll(
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
            children: [
              Text(
                '${user.firstName} ${user.lastName}',
              ),
              user.verified
                  ? Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: SvgPicture.asset(
                        width: 20,
                        height: 20,
                        'lib/assets/icons/shield.svg',
                        colorFilter: const ColorFilter.mode(
                            Colors.white, BlendMode.srcIn),
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
            width: 55,
            height: 55,
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
