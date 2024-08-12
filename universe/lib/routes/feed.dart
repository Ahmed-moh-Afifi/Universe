import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:universe/blocs/feed_bloc.dart';
import 'package:universe/repositories/posts_repository.dart';
import 'package:universe/widgets/post.dart';

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
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Feed'),
          ),
          body: const FeedContent(),
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
              color: Color.fromRGBO(80, 80, 80, 0.3),
            ),
            itemCount: state is FeedLoaded ? state.posts.length : 0,
          ),
        );
      },
      listener: (context, state) {},
    );
  }
}
