import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:universe/ui/blocs/profile_bloc.dart';
import 'package:universe/models/data/user.dart';
import 'package:universe/repositories/posts_repository.dart';
import 'package:universe/repositories/users_repository.dart';
import 'package:universe/ui/widgets/follow_button.dart';
import 'package:universe/ui/widgets/profile_card.dart';
import 'package:universe/ui/widgets/user_posts_viewer.dart';

class Profile extends StatelessWidget {
  final ProfileBloc bloc;
  final User user;

  Profile(this.user, {super.key})
      : bloc = ProfileBloc(
          UsersRepository(),
          PostsRepository(),
          user,
        );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Container(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: FollowButton(user),
          ),
        ],
      ),
      body: SafeArea(
        child: BlocProvider<ProfileBloc>(
          create: (context) => bloc,
          child: BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, state) => RefreshIndicator(
              onRefresh: () => bloc.getUserData(),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ProfileCard(
                        user,
                        state.postCount,
                        state.followersCount,
                        state.followingCount,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: UserPostsViewer(user, state.posts),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}