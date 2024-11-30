import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:universe/repositories/posts_repository.dart';
import 'package:universe/repositories/users_repository.dart';
import 'package:universe/ui/blocs/personal_profile_bloc.dart';
import 'package:universe/repositories/authentication_repository.dart';
import 'package:universe/route_generator.dart';
import 'package:universe/ui/styles/text_styles.dart';
import 'package:universe/ui/widgets/post.dart';
import 'package:universe/ui/widgets/profile_card.dart';

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
        child: SafeArea(
          bottom: false,
          top: false,
          child: Scaffold(
            body: CustomScrollView(
              slivers: [
                SliverAppBar(
                  floating: true,
                  expandedHeight: 125,
                  actions: [
                    IconButton(
                      onPressed: () {},
                      icon: SvgPicture.asset(
                        'lib/assets/icons/save.svg',
                        colorFilter: ColorFilter.mode(
                            Theme.of(context).colorScheme.primary,
                            BlendMode.srcIn),
                      ),
                    ),
                    IconButton(
                      onPressed: () => RouteGenerator
                          .mainNavigatorkey.currentState!
                          .pushNamed(
                        RouteGenerator.settingsPage,
                      ),
                      icon: SvgPicture.asset(
                        'lib/assets/icons/settings.svg',
                        colorFilter: ColorFilter.mode(
                            Theme.of(context).colorScheme.primary,
                            BlendMode.srcIn),
                      ),
                    ),
                  ],
                  flexibleSpace: FlexibleSpaceBar(
                    expandedTitleScale: 1.3,
                    titlePadding:
                        EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                    title: Text(
                      'Profile',
                      style: TextStyles.titleStyle,
                    ),
                    background: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [],
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => index == 0
                        ? Padding(
                            padding: const EdgeInsets.only(
                                bottom: 10, left: 16, right: 16),
                            child: ProfileCard(
                              AuthenticationRepository()
                                  .authenticationService
                                  .currentUser()!,
                              state.postCount,
                              state.followersCount,
                              state.followingCount,
                            ),
                          )
                        : index == state.posts.length + 1
                            ? SizedBox(
                                height: 100,
                              )
                            : Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 16),
                                child: PostWidget(
                                  post: state.posts.elementAt(index - 1),
                                  user: state.user,
                                  showFollowButton: false,
                                ),
                              ),
                    childCount: state.posts.length + 2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
