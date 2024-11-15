import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:universe/extensions/date_time_extensions.dart';
import 'package:universe/repositories/posts_repository.dart';
import 'package:universe/ui/blocs/post_bloc.dart';
import 'package:universe/models/data/post.dart';
import 'package:universe/models/data/user.dart';
import 'package:universe/route_generator.dart';
import 'package:universe/ui/styles/text_styles.dart';
import 'package:universe/ui/widgets/expandable_image.dart';
import 'package:universe/ui/widgets/user_presenter.dart';

class PostWidget extends StatelessWidget {
  final Post post;
  final User user;
  final bool showFollowButton;

  const PostWidget({
    required this.post,
    required this.user,
    this.showFollowButton = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => PostsRepository(),
      child: BlocProvider<PostBloc>(
          create: (context) =>
              PostBloc(RepositoryProvider.of<PostsRepository>(context), post),
          child: PostContent(post: post, user: user)),
    );
  }
}

class PostContent extends StatelessWidget {
  final Post post;
  final User user;
  final bool showFollowButton;

  const PostContent({
    required this.post,
    required this.user,
    this.showFollowButton = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(left: 0, right: 0),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
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
            post.images.isNotEmpty
                ? Container(
                    margin: const EdgeInsets.only(top: 10, bottom: 10),
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: SizedBox(
                      height: 200,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: post.images.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: const EdgeInsets.only(right: 10),
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ExpandableImage(
                              post.images[index],
                              post.id.toString() + index.toString(),
                            ),
                          );
                        },
                      ),
                    ),
                  )
                : Container(),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                post.publishDate.toEnglishString(),
                style: TextStyles.subtitleStyle,
              ),
            ),
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
                              color: state.isLiked
                                  ? const Color.fromRGBO(255, 150, 150, 0.2)
                                  : Theme.of(context).colorScheme.secondary,
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 15),
                                  child: GestureDetector(
                                    onTap: () {
                                      BlocProvider.of<PostBloc>(context)
                                          .add(LikeClicked(false));
                                    },
                                    child: state.isLiked
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
                                              Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                              BlendMode.srcIn,
                                            ),
                                          ),
                                  ),
                                ),
                                Text(
                                  (state.reactionsCount).toString(),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
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
                                  padding:
                                      const EdgeInsets.only(right: 0, left: 0),
                                  child: SvgPicture.asset(
                                    'lib/assets/icons/share.svg',
                                    colorFilter: ColorFilter.mode(
                                      Theme.of(context).colorScheme.primary,
                                      BlendMode.srcIn,
                                    ),
                                  ),
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
                                  padding:
                                      const EdgeInsets.only(right: 0, left: 0),
                                  child: SvgPicture.asset(
                                    'lib/assets/icons/save.svg',
                                    colorFilter: ColorFilter.mode(
                                      Theme.of(context).colorScheme.primary,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
