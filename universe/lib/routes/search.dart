import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:universe/blocs/search_bloc.dart';
import 'package:universe/repositories/users_repository.dart';
import 'package:universe/route_generator.dart';
import 'package:universe/styles/text_styles.dart';
import 'package:universe/widgets/user_presenter.dart';

class Search extends StatelessWidget {
  final SearchBloc bloc;
  Search({super.key}) : bloc = SearchBloc(UsersRepository());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Search',
          style: TextStyles.titleStyle,
        ),
      ),
      body: RepositoryProvider(
        create: (context) => UsersRepository(),
        child: BlocProvider(
          create: (context) =>
              SearchBloc(RepositoryProvider.of<UsersRepository>(context)),
          child: const SearchContent(),
        ),
      ),
    );
  }
}

class SearchContent extends StatelessWidget {
  const SearchContent({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController searchController = TextEditingController();

    return SingleChildScrollView(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Text(
          //   'Search',
          //   style: TextStyles.titleStyle,
          // ),
          TextField(
            onSubmitted: (value) => BlocProvider.of<SearchBloc>(context)
                .add(SearchEvent(searchController.text)),
            controller: searchController,
            decoration: InputDecoration(
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(20),
                ),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Theme.of(context).colorScheme.secondary,
              hintText: 'Search',
            ),
          ),
          BlocListener<SearchBloc, SearchState>(
            listener: (context, state) {
              RouteGenerator.searchState = state;
              if (state.state == SearchStates.loading) {
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

              if ((state.state == SearchStates.loaded ||
                      state.state == SearchStates.failed) &&
                  state.previousState == SearchStates.loading) {
                RouteGenerator.mainNavigatorkey.currentState?.pop();
              }

              if (state.state == SearchStates.failed) {
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
            child: BlocBuilder<SearchBloc, SearchState>(
              builder: (context, state) {
                return state.data != null
                    ? ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: state.data!.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) => UserPresenter(
                          user: state.data!.elementAt(index),
                          margin: const EdgeInsets.only(top: 10, bottom: 10),
                          contentPadding: const EdgeInsets.all(10),
                        ),
                      )
                    : Container();
              },
            ),
          )
        ],
      ),
    );
  }
}
