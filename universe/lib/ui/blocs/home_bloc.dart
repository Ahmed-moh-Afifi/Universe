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
    // RouteGenerator.homeNavigatorKey.currentState!
    //     .pushReplacementNamed(routeName);

    final state = HomeState(currentState.state, selectedRouteName: routeName);
    state.homeIcon = 'lib/assets/icons/home.svg';
    state.searchIcon = 'lib/assets/icons/search.svg';
    state.newPostIcon = 'lib/assets/icons/edit.svg';
    state.messagesIcon = 'lib/assets/icons/message.svg';
    state.profileIcon = 'lib/assets/icons/user.svg';

    switch (routeName) {
      case RouteGenerator.feed:
        state.homeIcon = 'lib/assets/icons/homeFilled.svg';
        pageController.jumpToPage(0);
        break;
      case RouteGenerator.search:
        state.searchIcon = 'lib/assets/icons/searchFilled.svg';
        pageController.jumpToPage(1);
        break;
      case RouteGenerator.newPost:
        state.newPostIcon = 'lib/assets/icons/editFilled.svg';
        state.floatingActionButtonVisible = false;
        break;
      case RouteGenerator.messages:
        state.messagesIcon = 'lib/assets/icons/messageFilled.svg';
        pageController.jumpToPage(2);
        break;
      case RouteGenerator.personalProfile:
        state.profileIcon = 'lib/assets/icons/userFilled.svg';
        pageController.jumpToPage(3);
        break;
    }
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
