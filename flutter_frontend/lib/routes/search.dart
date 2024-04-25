import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:universe/blocs/search_bloc.dart';
import 'package:universe/route_generator.dart';
import 'package:universe/styles/text_styles.dart';
import 'package:universe/widgets/user_presenter.dart';

class Search extends StatelessWidget {
  final SearchBloc bloc = SearchBloc(RouteGenerator.searchState);
  Search({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController searchController = TextEditingController();
    return BlocProvider<SearchBloc>(
      create: (context) => bloc,
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Search',
              style: TextStyles.titleStyle,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: TextField(
                onSubmitted: (value) =>
                    bloc.add(SearchEvent(searchController.text)),
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
            ),
            BlocListener<SearchBloc, SearchState>(
              listener: (context, state) {
                RouteGenerator.searchState = state;
                if (state.state == SearchStates.loading) {
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

                if ((state.state == SearchStates.loaded ||
                        state.state == SearchStates.failed) &&
                    state.previousState == SearchStates.loading) {
                  RouteGenerator.mainNavigatorkey.currentState?.pop();
                }

                if (state.state == SearchStates.failed) {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text("Error"),
                      content: Text(state.error!),
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
      ),
    );
  }
}
