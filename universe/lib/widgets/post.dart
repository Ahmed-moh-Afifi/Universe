import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:universe/blocs/post_bloc.dart';
import 'package:universe/blocs/reactions_bloc.dart';
import 'package:universe/extensions/date_time_extensions.dart';
import 'package:universe/models/data/post.dart';
import 'package:universe/models/data/user.dart';
import 'package:universe/repositories/posts_repository.dart';
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
          PostsRepository(),
          post,
        );

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 0, right: 0),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
      child: BlocProvider<PostBloc>(
        create: (context) => bloc,
        child: Container(
          padding: const EdgeInsets.all(10),
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(25),
          ),
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
                builder: (context, state) => Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              RouteGenerator.mainNavigatorkey.currentState!
                                  .pushNamed(
                                RouteGenerator.reactionsPage,
                                arguments: post,
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.only(
                                  left: 10, right: 10, top: 5, bottom: 5),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.secondary,
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 15),
                                    child: GestureDetector(
                                      onTap: () {
                                        bloc.add(LikeClicked(false));
                                      },
                                      child: state.reaction != null
                                          ? SvgPicture.asset(
                                              'lib/assets/icons/heartFilled.svg',
                                              colorFilter:
                                                  const ColorFilter.mode(
                                                Colors.red,
                                                BlendMode.srcIn,
                                              ),
                                            )
                                          : SvgPicture.asset(
                                              'lib/assets/icons/heart.svg',
                                              colorFilter: ColorFilter.mode(
                                                Theme.of(context)
                                                    .colorScheme
                                                    .primary,
                                                BlendMode.srcIn,
                                              ),
                                            ),
                                    ),
                                  ),
                                  Text(
                                    (state.reactionsCount ?? '').toString(),
                                    style: TextStyles.subtitleStyle,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          GestureDetector(
                            child: Container(
                              padding: const EdgeInsets.only(
                                  left: 10, right: 10, top: 5, bottom: 5),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.secondary,
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 15),
                                    child: SvgPicture.asset(
                                      'lib/assets/icons/reply.svg',
                                      colorFilter: ColorFilter.mode(
                                        Theme.of(context).colorScheme.primary,
                                        BlendMode.srcIn,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    ('0').toString(),
                                    style: TextStyles.subtitleStyle,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      // SvgPicture.asset(
                      //   'lib/assets/icons/share.svg',
                      //   colorFilter: ColorFilter.mode(
                      //     Theme.of(context).colorScheme.secondary,
                      //     BlendMode.srcIn,
                      //   ),
                      // ),
                      // SvgPicture.asset(
                      //   'lib/assets/icons/save.svg',
                      //   colorFilter: ColorFilter.mode(
                      //     Theme.of(context).colorScheme.secondary,
                      //     BlendMode.srcIn,
                      //   ),
                      // ),
                      Text(
                        post.publishDate.toEnglishString(),
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
    );
  }
}
