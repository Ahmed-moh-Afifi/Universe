import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:universe/blocs/home_bloc.dart';
import 'package:universe/route_generator.dart';
import 'package:universe/routes/new_post.dart';
import 'package:universe/widgets/universe_appbar.dart';

class HomePage extends StatelessWidget {
  final bloc = HomeBloc();
  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeBloc>(
      create: (context) => bloc,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        extendBody: true,
        body: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Navigator(
              initialRoute: RouteGenerator.feed,
              onGenerateRoute: RouteGenerator.generateRoute,
              key: RouteGenerator.homeNavigatorKey,
            ),
          ),
        ),
        // floatingActionButton: BlocBuilder<HomeBloc, HomeState>(
        //   builder: (context, state) => state.floatingActionButtonVisible
        //       ? FloatingActionButton(
        //           shape: const CircleBorder(),
        //           onPressed: () => showModalBottomSheet(
        //             context: context,
        //             builder: (context) => Padding(
        //               padding: EdgeInsets.only(
        //                   bottom: MediaQuery.of(context).viewInsets.bottom),
        //               child: const NewPost(),
        //             ),
        //             enableDrag: true,
        //             showDragHandle: true,
        //             isScrollControlled: true,
        //           ),
        //           // onPressed: () =>
        //           //     bloc.add(const Navigate(RouteGenerator.newPost)),
        //           child: SvgPicture.asset(
        //             state.newPostIcon,
        //             colorFilter:
        //                 const ColorFilter.mode(Colors.black, BlendMode.srcIn),
        //           ),
        //         )
        //       : const SizedBox(
        //           width: 65,
        //           height: 65,
        //         ),
        // ),
        // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) => Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
            margin: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: UniverseBottomAppBar(
                color: Colors.transparent,
                positionInHorizontal: -20.0,
                notchMargin: 0,
                height: 80,
                shape: const CircularNotchedRectangle(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: SvgPicture.asset(
                        state.homeIcon,
                        colorFilter: const ColorFilter.mode(
                            Colors.white, BlendMode.srcIn),
                      ),
                      onPressed: () =>
                          bloc.add(const Navigate(RouteGenerator.feed)),
                    ),
                    IconButton(
                      icon: SvgPicture.asset(
                        state.searchIcon,
                        colorFilter: const ColorFilter.mode(
                            Colors.white, BlendMode.srcIn),
                      ),
                      onPressed: () =>
                          bloc.add(const Navigate(RouteGenerator.search)),
                    ),
                    IconButton(
                      onPressed: () => showModalBottomSheet(
                        context: context,
                        builder: (context) =>
                            LayoutBuilder(builder: (context, constraints) {
                          return SizedBox(
                            height: constraints.maxHeight * 0.9,
                            child: const NewPost(),
                          );
                        }),
                        enableDrag: true,
                        showDragHandle: true,
                        isScrollControlled: true,
                      ),
                      // onPressed: () =>
                      //     bloc.add(const Navigate(RouteGenerator.newPost)),
                      icon: SvgPicture.asset(
                        state.newPostIcon,
                        colorFilter: const ColorFilter.mode(
                            Colors.white, BlendMode.srcIn),
                      ),
                    ),
                    IconButton(
                      icon: SvgPicture.asset(
                        state.messagesIcon,
                        colorFilter: const ColorFilter.mode(
                            Colors.white, BlendMode.srcIn),
                      ),
                      onPressed: () =>
                          bloc.add(const Navigate(RouteGenerator.messages)),
                    ),
                    IconButton(
                      icon: SvgPicture.asset(
                        state.profileIcon,
                        colorFilter: const ColorFilter.mode(
                            Colors.white, BlendMode.srcIn),
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
      ),
    );
  }
}
