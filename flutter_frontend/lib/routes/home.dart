import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:universe/blocs/home_bloc.dart';
import 'package:universe/route_generator.dart';

class HomePage extends StatelessWidget {
  final bloc = HomeBloc();
  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeBloc>(
      create: (context) => bloc,
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          extendBody: true,
          body: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Navigator(
              initialRoute: RouteGenerator.feed,
              onGenerateRoute: RouteGenerator.generateRoute,
              key: RouteGenerator.homeNavigatorKey,
            ),
          ),
          floatingActionButton: BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) => state.floatingActionButtonVisible
                ? FloatingActionButton(
                    shape: const CircleBorder(),
                    onPressed: () =>
                        bloc.add(const Navigate(RouteGenerator.newPost)),
                    child: SvgPicture.asset(
                      state.newPostIcon,
                      colorFilter:
                          const ColorFilter.mode(Colors.black, BlendMode.srcIn),
                    ),
                  )
                : const SizedBox(
                    width: 65,
                    height: 65,
                  ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          bottomNavigationBar: BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) => BottomAppBar(
              notchMargin: 6,
              height: 60,
              shape: const CircularNotchedRectangle(),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: SvgPicture.asset(
                      state.homeIcon,
                      colorFilter:
                          const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                    ),
                    onPressed: () =>
                        bloc.add(const Navigate(RouteGenerator.feed)),
                  ),
                  IconButton(
                    icon: SvgPicture.asset(
                      state.searchIcon,
                      colorFilter:
                          const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                    ),
                    onPressed: () =>
                        bloc.add(const Navigate(RouteGenerator.search)),
                  ),
                  IconButton(
                    icon: SvgPicture.asset(
                      state.messagesIcon,
                      colorFilter:
                          const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                    ),
                    onPressed: () =>
                        bloc.add(const Navigate(RouteGenerator.messages)),
                  ),
                  IconButton(
                    icon: SvgPicture.asset(
                      state.profileIcon,
                      colorFilter:
                          const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                    ),
                    onPressed: () => bloc
                        .add(const Navigate(RouteGenerator.personalProfile)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
