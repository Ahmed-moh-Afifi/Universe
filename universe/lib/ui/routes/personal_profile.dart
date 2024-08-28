import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:universe/repositories/posts_repository.dart';
import 'package:universe/repositories/users_repository.dart';
import 'package:universe/ui/blocs/personal_profile_bloc.dart';
import 'package:universe/repositories/authentication_repository.dart';
import 'package:universe/route_generator.dart';
import 'package:universe/ui/styles/text_styles.dart';
import 'package:universe/ui/widgets/profile_card.dart';
import 'package:universe/ui/widgets/user_posts_viewer.dart';

class PersonalProfile extends StatelessWidget {
  const PersonalProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(
          value: UsersRepository(),
        ),
        RepositoryProvider.value(
          value: PostsRepository(),
        ),
      ],
      child: BlocProvider<PersonalProfileBloc>(
        create: (context) => PersonalProfileBloc(
          RepositoryProvider.of<UsersRepository>(context),
          RepositoryProvider.of<PostsRepository>(context),
        ),
        child: const PersonalProfileContent(),
      ),
    );
  }
}

class PersonalProfileContent extends StatelessWidget {
  const PersonalProfileContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PersonalProfileBloc, PersonalProfileState>(
      builder: (context, state) => RefreshIndicator(
        onRefresh: () {
          return BlocProvider.of<PersonalProfileBloc>(context).getUserData();
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              'Profile',
              style: TextStyles.titleStyle,
            ),
            actions: [
              IconButton(
                onPressed: () {},
                icon: SvgPicture.asset(
                  'lib/assets/icons/bell.svg',
                  colorFilter: ColorFilter.mode(
                      Theme.of(context).colorScheme.primary, BlendMode.srcIn),
                ),
              ),
              IconButton(
                onPressed: () =>
                    RouteGenerator.mainNavigatorkey.currentState!.pushNamed(
                  RouteGenerator.settingsPage,
                ),
                icon: SvgPicture.asset(
                  'lib/assets/icons/settings.svg',
                  colorFilter: ColorFilter.mode(
                      Theme.of(context).colorScheme.primary, BlendMode.srcIn),
                ),
              ),
            ],
          ),
          body: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: ProfileCard(
                      AuthenticationRepository()
                          .authenticationService
                          .currentUser()!,
                      state.postCount,
                      state.followersCount,
                      state.followingCount,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20, bottom: 10),
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
