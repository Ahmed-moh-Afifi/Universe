import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:universe/blocs/followers_bloc.dart';

class FollowersPage extends StatelessWidget {
  final FollowersBloc bloc = FollowersBloc();
  FollowersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Followers'),
      ),
      body: BlocBuilder<FollowersBloc, FollowersState>(
        bloc: bloc,
        builder: (context, state) => ListView.separated(
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(state.followers[index].user.userName),
            );
          },
          separatorBuilder: (context, index) => const Divider(),
          itemCount: state.followers.length,
        ),
      ),
    );
  }
}
