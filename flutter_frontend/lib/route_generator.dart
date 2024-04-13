import 'package:flutter/material.dart';
import 'package:universe/routes/complete_account.dart';
import 'package:universe/routes/feed.dart';
import 'package:universe/routes/followers.dart';
import 'package:universe/routes/home.dart';
import 'package:universe/routes/login.dart';
import 'package:universe/routes/messages.dart';
import 'package:universe/routes/new_post.dart';
import 'package:universe/routes/profile.dart';
import 'package:universe/routes/register.dart';
import 'package:universe/routes/search.dart';
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
  static const followersPage = "followers";

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
      case feed:
        return PageRouteBuilder(
            pageBuilder: (_, animation, secondaryAnimation) => const Feed(),
            transitionDuration: Duration.zero);
      case search:
        return PageRouteBuilder(
            pageBuilder: (_, animation, secondaryAnimation) => const Search(),
            transitionDuration: Duration.zero);
      case newPost:
        return PageRouteBuilder(
            pageBuilder: (_, animation, secondaryAnimation) => const NewPost(),
            transitionDuration: Duration.zero);
      case messages:
        return PageRouteBuilder(
            pageBuilder: (_, animation, secondaryAnimation) => const Messages(),
            transitionDuration: Duration.zero);
      case profile:
        return PageRouteBuilder(
            pageBuilder: (_, animation, secondaryAnimation) => const Profile(),
            transitionDuration: Duration.zero);
      case followersPage:
        return MaterialPageRoute(builder: (_) => FollowersPage());

      default:
        throw const FormatException("Route not found");
    }
  }
}
