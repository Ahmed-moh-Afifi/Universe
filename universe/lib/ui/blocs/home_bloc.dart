import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:universe/repositories/authentication_repository.dart';
import 'package:universe/route_generator.dart';

enum HomeStates {
  loading,
  loaded,
  error,
}

class HomeState {
  HomeStates state;
  String homeIcon = 'lib/assets/icons/homeFilled.svg';
  String searchIcon = 'lib/assets/icons/search.svg';
  String newPostIcon = 'lib/assets/icons/edit.svg';
  String messagesIcon = 'lib/assets/icons/message.svg';
  String profileIcon = 'lib/assets/icons/user.svg';
  final user = AuthenticationRepository().authenticationService.currentUser()!;
  String selectedRouteName = RouteGenerator.feed;
  bool floatingActionButtonVisible;

  HomeState(
    this.state, {
    this.floatingActionButtonVisible = true,
    this.selectedRouteName = RouteGenerator.feed,
  });
}

class Navigate {
  final String routeName;

  const Navigate(this.routeName);
}

class ChangeIcon {
  final String routeName;

  const ChangeIcon(this.routeName);
}

class HomeBloc extends Bloc<Object, HomeState> {
  PageController pageController = PageController(initialPage: 0);
  HomeBloc()
      : super(HomeState(HomeStates.loading,
            selectedRouteName: RouteGenerator.feed)) {
    on<Navigate>(
      (event, emit) {
        if (state.selectedRouteName != event.routeName) {
          emit(changeRoute(event.routeName, state));
        }
      },
    );

    on<ChangeIcon>(
      (event, emit) {
        emit(changeIcon(event.routeName, state));
      },
    );
  }

  HomeState changeRoute(String routeName, HomeState currentState) {
    final state = HomeState(currentState.state, selectedRouteName: routeName);
    state.homeIcon = 'lib/assets/icons/home.svg';
    state.searchIcon = 'lib/assets/icons/search.svg';
    state.newPostIcon = 'lib/assets/icons/edit.svg';
    state.messagesIcon = 'lib/assets/icons/message.svg';
    state.profileIcon = 'lib/assets/icons/user.svg';

    // int currentRoute = 0;
    // switch (currentState.selectedRouteName) {
    //   case RouteGenerator.feed:
    //     currentRoute = 0;
    //     break;
    //   case RouteGenerator.search:
    //     currentRoute = 1;
    //     break;
    //   case RouteGenerator.newPost:
    //     currentRoute = 2;
    //     break;
    //   case RouteGenerator.messages:
    //     currentRoute = 3;
    //     break;
    //   case RouteGenerator.personalProfile:
    //     currentRoute = 4;
    //     break;
    // }

    // int newRoute = 0;
    switch (routeName) {
      case RouteGenerator.feed:
        // newRoute = 0;
        state.homeIcon = 'lib/assets/icons/homeFilled.svg';
        // pageController.animateToPage(0,
        //     curve: Curves.decelerate, duration: Duration(milliseconds: 200));
        break;
      case RouteGenerator.search:
        // newRoute = 1;
        state.searchIcon = 'lib/assets/icons/searchFilled.svg';
        // pageController.animateToPage(1,
        //     curve: Curves.decelerate, duration: Duration(milliseconds: 200));
        break;
      case RouteGenerator.newPost:
        // newRoute = 2;
        state.newPostIcon = 'lib/assets/icons/editFilled.svg';
        state.floatingActionButtonVisible = false;
        break;
      case RouteGenerator.messages:
        // newRoute = 3;
        state.messagesIcon = 'lib/assets/icons/messageFilled.svg';
        // pageController.animateToPage(2,
        //     curve: Curves.decelerate, duration: Duration(milliseconds: 200));
        break;
      case RouteGenerator.personalProfile:
        // newRoute = 4;
        state.profileIcon = 'lib/assets/icons/userFilled.svg';
        // pageController.animateToPage(3,
        //     curve: Curves.decelerate, duration: Duration(milliseconds: 200));
        break;
    }

    RouteGenerator.homeNavigatorKey.currentState!
        .pushReplacementNamed(routeName);
    return state;
  }

  HomeState changeIcon(String routeName, HomeState currentState) {
    final state = HomeState(currentState.state, selectedRouteName: routeName);
    state.homeIcon = 'lib/assets/icons/home.svg';
    state.searchIcon = 'lib/assets/icons/search.svg';
    state.newPostIcon = 'lib/assets/icons/edit.svg';
    state.messagesIcon = 'lib/assets/icons/message.svg';
    state.profileIcon = 'lib/assets/icons/user.svg';

    switch (routeName) {
      case RouteGenerator.feed:
        state.homeIcon = 'lib/assets/icons/homeFilled.svg';
        break;
      case RouteGenerator.search:
        state.searchIcon = 'lib/assets/icons/searchFilled.svg';
        break;
      case RouteGenerator.newPost:
        state.newPostIcon = 'lib/assets/icons/editFilled.svg';
        state.floatingActionButtonVisible = false;
        break;
      case RouteGenerator.messages:
        state.messagesIcon = 'lib/assets/icons/messageFilled.svg';
        break;
      case RouteGenerator.personalProfile:
        state.profileIcon = 'lib/assets/icons/userFilled.svg';
        break;
    }

    return state;
  }
}
