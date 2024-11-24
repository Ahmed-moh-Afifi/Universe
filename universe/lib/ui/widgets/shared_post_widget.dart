import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:universe/extensions/date_time_extensions.dart';
import 'package:universe/models/data/post.dart';
import 'package:universe/repositories/posts_repository.dart';
import 'package:universe/ui/blocs/post_bloc.dart';
import 'package:universe/ui/blocs/shared_post_bloc.dart';
import 'package:universe/ui/styles/text_styles.dart';
import 'package:universe/ui/widgets/expandable_image.dart';
import 'package:universe/ui/widgets/user_presenter.dart';

class SharedPostWidget extends StatelessWidget {
  final int postId;

  const SharedPostWidget({super.key, required this.postId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SharedPostBloc(PostsRepository(), postId),
      child: Container(
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).colorScheme.secondary),
          borderRadius: BorderRadius.circular(20),
        ),
        child: SharedPostContentWidget(postId: postId),
      ),
    );
  }
}

class SharedPostContentWidget extends StatelessWidget {
  final int postId;

  const SharedPostContentWidget({super.key, required this.postId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SharedPostBloc, SharedPostState>(
      builder: (context, state) {
        if (state.state == SharedPostStates.loading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (state.state == SharedPostStates.error) {
          return Center(
            child: Text(state.error!),
          );
        }

        if (state.state == SharedPostStates.loaded) {
          return Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.only(left: 0, right: 0),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
            child: Container(
              padding: const EdgeInsets.only(
                  left: 10, right: 10, top: 0, bottom: 10),
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  UserPresenter(
                    user: state.post!.author,
                    margin: const EdgeInsets.only(top: 0, bottom: 10),
                    contentPadding: const EdgeInsets.all(0),
                    showFollowButton: false,
                  ),
                  Text(state.post!.body),
                  state.post!.images.isNotEmpty
                      ? Container(
                          margin: const EdgeInsets.only(top: 10, bottom: 10),
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: SizedBox(
                            height: 150,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: state.post!.images.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  margin: const EdgeInsets.only(right: 10),
                                  clipBehavior: Clip.antiAlias,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: ExpandableImage(
                                    state.post!.images[index],
                                    state.post!.id.toString() +
                                        index.toString(),
                                  ),
                                );
                              },
                            ),
                          ),
                        )
                      : Container(),
                  BlocProvider(
                    create: (context) =>
                        PostBloc(PostsRepository(), state.post!),
                    child: SharedPostBottomRow(
                      post: state.post!,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return Container();
      },
    );
  }
}

class SharedPostBottomRow extends StatelessWidget {
  final Post post;

  const SharedPostBottomRow({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostBloc, PostState>(
      builder: (context, state) => Padding(
        padding: const EdgeInsets.only(top: 5, bottom: 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                state.isLiked
                    ? SvgPicture.asset(
                        width: 13,
                        height: 13,
                        'lib/assets/icons/heartFilled.svg',
                        colorFilter: const ColorFilter.mode(
                          Colors.red,
                          BlendMode.srcIn,
                        ),
                      )
                    : SvgPicture.asset(
                        width: 13,
                        height: 13,
                        'lib/assets/icons/heart.svg',
                        colorFilter: ColorFilter.mode(
                          Colors.grey,
                          BlendMode.srcIn,
                        ),
                      ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Text(
                    (state.reactionsCount).toString(),
                    style: TextStyles.subtitleStyle.copyWith(
                      fontSize: 9,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                SvgPicture.asset(
                  width: 13,
                  height: 13,
                  'lib/assets/icons/reply.svg',
                  colorFilter: ColorFilter.mode(
                    Colors.grey,
                    BlendMode.srcIn,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Text(
                    ('0').toString(),
                    style: TextStyles.subtitleStyle.copyWith(
                      fontSize: 9,
                    ),
                  ),
                ),
              ],
            ),
            Text(
              post.publishDate.toEnglishString(),
              style: TextStyles.subtitleStyle.copyWith(fontSize: 9),
            ),
          ],
        ),
      ),
    );
  }
}
