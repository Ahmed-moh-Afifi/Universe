import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:loading_btn/loading_btn.dart';
import 'package:universe/extensions/date_time_extensions.dart';
import 'package:universe/repositories/authentication_repository.dart';
import 'package:universe/repositories/posts_repository.dart';
import 'package:universe/ui/blocs/post_bloc.dart';
import 'package:universe/models/data/post.dart';
import 'package:universe/models/data/user.dart';
import 'package:universe/route_generator.dart';
import 'package:universe/ui/styles/text_styles.dart';
import 'package:universe/ui/widgets/expandable_image.dart';
import 'package:universe/ui/widgets/shared_post_widget.dart';
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
  final postController = TextEditingController();

  PostContent({
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
              user: user,
              margin: const EdgeInsets.only(top: 0, bottom: 10),
              contentPadding: const EdgeInsets.all(0),
              showFollowButton: showFollowButton,
            ),
            Text(post.body),
            post.childPostId != -1
                ? SharedPostWidget(postId: post.childPostId)
                : const SizedBox(width: 0, height: 0),
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
                        ExpandableItem(
                          Container(
                            padding: const EdgeInsets.only(
                                left: 10, right: 10, top: 5, bottom: 5),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.secondary,
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(right: 0, left: 0),
                              child: SvgPicture.asset(
                                'lib/assets/icons/share.svg',
                                colorFilter: ColorFilter.mode(
                                  Theme.of(context).colorScheme.primary,
                                  BlendMode.srcIn,
                                ),
                              ),
                            ),
                          ),
                          Material(
                            color: Colors.transparent,
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.8,
                              height: MediaQuery.of(context).size.height * 0.5,
                              padding: const EdgeInsets.only(
                                  left: 10, right: 10, top: 5, bottom: 5),
                              decoration: BoxDecoration(
                                color: Color.fromRGBO(30, 30, 30, 1),
                                borderRadius: BorderRadius.circular(25),
                                border: Border.all(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                              ),
                              child: SingleChildScrollView(
                                child: Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 10),
                                        child: SizedBox(
                                          height: 300,
                                          child: TextField(
                                            expands: true,
                                            maxLines: null,
                                            minLines: null,
                                            controller: postController,
                                            textAlignVertical:
                                                TextAlignVertical.top,
                                            decoration: InputDecoration(
                                              border: const OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(20),
                                                ),
                                                borderSide: BorderSide.none,
                                              ),
                                              filled: true,
                                              fillColor: Theme.of(context)
                                                  .colorScheme
                                                  .secondary,
                                              hintText: "What's on your mind?",
                                            ),
                                          ),
                                        ),
                                      ),
                                      LoadingBtn(
                                        height: 66,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        borderRadius: 10,
                                        animate: true,
                                        loader: Container(
                                          padding: const EdgeInsets.all(10),
                                          child: const Center(
                                            child: SpinKitDoubleBounce(
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                        onTap: (startLoading, stopLoading,
                                            btnState) {
                                          if (btnState == ButtonState.idle &&
                                              state.state !=
                                                  PostStates.loading) {
                                            startLoading();
                                            BlocProvider.of<PostBloc>(context)
                                                .add(
                                              ShareClicked(
                                                Post(
                                                  title: '',
                                                  body: postController.text,
                                                  author:
                                                      AuthenticationRepository()
                                                          .authenticationService
                                                          .currentUser()!,
                                                  images: [],
                                                  videos: [],
                                                  audios: [],
                                                  widgets: [],
                                                  replyToPost: -1,
                                                  childPostId: -1,
                                                  publishDate: DateTime.now(),
                                                  reactionsCount: 0,
                                                  repliesCount: 0,
                                                  reactedToByCaller: false,
                                                ),
                                                stopLoading,
                                              ),
                                            );
                                          }
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            state.state == PostStates.loading
                                                ? Center(
                                                    child: SizedBox(
                                                      width: 30,
                                                      height: 30,
                                                      child:
                                                          CircularProgressIndicator(
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .secondary,
                                                      ),
                                                    ),
                                                  )
                                                : SvgPicture.asset(
                                                    'lib/assets/icons/share.svg',
                                                    colorFilter:
                                                        ColorFilter.mode(
                                                            Theme.of(context)
                                                                .primaryColor,
                                                            BlendMode.srcIn),
                                                  ),
                                            const Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Text('Share'),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
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
