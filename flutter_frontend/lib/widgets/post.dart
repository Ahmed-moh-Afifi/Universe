import 'package:flutter/material.dart';
import 'package:universe/apis/firestore.dart';
import 'package:universe/blocs/post_bloc.dart';
import 'package:universe/models/post.dart';

class PostWidget extends StatelessWidget {
  final Post post;
  final PostBloc bloc;
  PostWidget({required this.post, super.key})
      : bloc = PostBloc(FirestoreDataProvider(), post);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(post.title),
          Text(post.body),
          Row(
            children: [
              // Text(post.likes.toString()),
              IconButton(
                onPressed: () => bloc.add(LikeClicked(false)),
                icon: const Icon(Icons.thumb_up_rounded),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
