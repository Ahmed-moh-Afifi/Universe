import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:universe/blocs/follow_button_bloc.dart';
import 'package:universe/models/user.dart';
import 'package:universe/repositories/authentication_repository.dart';
import 'package:visibility_detector/visibility_detector.dart';

class FollowButton extends StatelessWidget {
  final User user;
  final FollowButtonBloc bloc;
  final widgetKey = GlobalKey();

  FollowButton(this.user, {super.key}) : bloc = FollowButtonBloc(user);

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
              width: 100,
              height: 40,
              child: state.isFollowed != null
                  ? (user.uid ==
                          AuthenticationRepository()
                              .authenticationService
                              .getUser()!
                              .uid
                      ? Container()
                      : (state.isFollowed!
                          ? ElevatedButton(
                              style: const ButtonStyle(
                                backgroundColor: MaterialStatePropertyAll(
                                    Colors.transparent),
                                foregroundColor:
                                    MaterialStatePropertyAll(Colors.white),
                                shape: MaterialStatePropertyAll(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                  ),
                                ),
                              ),
                              child: const Text('Unfollow'),
                              onPressed: () => bloc.add(UnfollowEvent()),
                            )
                          : ElevatedButton(
                              style: const ButtonStyle(
                                shape: MaterialStatePropertyAll(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                  ),
                                ),
                              ),
                              child: const Text('Follow'),
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
