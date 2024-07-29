import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:universe/interfaces/iusers_data_provider.dart';
import 'package:universe/models/user.dart';
import 'package:universe/repositories/authentication_repository.dart';

class UserPresenterState {
  final bool? isFollowed;

  const UserPresenterState({this.isFollowed});
}

class GetFollowState {}

class FollowEvent {}

class UnfollowEvent {}

class UserPresenterBloc extends Bloc<Object, UserPresenterState> {
  final User user;
  UserPresenterBloc(IusersDataProvider usersDataProvider, this.user)
      : super(const UserPresenterState()) {
    on<GetFollowState>(
      (event, emit) async {
        emit(
          UserPresenterState(
            isFollowed: await usersDataProvider.isUserOneFollowingUserTwo(
                AuthenticationRepository().authenticationService.currentUser()!,
                user),
          ),
        );
      },
    );

    on<FollowEvent>(
      (event, emit) async {
        await usersDataProvider.addFollower(user,
            AuthenticationRepository().authenticationService.currentUser()!);
        emit(const UserPresenterState());
        add(GetFollowState());
      },
    );

    on<UnfollowEvent>(
      (event, emit) async {
        await usersDataProvider.removeFollower(user,
            AuthenticationRepository().authenticationService.currentUser()!);
        emit(const UserPresenterState());
        add(GetFollowState());
      },
    );

    add(GetFollowState());
  }
}
