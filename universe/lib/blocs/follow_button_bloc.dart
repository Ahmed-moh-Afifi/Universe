import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:universe/models/data/user.dart';
import 'package:universe/repositories/authentication_repository.dart';
import 'package:universe/repositories/users_repository.dart';

class FollowButtonState {
  final bool? isFollowed;

  const FollowButtonState({this.isFollowed});
}

class GetFollowState {}

class FollowEvent {}

class UnfollowEvent {}

class FollowButtonBloc extends Bloc<Object, FollowButtonState> {
  bool builtOnce = false;
  FollowButtonBloc(UsersRepository usersRepository, User user)
      : super(const FollowButtonState()) {
    on<GetFollowState>(
      (event, emit) async {
        // emit(const FollowButtonState());
        emit(
          FollowButtonState(
            isFollowed: await usersRepository.isFollowing(
              AuthenticationRepository()
                  .authenticationService
                  .currentUser()!
                  .id,
              user.id,
            ),
          ),
        );
        Future.delayed(const Duration(milliseconds: 1000))
            .then((value) => builtOnce = true);
      },
    );

    on<FollowEvent>(
      (event, emit) async {
        await usersRepository.followUser(
          user.id,
          AuthenticationRepository().authenticationService.currentUser()!.id,
        );
        emit(const FollowButtonState());
        add(GetFollowState());
      },
    );

    on<UnfollowEvent>(
      (event, emit) async {
        await usersRepository.unfollowUser(
          user.id,
          AuthenticationRepository().authenticationService.currentUser()!.id,
        );
        emit(const FollowButtonState());
        add(GetFollowState());
      },
    );

    add(GetFollowState());
  }
}
