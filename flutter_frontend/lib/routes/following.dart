import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:universe/blocs/following_bloc.dart';
import 'package:universe/models/user.dart';
import 'package:universe/route_generator.dart';
import 'package:universe/widgets/user_presenter.dart';

class FollowingPage extends StatelessWidget {
  final User user;
  final FollowingBloc bloc;
  FollowingPage(this.user, {super.key}) : bloc = FollowingBloc(user);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Following'),
      ),
      body: BlocProvider<FollowingBloc>(
        create: (context) => bloc,
        child: BlocListener<FollowingBloc, FollowingState>(
          listener: (context, state) {
            if (state.state == FollowingStates.loading) {
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

            if ((state.state == FollowingStates.success ||
                    state.state == FollowingStates.failed) &&
                state.previousState == FollowingStates.loading) {
              RouteGenerator.mainNavigatorkey.currentState?.pop();
            }

            if (state.state == FollowingStates.failed) {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text("Error"),
                  content: Text(state.error!),
                ),
              );
            }
          },
          child: BlocBuilder<FollowingBloc, FollowingState>(
            bloc: bloc,
            builder: (context, state) => Padding(
              padding: const EdgeInsets.only(left: 0, right: 0, top: 20),
              child: ListView.separated(
                itemBuilder: (context, index) {
                  return UserPresenter(user: state.following[index].user);
                },
                separatorBuilder: (context, index) => const Divider(
                  color: Color.fromRGBO(80, 80, 80, 0.3),
                ),
                itemCount: state.following.length,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
