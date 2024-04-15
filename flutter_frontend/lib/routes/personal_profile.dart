import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:universe/blocs/personal_profile_bloc.dart';
import 'package:universe/repositories/authentication_repository.dart';
import 'package:universe/styles/text_styles.dart';
import 'package:universe/widgets/profile_card.dart';
import 'package:universe/widgets/user_posts_viewer.dart';

class PersonalProfile extends StatelessWidget {
  final PersonalProfileBloc bloc = PersonalProfileBloc();
  PersonalProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: BlocProvider<PersonalProfileBloc>(
        create: (context) => bloc,
        child: BlocBuilder<PersonalProfileBloc, PersonalProfileState>(
          builder: (context, state) => SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20, top: 2),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Profile',
                      style: TextStyles.titleStyle,
                    ),
                  ),
                ),
                ProfileCard(AuthenticationRepository()
                    .authenticationService
                    .getUser()!),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: UserPostsViewer(AuthenticationRepository()
                      .authenticationService
                      .getUser()!),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}