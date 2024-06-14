import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:universe/blocs/new_post_bloc.dart';
import 'package:universe/blocs/personal_profile_bloc.dart';
import 'package:universe/blocs/search_bloc.dart';
import 'package:universe/models/post.dart';
import 'package:universe/models/user.dart';
import 'package:universe/routes/account_settings.dart';
import 'package:universe/routes/complete_account.dart';
import 'package:universe/routes/feed.dart';
import 'package:universe/routes/followers.dart';
import 'package:universe/routes/following.dart';
import 'package:universe/routes/home.dart';
import 'package:universe/routes/login.dart';
import 'package:universe/routes/messages.dart';
import 'package:universe/routes/new_post.dart';
import 'package:universe/routes/personal_profile.dart';
import 'package:universe/routes/profile.dart';
import 'package:universe/routes/reactions.dart';
import 'package:universe/routes/register.dart';
import 'package:universe/routes/replies.dart';
import 'package:universe/routes/search.dart';
import 'package:universe/routes/settings.dart';
import 'package:universe/routes/startup.dart';

class RouteGenerator {
  RouteGenerator._();

  static final mainNavigatorkey = GlobalKey<NavigatorState>();
  static final homeNavigatorKey = GlobalKey<NavigatorState>();

  static const homePage = "home";
  static const loginPage = "login";
  static const registerPage = "register";
  static const completeAccount = "completeAccount";
  static const startup = "startup";
  static const feed = "feed";
  static const search = "search";
  static const newPost = "newPost";
  static const messages = "messages";
  static const profile = "profile";
  static const personalProfile = "personalProfile";
  static const followersPage = "followers";
  static const followingPage = "following";
  static const reactionsPage = "reactions";
  static const repliesPage = "replies";
  static const settingsPage = "settings";
  static const accountSettingsPage = 'accountSettings';

  static SearchState searchState = const SearchState(
    previousState: SearchStates.notStarted,
    state: SearchStates.notStarted,
  );
  static NewPostState newPostState = NewPostState(
    previousState: NewPostStates.notStarted,
    state: NewPostStates.notStarted,
    content: '',
    images: [],
    videos: [],
  );
  static PersonalProfileState? personalProfileState;

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case homePage:
        return MaterialPageRoute(builder: (_) => HomePage());
      case loginPage:
        return MaterialPageRoute(builder: (_) => Login());
      case registerPage:
        return MaterialPageRoute(builder: (_) => Register());
      case completeAccount:
        return MaterialPageRoute(builder: (_) => const CompleteAccount());
      case startup:
        return MaterialPageRoute(builder: (_) => const Startup());
      case profile:
        return MaterialPageRoute(
            builder: (_) => Profile(settings.arguments as User));
      case feed:
        return PageRouteBuilder(
          pageBuilder: (_, animation, secondaryAnimation) => const Feed(),
          transitionDuration: Duration.zero,
        );
      case search:
        return PageRouteBuilder(
          pageBuilder: (_, animation, secondaryAnimation) => Search(),
          transitionDuration: Duration.zero,
        );
      case newPost:
        return PageRouteBuilder(
          pageBuilder: (_, animation, secondaryAnimation) => NewPost(),
          transitionDuration: Duration.zero,
        );
      case messages:
        return PageRouteBuilder(
          pageBuilder: (_, animation, secondaryAnimation) => const Messages(),
          transitionDuration: Duration.zero,
        );
      case personalProfile:
        return PageRouteBuilder(
          pageBuilder: (_, animation, secondaryAnimation) => PersonalProfile(),
          transitionDuration: Duration.zero,
        );
      case followersPage:
        return MaterialPageRoute(
          builder: (_) => FollowersPage(settings.arguments as User),
        );
      case followingPage:
        return MaterialPageRoute(
          builder: (_) => FollowingPage(settings.arguments as User),
        );
      case reactionsPage:
        return MaterialPageRoute(
          builder: (_) => Reactions(post: settings.arguments as Post),
        );
      case repliesPage:
        return MaterialPageRoute(
          builder: (_) => Replies(
            post: (settings.arguments as List)[0] as Post,
            user: (settings.arguments as List)[1] as User,
          ),
        );
      case settingsPage:
        return slidingRoute(const Settings());
      case accountSettingsPage:
        return slidingRoute(const AccountSettings());

      default:
        throw const FormatException("Route not found");
    }
  }

  static PageRouteBuilder slidingRoute(Widget route) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => route,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = const Offset(1, 0);
        var tween = Tween(begin: begin, end: Offset.zero).chain(
          CurveTween(curve: Curves.ease),
        );

        var blurTween = Tween(begin: 0.0, end: 15.0)
            .animate(CurvedAnimation(parent: animation, curve: Curves.ease));
        return AnimatedBuilder(
          animation: blurTween,
          builder: (context, child2) {
            return BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: blurTween.value,
                sigmaY: blurTween.value,
              ),
              child: FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: animation.drive(tween),
                  child: child,
                ),
              ),
            );
          },
        );
      },
    );
  }

  static void resetAppState() {
    searchState = const SearchState(
      previousState: SearchStates.notStarted,
      state: SearchStates.notStarted,
    );
    newPostState = NewPostState(
      previousState: NewPostStates.notStarted,
      state: NewPostStates.notStarted,
      content: '',
      images: [],
      videos: [],
    );
    personalProfileState = null;
  }
}
