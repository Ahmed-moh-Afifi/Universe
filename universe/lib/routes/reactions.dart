import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:universe/blocs/reactions_bloc.dart';
import 'package:universe/models/post.dart';
import 'package:universe/route_generator.dart';
import 'package:universe/widgets/user_presenter.dart';

class Reactions extends StatelessWidget {
  final Post post;
  final ReactionsBloc bloc;

  Reactions({required this.post, super.key}) : bloc = ReactionsBloc(post);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => bloc,
      child: BlocConsumer<ReactionsBloc, ReactionsState>(
        listener: (context, state) {
          if (state.state == ReactionsStates.loading) {
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

          if ((state.state == ReactionsStates.loaded ||
                  state.state == ReactionsStates.failed) &&
              state.previousState == ReactionsStates.loading) {
            RouteGenerator.mainNavigatorkey.currentState?.pop();
          }

          if (state.state == ReactionsStates.failed) {
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
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Reactions'),
            ),
            body: state.state == ReactionsStates.loaded
                ? ListView.separated(
                    itemBuilder: (context, index) =>
                        UserPresenter(user: state.reactions![index].user!),
                    separatorBuilder: (context, index) =>
                        const Divider(color: Color.fromRGBO(80, 80, 80, 0.3)),
                    itemCount: state.reactions!.length)
                : Container(),
          );
        },
      ),
    );
  }
}
