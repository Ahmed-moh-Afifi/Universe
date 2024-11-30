import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:universe/extensions/date_time_extensions.dart';
import 'package:universe/models/data/post.dart';
import 'package:universe/repositories/posts_repository.dart';
import 'package:universe/ui/blocs/post_bloc.dart';
import 'package:universe/ui/styles/text_styles.dart';
import 'package:universe/ui/widgets/expandable_image.dart';
import 'package:universe/ui/widgets/user_presenter.dart';

class SharedPostWidget extends StatelessWidget {
  final Post post;

  const SharedPostWidget({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.secondary),
        borderRadius: BorderRadius.circular(20),
      ),
      child: SharedPostContentWidget(
        post: post,
      ),
    );
  }
}

class SharedPostContentWidget extends StatelessWidget {
  final Post post;

  const SharedPostContentWidget({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(left: 0, right: 0),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
      child: Container(
        padding: const EdgeInsets.only(left: 10, right: 10, top: 0, bottom: 10),
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UserPresenter(
              user: post.author,
              margin: const EdgeInsets.only(top: 0, bottom: 10),
              contentPadding: const EdgeInsets.all(0),
              showFollowButton: false,
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
                      height: 150,
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
                            ),
                          );
                        },
                      ),
                    ),
                  )
                : Container(),
            BlocProvider(
              create: (context) => PostBloc(PostsRepository(), post),
              child: SharedPostBottomRow(
                post: post,
              ),
            ),
          ],
        ),
      ),
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
                post.reactedToByCaller
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
                    (post.reactionsCount).toString(),
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
