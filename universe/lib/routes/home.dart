import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:universe/blocs/home_bloc.dart';
import 'package:universe/route_generator.dart';
import 'package:universe/routes/feed.dart';
import 'package:universe/routes/messages.dart';
import 'package:universe/routes/new_post.dart';
import 'package:universe/routes/personal_profile.dart';
import 'package:universe/routes/search.dart';
import 'package:universe/widgets/universe_appbar.dart';

class HomePage extends StatelessWidget {
  final HomeBloc bloc;
  HomePage({super.key}) : bloc = HomeBloc();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeBloc>(
      create: (context) => bloc,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        extendBody: true,
        body: SafeArea(
          bottom: false,
          top: false,
          child: Padding(
              padding: const EdgeInsets.only(top: 0),
              child: PageView(
                onPageChanged: (value) {
                  switch (value) {
                    case 0:
                      bloc.add(const ChangeIcon(RouteGenerator.feed));
                      break;
                    case 1:
                      bloc.add(const ChangeIcon(RouteGenerator.search));
                      break;
                    case 2:
                      bloc.add(const ChangeIcon(RouteGenerator.messages));
                      break;
                    case 3:
                      bloc.add(
                          const ChangeIcon(RouteGenerator.personalProfile));
                      break;
                    default:
                  }
                },
                controller: bloc.pageController,
                children: [
                  const Feed(),
                  Search(),
                  const Messages(),
                  PersonalProfile(),
                ],
              )
              // Navigator(
              //   initialRoute: RouteGenerator.feed,
              //   onGenerateRoute: RouteGenerator.generateRoute,
              //   key: RouteGenerator.homeNavigatorKey,
              // ),
              ),
        ),
        bottomNavigationBar: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) => Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(50)),
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
                        colorFilter: ColorFilter.mode(
                            Theme.of(context).primaryIconTheme.color!,
                            BlendMode.srcIn),
                      ),
                      onPressed: () =>
                          bloc.add(const Navigate(RouteGenerator.feed)),
                    ),
                    IconButton(
                      icon: SvgPicture.asset(
                        state.searchIcon,
                        colorFilter: ColorFilter.mode(
                            Theme.of(context).primaryIconTheme.color!,
                            BlendMode.srcIn),
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
                            height: constraints.maxHeight,
                            child: NewPost(),
                          );
                        }),
                        enableDrag: true,
                        useSafeArea: true,
                        showDragHandle: true,
                        isScrollControlled: true,
                      ),
                      icon: SvgPicture.asset(
                        state.newPostIcon,
                        colorFilter: ColorFilter.mode(
                            Theme.of(context).primaryIconTheme.color!,
                            BlendMode.srcIn),
                      ),
                    ),
                    IconButton(
                      icon: SvgPicture.asset(
                        state.messagesIcon,
                        colorFilter: ColorFilter.mode(
                            Theme.of(context).primaryIconTheme.color!,
                            BlendMode.srcIn),
                      ),
                      onPressed: () =>
                          bloc.add(const Navigate(RouteGenerator.messages)),
                    ),
                    IconButton(
                      icon: SvgPicture.asset(
                        state.profileIcon,
                        colorFilter: ColorFilter.mode(
                            Theme.of(context).primaryIconTheme.color!,
                            BlendMode.srcIn),
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
