import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:universe/ui/blocs/follow_button_bloc.dart';
import 'package:universe/models/data/user.dart';
import 'package:universe/repositories/authentication_repository.dart';
import 'package:universe/repositories/users_repository.dart';
import 'package:visibility_detector/visibility_detector.dart';

class FollowButton extends StatelessWidget {
  final User user;
  final FollowButtonBloc bloc;
  final widgetKey = GlobalKey();

  FollowButton(this.user, {super.key})
      : bloc = FollowButtonBloc(UsersRepository(), user);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<FollowButtonBloc>(
      create: (context) => bloc,
      child: BlocBuilder<FollowButtonBloc, FollowButtonState>(
        builder: (context, state) {
          return VisibilityDetector(
            key: widgetKey,
            onVisibilityChanged: (info) {
              if (info.visibleFraction != 0 && bloc.builtOnce) {
                bloc.add(GetFollowState());
              }
            },
            child: SizedBox(
              child: state.isFollowed != null
                  ? (user.id ==
                          AuthenticationRepository()
                              .authenticationService
                              .currentUser()!
                              .id
                      ? Container()
                      : (state.isFollowed!
                          ? IconButton(
                              style: const ButtonStyle(
                                backgroundColor:
                                    WidgetStatePropertyAll(Colors.transparent),
                                shape: WidgetStatePropertyAll(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                  ),
                                ),
                              ),
                              icon: SvgPicture.asset(
                                'lib/assets/icons/circle-minus.svg',
                                colorFilter: ColorFilter.mode(
                                  Theme.of(context).colorScheme.primary,
                                  BlendMode.srcIn,
                                ),
                              ),
                              onPressed: () => bloc.add(UnfollowEvent()),
                            )
                          : IconButton(
                              style: const ButtonStyle(
                                shape: WidgetStatePropertyAll(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                  ),
                                ),
                              ),
                              icon: SvgPicture.asset(
                                'lib/assets/icons/circle-plus.svg',
                                colorFilter: ColorFilter.mode(
                                  Theme.of(context).colorScheme.primary,
                                  BlendMode.srcIn,
                                ),
                              ),
                              onPressed: () => bloc.add(FollowEvent()),
                            )))
                  : const SizedBox(
                      width: 25,
                      height: 25,
                      // child: Center(
                      //   child: CircularProgressIndicator(),
                      // ),
                    ),
            ),
          );
        },
      ),
    );
  }
}
