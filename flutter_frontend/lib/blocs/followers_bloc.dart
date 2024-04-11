import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:universe/apis/authentication/firebase_authentication.dart';
import 'package:universe/apis/firestore.dart';
import 'package:universe/models/follower.dart';
import 'package:universe/models/user.dart';

class FollowersState {
  final List<Follower> followers;

  const FollowersState(this.followers);
}

class GetFollowers {
  final User user;

  const GetFollowers(this.user);
}

class FollowersBloc extends Bloc<Object, FollowersState> {
  FollowersBloc() : super(const FollowersState([])) {
    on<GetFollowers>(
      (event, emit) async {
        var response = await FirestoreDataProvider()
            .getUserFollowers(event.user, null, 50);
        emit(FollowersState([...response.followers, ...state.followers]));
        // await Future.delayed(const Duration(seconds: 0));
        // response = await response.nextPage();
        // emit(FollowersState(
        //     [...response.followers.toList(), ...state.followers]));
        // await Future.delayed(const Duration(seconds: 0));
        // response = await response.nextPage();
        // emit(FollowersState(
        //     [...response.followers.toList(), ...state.followers]));
        // await Future.delayed(const Duration(seconds: 0));
        // response = await response.nextPage();
        // emit(FollowersState(
        //     [...response.followers.toList(), ...state.followers]));
      },
    );
    add(GetFollowers(FirebaseAuthentication().user!));
  }
}
