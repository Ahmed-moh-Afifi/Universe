import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:universe/blocs/home_bloc.dart';
import 'package:universe/repositories/authentication_repository.dart';
import 'package:universe/route_generator.dart';
import 'package:universe/widgets/post.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: () => RouteGenerator.key.currentState
                ?.pushNamed(RouteGenerator.followersPage),
            child: const Text('Followers'),
          ),
        ],
        toolbarHeight: 100,
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "Welcome,\n${AuthenticationRepository().authenticationService.getUser()!.userName}",
            style: const TextStyle(fontFamily: 'pacifico', fontSize: 30),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocProvider(
          create: (context) => HomeBloc(),
          child: BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
              if (state.state == HomeStates.error) {
                return ErrorWidget(state.error!);
              }

              if (state.state == HomeStates.loaded) {
                return Center(
                  child: ListView.separated(
                    itemCount: state.data!.length,
                    itemBuilder: (context, index) {
                      return PostWidget(post: state.data!.elementAt(index));
                      // return LanguageItem(state.data!.elementAt(index));
                    },
                    separatorBuilder: (context, index) => const Divider(
                      color: Color.fromRGBO(80, 80, 80, 0.5),
                    ),
                  ),
                );
              }

              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ),
      ),
    );
  }
}
