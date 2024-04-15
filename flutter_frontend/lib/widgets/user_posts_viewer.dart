import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:universe/blocs/user_posts_viewer_bloc.dart';
import 'package:universe/models/user.dart';
import 'package:universe/widgets/post.dart';

class UserPostsViewer extends StatelessWidget {
  final UserPostsViewerBloc bloc;
  final User user;
  UserPostsViewer(this.user, {super.key}) : bloc = UserPostsViewerBloc(user);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<UserPostsViewerBloc>(
      create: (context) => bloc,
      child: BlocBuilder<UserPostsViewerBloc, UserPostsViewerState>(
        builder: (context, state) => ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            if (state.state == UserPostsViewerStates.success &&
                state.response != null) {
              return PostWidget(
                post: state.response!.posts.elementAt(index),
                user: user,
                showFollowButton: false,
              );
            }
            return Container();
          },
          separatorBuilder: (context, index) => const Divider(
            indent: 0,
            endIndent: 0,
            color: Color.fromRGBO(80, 80, 80, 0.3),
          ),
          itemCount: state.response == null ? 0 : state.response!.posts.length,
        ),
      ),
    );
  }
}
