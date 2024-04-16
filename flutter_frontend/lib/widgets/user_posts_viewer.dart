import 'package:flutter/material.dart';
import 'package:universe/models/post.dart';
import 'package:universe/models/user.dart';
import 'package:universe/widgets/post.dart';

class UserPostsViewer extends StatelessWidget {
  final User user;
  final Iterable<Post> posts;
  const UserPostsViewer(this.user, this.posts, {super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) => PostWidget(
        post: posts.elementAt(index),
        user: user,
        showFollowButton: false,
      ),
      separatorBuilder: (context, index) => const Divider(
        indent: 0,
        endIndent: 0,
        color: Color.fromRGBO(80, 80, 80, 0.3),
      ),
      itemCount: posts.length,
    );
  }
}
