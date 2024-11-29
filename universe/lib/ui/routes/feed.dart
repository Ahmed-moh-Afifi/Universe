import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:universe/ui/blocs/feed_bloc.dart';
import 'package:universe/repositories/posts_repository.dart';
import 'package:universe/ui/widgets/post.dart';

class Feed extends StatelessWidget {
  const Feed({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => PostsRepository(),
      child: BlocProvider(
        create: (context) =>
            FeedBloc(RepositoryProvider.of<PostsRepository>(context))
              ..add(LoadFeed()),
        child: SafeArea(
          bottom: false,
          top: false,
          child: Scaffold(
            body: const FeedContent(),
          ),
        ),
      ),
    );
  }
}

class FeedContent extends StatelessWidget {
  const FeedContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FeedBloc, FeedState>(
      builder: (context, state) {
        return CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: Colors.transparent,
              surfaceTintColor: Colors.transparent,
              floating: true,
              toolbarHeight: 50,
              elevation: 0,
              flexibleSpace: FlexibleSpaceBar(
                background: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
                    child: Container(color: Colors.transparent)),
                titlePadding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.transparent,
                      backgroundImage: AssetImage(
                          'lib/assets/icons/universe_logo_transparent.png'),
                    ),
                    Text(
                      'Universe',
                      style: TextStyle(
                        fontFamily: "Pacifico",
                      ),
                    ),
                    // CircleAvatar(
                    //   radius: 15,
                    //   backgroundColor: Colors.transparent,
                    //   backgroundImage: CachedNetworkImageProvider(
                    //       AuthenticationRepository()
                    //               .authenticationService
                    //               .currentUser()!
                    //               .photoUrl ??
                    //           'https://via.placeholder.com/150'),
                    // ),
                    IconButton(
                      icon: SvgPicture.asset(
                        'lib/assets/icons/bell.svg',
                        colorFilter: ColorFilter.mode(
                            Theme.of(context).colorScheme.primary,
                            BlendMode.srcIn),
                      ),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return state is FeedLoaded
                      ? Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 16),
                          child: index == 0
                              ? const SizedBox(
                                  height: 10,
                                )
                              : index == state.posts.length + 1
                                  ? const SizedBox(
                                      height: 100,
                                    )
                                  : PostWidget(
                                      post: state.posts[index - 1],
                                      user: state.posts[index - 1].author,
                                    ),
                        )
                      : const Center(child: CircularProgressIndicator());
                },
                childCount: state is FeedLoaded ? state.posts.length + 2 : 0,
              ),
            ),
          ],
        );
      },
      listener: (context, state) {},
    );
  }
}
