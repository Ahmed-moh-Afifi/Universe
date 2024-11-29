import 'package:flutter/material.dart';
import 'package:universe/models/data/post.dart';
import 'package:universe/models/data/user.dart';
import 'package:universe/ui/widgets/post.dart';

class UserPostsViewer extends StatelessWidget {
  final User user;
  final List<Post> postsList;
  UserPostsViewer(this.user, Iterable<Post> posts, {super.key})
      : postsList = posts.toList();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) => PostWidget(
        post: postsList[index],
        user: user,
        showFollowButton: false,
      ),
      separatorBuilder: (context, index) => const Divider(
        indent: 0,
        endIndent: 0,
        color: Color.fromRGBO(80, 80, 80, 0),
      ),
      itemCount: postsList.length,
    );
  }
}
