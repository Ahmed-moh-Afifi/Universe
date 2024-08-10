import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:universe/blocs/post_bloc.dart';
import 'package:universe/extensions/date_time_extensions.dart';
import 'package:universe/models/data/post.dart';
import 'package:universe/models/data/user.dart';
import 'package:universe/repositories/authentication_repository.dart';
import 'package:universe/route_generator.dart';
import 'package:universe/styles/text_styles.dart';
import 'package:universe/widgets/user_presenter.dart';

class PostWidget extends StatelessWidget {
  final Post post;
  final User user;
  final bool showFollowButton;
  final PostBloc bloc;

  PostWidget({
    required this.post,
    required this.user,
    this.showFollowButton = true,
    super.key,
  }) : bloc = PostBloc(
          PostsDataProvider(
            AuthenticationRepository().authenticationService.currentUser()!.id,
          ),
          post,
        );

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 0, right: 0),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
      child: BlocProvider<PostBloc>(
        create: (context) => bloc,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UserPresenter(
              user: user,
              margin: const EdgeInsets.only(top: 10, bottom: 10),
              contentPadding: const EdgeInsets.all(0),
              showFollowButton: showFollowButton,
            ),
            Text(post.body),
            BlocBuilder<PostBloc, PostState>(
              builder: (context, state) => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          bloc.add(LikeClicked(false));
                        },
                        icon: state.reaction != null
                            ? SvgPicture.asset(
                                'lib/assets/icons/heartFilled.svg',
                                colorFilter: const ColorFilter.mode(
                                  Colors.red,
                                  BlendMode.srcIn,
                                ),
                              )
                            : SvgPicture.asset(
                                'lib/assets/icons/heart.svg',
                                colorFilter: ColorFilter.mode(
                                  Theme.of(context).colorScheme.secondary,
                                  BlendMode.srcIn,
                                ),
                              ),
                      ),
                      GestureDetector(
                        child: Text(
                          (state.reactionsCount ?? '').toString(),
                          style: TextStyles.subtitleStyle,
                        ),
                        onTap: () => RouteGenerator
                            .mainNavigatorkey.currentState!
                            .pushNamed(
                          RouteGenerator.reactionsPage,
                          arguments: post,
                        ),
                      ),
                      GestureDetector(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: SvgPicture.asset(
                            'lib/assets/icons/reply.svg',
                            colorFilter: ColorFilter.mode(
                              Theme.of(context).colorScheme.secondary,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                        onTap: () => RouteGenerator
                            .mainNavigatorkey.currentState!
                            .pushNamed(
                          RouteGenerator.repliesPage,
                          arguments: [post, user],
                        ),
                      ),
                    ],
                  ),
                  Text(
                    post.publishDate.toEnglishString(),
                    style: TextStyles.subtitleStyle,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
