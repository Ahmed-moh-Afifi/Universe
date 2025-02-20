import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:universe/models/data/chat.dart';
import 'package:universe/ui/blocs/new_post_bloc.dart';
import 'package:universe/ui/blocs/personal_profile_bloc.dart';
import 'package:universe/ui/blocs/search_bloc.dart';
import 'package:universe/models/data/post.dart';
import 'package:universe/models/data/user.dart';
import 'package:universe/ui/routes/account_settings.dart';
import 'package:universe/ui/routes/chat.dart';
import 'package:universe/ui/routes/complete_account.dart';
import 'package:universe/ui/routes/feed.dart';
import 'package:universe/ui/routes/followers.dart';
import 'package:universe/ui/routes/following.dart';
import 'package:universe/ui/routes/home.dart';
import 'package:universe/ui/routes/login.dart';
import 'package:universe/ui/routes/messages.dart';
import 'package:universe/ui/routes/new_post.dart';
import 'package:universe/ui/routes/personal_profile.dart';
import 'package:universe/ui/routes/profile.dart';
import 'package:universe/ui/routes/reactions.dart';
import 'package:universe/ui/routes/register.dart';
import 'package:universe/ui/routes/replies.dart';
import 'package:universe/ui/routes/search.dart';
import 'package:universe/ui/routes/settings.dart';
import 'package:universe/ui/routes/startup.dart';

class RouteGenerator {
  RouteGenerator._();

  static final mainNavigatorkey = GlobalKey<NavigatorState>();
  static final homeNavigatorKey = GlobalKey<NavigatorState>();

  static const homePage = "home";
  static const loginPage = "login";
  static const registerPage = "register";
  static const editProfile = "completeAccount";
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
  static const accountSettingsPage = "accountSettings";
  static const chat = "chat";

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

  static Chat? openedChat;

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case homePage:
        return MaterialPageRoute(builder: (_) => HomePage());
      case loginPage:
        return MaterialPageRoute(builder: (_) => Login());
      case registerPage:
        return MaterialPageRoute(builder: (_) => Register());
      case editProfile:
        return MaterialPageRoute(
            builder: (_) => CompleteAccount(
                  previousRouteName: settings.arguments as String,
                ));
      case startup:
        return MaterialPageRoute(builder: (_) => const Startup());
      case profile:
        return MaterialPageRoute(
            builder: (_) => Profile(settings.arguments as User));
      case feed:
        return MaterialPageRoute(builder: (_) => const Feed());
      case search:
        return MaterialPageRoute(builder: (_) => Search());
      case newPost:
        return MaterialPageRoute(builder: (_) => NewPost());
      case messages:
        return MaterialPageRoute(builder: (_) => const Messages());
      case personalProfile:
        return MaterialPageRoute(builder: (_) => const PersonalProfile());
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
        return MaterialPageRoute(builder: (_) => const Settings());
      case accountSettingsPage:
        return MaterialPageRoute(builder: (_) => const AccountSettings());
      case chat:
        return MaterialPageRoute(
          builder: (_) => ChatScreen(
            (settings.arguments as List)[0] as Chat,
          ),
        );

      default:
        throw const FormatException("Route not found");
    }
  }

  static PageRouteBuilder slidingRoute(Widget route,
      {bool reverseDirection = false}) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => route,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SharedAxisTransition(
          animation: reverseDirection ? ReverseAnimation(animation) : animation,
          secondaryAnimation: reverseDirection
              ? ReverseAnimation(secondaryAnimation)
              : secondaryAnimation,
          transitionType: SharedAxisTransitionType.horizontal,
          child: child,
        );
      },
    );
  }

  // static PageRouteBuilder slidingRoute(Widget route) {
  //   return PageRouteBuilder(
  //     pageBuilder: (context, animation, secondaryAnimation) => route,
  //     transitionsBuilder: (context, animation, secondaryAnimation, child) {
  //       var begin = const Offset(1, 0);
  //       var tween = Tween(begin: begin, end: Offset.zero).chain(
  //         CurveTween(curve: Curves.ease),
  //       );

  //       var blurTween = Tween(begin: 0.0, end: 15.0)
  //           .animate(CurvedAnimation(parent: animation, curve: Curves.ease));
  //       return AnimatedBuilder(
  //         animation: blurTween,
  //         builder: (context, child2) {
  //           return BackdropFilter(
  //             filter: ImageFilter.blur(
  //               sigmaX: blurTween.value,
  //               sigmaY: blurTween.value,
  //             ),
  //             child: FadeTransition(
  //               opacity: animation,
  //               child: SlideTransition(
  //                 position: animation.drive(tween),
  //                 child: child,
  //               ),
  //             ),
  //           );
  //         },
  //       );
  //     },
  //   );
  // }

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
