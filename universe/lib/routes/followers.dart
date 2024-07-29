import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:universe/apis/users_data_provider.dart';
import 'package:universe/blocs/followers_bloc.dart';
import 'package:universe/models/user.dart';
import 'package:universe/route_generator.dart';
import 'package:universe/widgets/user_presenter.dart';

class FollowersPage extends StatelessWidget {
  final User user;
  final FollowersBloc bloc;
  FollowersPage(this.user, {super.key})
      : bloc = FollowersBloc(UsersDataProvider(), user);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Followers'),
      ),
      body: BlocProvider<FollowersBloc>(
        create: (context) => bloc,
        child: BlocListener<FollowersBloc, FollowersState>(
          listener: (context, state) {
            if (state.state == FollowersStates.loading) {
              showDialog(
                barrierColor: const Color.fromRGBO(255, 255, 255, 0.05),
                barrierDismissible: false,
                context: context,
                builder: (context) => PopScope(
                  canPop: false,
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ),
              );
            }

            if ((state.state == FollowersStates.success ||
                    state.state == FollowersStates.failed) &&
                state.previousState == FollowersStates.loading) {
              RouteGenerator.mainNavigatorkey.currentState?.pop();
            }

            if (state.state == FollowersStates.failed) {
              showDialog(
                barrierColor: const Color.fromRGBO(255, 255, 255, 0.05),
                context: context,
                builder: (context) => BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  child: AlertDialog(
                    title: const Text("Error"),
                    content: Text(state.error!),
                  ),
                ),
              );
            }
          },
          child: BlocBuilder<FollowersBloc, FollowersState>(
            builder: (context, state) => Padding(
              padding: const EdgeInsets.only(left: 0, right: 0, top: 20),
              child: ListView.separated(
                itemBuilder: (context, index) {
                  return UserPresenter(user: state.followers[index]);
                },
                separatorBuilder: (context, index) => const Divider(
                  color: Color.fromRGBO(80, 80, 80, 0.3),
                ),
                itemCount: state.followers.length,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
