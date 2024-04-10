import 'package:flutter/material.dart';
import 'package:universe/routes/complete_account.dart';
import 'package:universe/routes/followers.dart';
import 'package:universe/routes/home.dart';
import 'package:universe/routes/login.dart';
import 'package:universe/routes/register.dart';
import 'package:universe/routes/startup.dart';

class RouteGenerator {
  RouteGenerator._();

  static final key = GlobalKey<NavigatorState>();
  static const homePage = "home";
  static const loginPage = "login";
  static const registerPage = "register";
  static const completeAccount = "completeAccount";
  static const startup = "startup";
  static const followersPage = "followers";

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case homePage:
        return MaterialPageRoute(builder: (_) => const HomePage());
      case loginPage:
        return MaterialPageRoute(builder: (_) => Login());
      case registerPage:
        return MaterialPageRoute(builder: (_) => Register());
      case completeAccount:
        return MaterialPageRoute(builder: (_) => const CompleteAccount());
      case startup:
        return MaterialPageRoute(builder: (_) => const Startup());
      case followersPage:
        return MaterialPageRoute(builder: (_) => FollowersPage());

      default:
        throw const FormatException("Route not found");
    }
  }
}
