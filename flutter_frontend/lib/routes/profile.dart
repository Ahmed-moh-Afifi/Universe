import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:universe/blocs/profile_bloc.dart';
import 'package:universe/models/user.dart';
import 'package:universe/widgets/follow_button.dart';
import 'package:universe/widgets/profile_card.dart';
import 'package:universe/widgets/user_posts_viewer.dart';

class Profile extends StatelessWidget {
  final User user;
  final ProfileBloc bloc;

  Profile(this.user, {super.key}) : bloc = ProfileBloc(user);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Container(
            padding: const EdgeInsets.only(left: 20, right: 20),
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
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
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
