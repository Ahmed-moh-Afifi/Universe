import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:universe/blocs/post_bloc.dart';
import 'package:universe/models/post.dart';
import 'package:universe/models/user.dart';
import 'package:universe/widgets/user_presenter.dart';

class PostWidget extends StatelessWidget {
  final Post post;
  final User user;
  final PostBloc bloc;
  final bool showFollowButton;
  PostWidget({
    required this.post,
    required this.user,
    this.showFollowButton = true,
    super.key,
  }) : bloc = PostBloc(post);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
      child: BlocProvider<PostBloc>(
        create: (context) => bloc,
        child: BlocBuilder<PostBloc, PostState>(
          builder: (context, state) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              UserPresenter(
                user: user,
                margin: const EdgeInsets.only(top: 10, bottom: 10),
                contentPadding: const EdgeInsets.all(0),
                showFollowButton: showFollowButton,
              ),
              Text(post.body),
              Row(
                children: [
                  IconButton(
                    onPressed: () => bloc.add(LikeClicked(false)),
                    icon: const Icon(Icons.thumb_up_rounded),
                  ),
                  Text(state.reactionsCount.toString()),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
