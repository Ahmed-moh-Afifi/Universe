import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:universe/repositories/authentication_repository.dart';
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
          child: Scaffold(
            appBar: AppBar(
              toolbarHeight: 115,
              elevation: 0,
              flexibleSpace: Padding(
                padding:
                    const EdgeInsets.only(top: 0.0, left: 16.0, right: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // const CircleAvatar(
                        //   radius: 20,
                        //   backgroundColor: Colors.transparent,
                        //   backgroundImage:
                        //       AssetImage('lib/assets/icons/universe_logo.png'),
                        // ),
                        IconButton(
                          icon: CircleAvatar(
                            radius: 20,
                            backgroundImage: CachedNetworkImageProvider(
                                AuthenticationRepository()
                                    .authenticationService
                                    .currentUser()!
                                    .photoUrl!),
                          ),
                          onPressed: () {},
                        ),
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
                    const SizedBox(height: 10.0),
                    // Text(
                    //   'Universe',
                    //   style: TextStyles.hugeStyle,
                    // ),
                  ],
                ),
              ),
            ),
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
        return Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: ListView.separated(
            itemBuilder: (context, index) {
              return state is FeedLoaded
                  ? PostWidget(
                      post: state.posts[index],
                      user: state.posts[index].author,
                    )
                  : const Center(child: CircularProgressIndicator());
            },
            separatorBuilder: (context, index) => const Divider(
              indent: 0,
              endIndent: 0,
              color: Color.fromRGBO(80, 80, 80, 0),
            ),
            itemCount: state is FeedLoaded ? state.posts.length : 0,
          ),
        );
      },
      listener: (context, state) {},
    );
  }
}
