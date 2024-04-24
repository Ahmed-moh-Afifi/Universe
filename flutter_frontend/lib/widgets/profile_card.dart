import 'package:flutter/material.dart';
import 'package:universe/models/user.dart';
import 'package:universe/route_generator.dart';
import 'package:universe/styles/text_styles.dart';
import 'package:universe/widgets/verified_badge.dart';

class ProfileCard extends StatelessWidget {
  final User user;
  final int? postsCount;
  final int? followersCount;
  final int? followingCount;
  // final ProfileCardBloc bloc;
  const ProfileCard(
      this.user, this.postsCount, this.followersCount, this.followingCount,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(0),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: const Color.fromRGBO(80, 80, 80, 0.3)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            margin: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(60),
            ),
            clipBehavior: Clip.antiAlias,
            child: Image.network(user.photoUrl!),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${user.firstName} ${user.lastName}',
                  style: TextStyles.titleStyle,
                ),
                user.verified
                    ? const Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: VerifiedBadge(),
                      )
                    : const SizedBox(
                        width: 0,
                        height: 0,
                      ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Text(
              '@${user.userName}',
              style: TextStyles.subtitleStyle,
            ),
          ),
          IntrinsicHeight(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    width: 100,
                    child: TextButton(
                      style: const ButtonStyle(
                        surfaceTintColor:
                            MaterialStatePropertyAll(Colors.transparent),
                        overlayColor:
                            MaterialStatePropertyAll(Colors.transparent),
                        splashFactory: NoSplash.splashFactory,
                      ),
                      onPressed: () {},
                      child: Column(
                        children: [
                          Text((postsCount ?? '').toString()),
                          Text(
                            'posts',
                            style: TextStyles.subtitleStyle,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const VerticalDivider(
                    width: 1,
                    thickness: 1,
                    color: Color.fromRGBO(80, 80, 80, 0.3),
                  ),
                  SizedBox(
                    width: 100,
                    child: TextButton(
                      onPressed: () => RouteGenerator
                          .mainNavigatorkey.currentState!
                          .pushNamed(RouteGenerator.followersPage),
                      child: Column(
                        children: [
                          Text((followersCount ?? '').toString()),
                          Text(
                            'followers',
                            style: TextStyles.subtitleStyle,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const VerticalDivider(
                    width: 1,
                    thickness: 1,
                    color: Color.fromRGBO(80, 80, 80, 0.3),
                  ),
                  SizedBox(
                    width: 100,
                    child: TextButton(
                      onPressed: () => RouteGenerator
                          .mainNavigatorkey.currentState!
                          .pushNamed(
                        RouteGenerator.followingPage,
                      ),
                      child: Column(
                        children: [
                          Text((followingCount ?? '').toString()),
                          Text(
                            'following',
                            style: TextStyles.subtitleStyle,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
