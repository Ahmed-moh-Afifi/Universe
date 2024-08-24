import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:universe/interfaces/iusers_repository.dart';
import 'package:universe/models/data/user.dart';
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
  UserPresenterBloc(IUsersRepository usersRepository, this.user)
      : super(const UserPresenterState()) {
    on<GetFollowState>(
      (event, emit) async {
        emit(
          UserPresenterState(
            isFollowed: await usersRepository.isFollowing(
              AuthenticationRepository()
                  .authenticationService
                  .currentUser()!
                  .id,
              user.id,
            ),
          ),
        );
      },
    );

    on<FollowEvent>(
      (event, emit) async {
        await usersRepository.followUser(
          user.id,
          AuthenticationRepository().authenticationService.currentUser()!.id,
        );
        emit(const UserPresenterState());
        add(GetFollowState());
      },
    );

    on<UnfollowEvent>(
      (event, emit) async {
        await usersRepository.unfollowUser(user.id,
            AuthenticationRepository().authenticationService.currentUser()!.id);
        emit(const UserPresenterState());
        add(GetFollowState());
      },
    );

    add(GetFollowState());
  }
}
