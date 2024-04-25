import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:universe/blocs/followers_bloc.dart';
import 'package:universe/models/user.dart';
import 'package:universe/route_generator.dart';
import 'package:universe/widgets/user_presenter.dart';

class FollowersPage extends StatelessWidget {
  final User user;
  final FollowersBloc bloc;
  FollowersPage(this.user, {super.key}) : bloc = FollowersBloc(user);

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
                barrierDismissible: false,
                context: context,
                builder: (context) => const PopScope(
                  canPop: false,
                  child: Center(
                    child: CircularProgressIndicator(),
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
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text("Error"),
                  content: Text(state.error!),
                ),
              );
            }
          },
          child: BlocBuilder<FollowersBloc, FollowersState>(
            bloc: bloc,
            builder: (context, state) => Padding(
              padding: const EdgeInsets.only(left: 0, right: 0, top: 20),
              child: ListView.separated(
                itemBuilder: (context, index) {
                  return UserPresenter(user: state.followers[index].user);
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
