import 'dart:developer';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:toastification/toastification.dart';
import 'package:universe/ui/blocs/home_bloc.dart';
import 'package:universe/route_generator.dart';
import 'package:universe/ui/blocs/notifications_bloc.dart';
import 'package:universe/ui/routes/new_post.dart';

class HomePage extends StatefulWidget {
  final HomeBloc bloc;

  HomePage({super.key}) : bloc = HomeBloc();

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late AnimationController pageViewAnimationController;

  @override
  void initState() {
    super.initState();
    pageViewAnimationController = AnimationController(vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NotificationsBloc(),
      child: BlocListener<NotificationsBloc, NotificationsState>(
        listener: (context, state) {
          if (state.state == NotificationsStates.notificationReceived) {
            log('Notification received: ${state.notification}',
                name: 'HomePage');
            toastification.show(
              title: const Text('Notification'),
              description: Text(state.notification!.body),
              autoCloseDuration: const Duration(seconds: 3),
              alignment: Alignment.topCenter,
              style: ToastificationStyle.flatColored,
              type: ToastificationType.success,
              dragToClose: true,
              dismissDirection: DismissDirection.vertical,
              applyBlurEffect: true,
              borderRadius: BorderRadius.circular(20),
              showProgressBar: false,
            );
          }
        },
        child: BlocProvider<HomeBloc>(
          create: (context) => widget.bloc,
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            extendBody: true,
            body: SafeArea(
              bottom: false,
              top: false,
              child: Padding(
                padding: const EdgeInsets.only(top: 0),
                child:
                    // PageView(
                    //   onPageChanged: (value) {
                    //     switch (value) {
                    //       case 0:
                    //         widget.bloc
                    //             .add(const ChangeIcon(RouteGenerator.feed));
                    //         break;
                    //       case 1:
                    //         widget.bloc
                    //             .add(const ChangeIcon(RouteGenerator.search));
                    //         break;
                    //       case 2:
                    //         widget.bloc
                    //             .add(const ChangeIcon(RouteGenerator.messages));
                    //         break;
                    //       case 3:
                    //         widget.bloc.add(
                    //             const ChangeIcon(RouteGenerator.personalProfile));
                    //         break;
                    //       default:
                    //     }
                    //   },
                    //   controller: widget.bloc.pageController,
                    //   children: [
                    //     SharedAxisTransition(
                    //       animation: pageViewAnimationController,
                    //       secondaryAnimation:
                    //           ReverseAnimation(pageViewAnimationController),
                    //       transitionType: SharedAxisTransitionType.horizontal,
                    //       child: const Feed(),
                    //     ),
                    //     SharedAxisTransition(
                    //       animation: pageViewAnimationController,
                    //       secondaryAnimation:
                    //           ReverseAnimation(pageViewAnimationController),
                    //       transitionType: SharedAxisTransitionType.horizontal,
                    //       child: Search(),
                    //     ),
                    //     SharedAxisTransition(
                    //       animation: pageViewAnimationController,
                    //       secondaryAnimation:
                    //           ReverseAnimation(pageViewAnimationController),
                    //       transitionType: SharedAxisTransitionType.horizontal,
                    //       child: const Messages(),
                    //     ),
                    //     SharedAxisTransition(
                    //       animation: pageViewAnimationController,
                    //       secondaryAnimation:
                    //           ReverseAnimation(pageViewAnimationController),
                    //       transitionType: SharedAxisTransitionType.horizontal,
                    //       child: const PersonalProfile(),
                    //     ),
                    //   ],
                    // )
                    Navigator(
                  initialRoute: RouteGenerator.feed,
                  onGenerateRoute: RouteGenerator.generateRoute,
                  key: RouteGenerator.homeNavigatorKey,
                ),
              ),
            ),
            bottomNavigationBar: BlocBuilder<HomeBloc, HomeState>(
              builder: (context, state) => Container(
                height: 90,
                padding: EdgeInsets.all(20),
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.white.withAlpha(50)),
                margin: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
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
                        onPressed: () => widget.bloc
                            .add(const Navigate(RouteGenerator.feed)),
                      ),
                      IconButton(
                        icon: SvgPicture.asset(
                          state.searchIcon,
                          colorFilter: ColorFilter.mode(
                              Theme.of(context).primaryIconTheme.color!,
                              BlendMode.srcIn),
                        ),
                        onPressed: () => widget.bloc
                            .add(const Navigate(RouteGenerator.search)),
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
                        onPressed: () => widget.bloc
                            .add(const Navigate(RouteGenerator.messages)),
                      ),
                      IconButton(
                        icon: SvgPicture.asset(
                          state.profileIcon,
                          colorFilter: ColorFilter.mode(
                              Theme.of(context).primaryIconTheme.color!,
                              BlendMode.srcIn),
                        ),
                        onPressed: () => widget.bloc.add(
                            const Navigate(RouteGenerator.personalProfile)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
