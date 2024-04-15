import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:universe/models/user.dart';
import 'package:universe/models/user_posts_response.dart';
import 'package:universe/repositories/data_repository.dart';

enum UserPostsViewerStates {
  notStarted,
  loading,
  success,
  failed,
}

class UserPostsViewerState {
  final UserPostsViewerStates state;
  final UserPostsResponse? response;
  final String? error;

  const UserPostsViewerState({required this.state, this.response, this.error});
}

class GetUserPostsEvent {
  final User user;

  const GetUserPostsEvent({required this.user});
}

class UserPostsViewerBloc extends Bloc<Object, UserPostsViewerState> {
  final User user;
  UserPostsViewerBloc(this.user)
      : super(const UserPostsViewerState(
            state: UserPostsViewerStates.notStarted)) {
    on<GetUserPostsEvent>(
      (event, emit) async {
        emit(const UserPostsViewerState(state: UserPostsViewerStates.loading));
        emit(
          UserPostsViewerState(
            state: UserPostsViewerStates.success,
            response: await DataRepository().dataProvider.getUserPosts(
                  user,
                  null,
                  25,
                ),
          ),
        );
      },
    );

    add(GetUserPostsEvent(user: user));
  }
}