import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:universe/models/user.dart';
import 'package:universe/repositories/authentication_repository.dart';
import 'package:universe/repositories/data_repository.dart';

class UserPresenterState {
  final bool? isFollowed;

  const UserPresenterState({this.isFollowed});
}

class GetFollowState {}

class FollowEvent {}

class UnfollowEvent {}

class UserPresenterBloc extends Bloc<Object, UserPresenterState> {
  final User user;
  UserPresenterBloc(this.user) : super(const UserPresenterState()) {
    on<GetFollowState>(
      (event, emit) async {
        emit(
          UserPresenterState(
            isFollowed: await DataRepository()
                .dataProvider
                .isUserOneFollowingUserTwo(
                    AuthenticationRepository().authenticationService.getUser()!,
                    user),
          ),
        );
      },
    );

    on<FollowEvent>(
      (event, emit) async {
        await DataRepository().dataProvider.addFollower(
            user, AuthenticationRepository().authenticationService.getUser()!);
        emit(const UserPresenterState());
        add(GetFollowState());
      },
    );

    on<UnfollowEvent>(
      (event, emit) async {
        await DataRepository().dataProvider.removeFollower(
            user, AuthenticationRepository().authenticationService.getUser()!);
        emit(const UserPresenterState());
        add(GetFollowState());
      },
    );

    add(GetFollowState());
  }
}
