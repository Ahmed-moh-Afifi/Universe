import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:universe/blocs/personal_profile_bloc.dart';
import 'package:universe/repositories/authentication_repository.dart';
import 'package:universe/styles/text_styles.dart';
import 'package:universe/widgets/profile_card.dart';
import 'package:universe/widgets/user_posts_viewer.dart';

class PersonalProfile extends StatelessWidget {
  final PersonalProfileBloc bloc;
  PersonalProfile({super.key}) : bloc = PersonalProfileBloc();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PersonalProfileBloc>(
      create: (context) => bloc,
      child: BlocBuilder<PersonalProfileBloc, PersonalProfileState>(
        builder: (context, state) => RefreshIndicator(
          onRefresh: () {
            return bloc.getUserData();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 0, top: 2),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Profile',
                        style: TextStyles.titleStyle,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: ProfileCard(
                      AuthenticationRepository()
                          .authenticationService
                          .getUser()!,
                      state.postCount,
                      state.followersCount,
                      state.followingCount,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: UserPostsViewer(state.user, state.posts),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}