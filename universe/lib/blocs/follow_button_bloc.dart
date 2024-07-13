import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:universe/models/user.dart';
import 'package:universe/repositories/authentication_repository.dart';
import 'package:universe/repositories/data_repository.dart';

class FollowButtonState {
  final bool? isFollowed;

  const FollowButtonState({this.isFollowed});
}

class GetFollowState {}

class FollowEvent {}

class UnfollowEvent {}

class FollowButtonBloc extends Bloc<Object, FollowButtonState> {
  bool builtOnce = false;
  FollowButtonBloc(User user) : super(const FollowButtonState()) {
    on<GetFollowState>(
      (event, emit) async {
        // emit(const FollowButtonState());
        emit(
          FollowButtonState(
            isFollowed: await DataRepository()
                .dataProvider
                .isUserOneFollowingUserTwo(
                    AuthenticationRepository()
                        .authenticationService
                        .currentUser()!,
                    user),
          ),
        );
        Future.delayed(const Duration(milliseconds: 1000))
            .then((value) => builtOnce = true);
      },
    );

    on<FollowEvent>(
      (event, emit) async {
        await DataRepository().dataProvider.addFollower(user,
            AuthenticationRepository().authenticationService.currentUser()!);
        emit(const FollowButtonState());
        add(GetFollowState());
      },
    );

    on<UnfollowEvent>(
      (event, emit) async {
        await DataRepository().dataProvider.removeFollower(user,
            AuthenticationRepository().authenticationService.currentUser()!);
        emit(const FollowButtonState());
        add(GetFollowState());
      },
    );

    add(GetFollowState());
  }
}
