import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:universe/repositories/authentication_repository.dart';
import 'package:universe/styles/text_styles.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Profile',
                style: TextStyles.titleStyle,
              ),
            ),
          ),
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(60),
            ),
            clipBehavior: Clip.antiAlias,
            child: Image.network(
              AuthenticationRepository()
                  .authenticationService
                  .getUser()!
                  .photoUrl!,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Text(
              AuthenticationRepository()
                  .authenticationService
                  .getUser()!
                  .userName,
              style: TextStyles.titleStyle,
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
                    child: Column(
                      children: [
                        const Text('0'),
                        Text(
                          'posts',
                          style: TextStyles.subtitleStyle,
                        ),
                      ],
                    ),
                  ),
                  const VerticalDivider(
                    width: 1,
                    thickness: 1,
                    color: Color.fromRGBO(80, 80, 80, 0.3),
                  ),
                  SizedBox(
                    width: 100,
                    child: Column(
                      children: [
                        const Text('0'),
                        Text(
                          'followers',
                          style: TextStyles.subtitleStyle,
                        ),
                      ],
                    ),
                  ),
                  const VerticalDivider(
                    width: 1,
                    thickness: 1,
                    color: Color.fromRGBO(80, 80, 80, 0.3),
                  ),
                  SizedBox(
                    width: 100,
                    child: Column(
                      children: [
                        const Text('0'),
                        Text(
                          'following',
                          style: TextStyles.subtitleStyle,
                        ),
                      ],
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
