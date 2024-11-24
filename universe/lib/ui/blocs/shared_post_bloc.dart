import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:universe/interfaces/iposts_repository.dart';
import 'package:universe/models/data/post.dart';
import 'package:universe/repositories/authentication_repository.dart';

enum SharedPostStates { initial, loading, loaded, error }

class SharedPostState {
  final SharedPostStates state;
  final Post? post;
  final String? error;

  SharedPostState({required this.state, this.post, this.error});
}

class GetPostEvent {}

class SharedPostBloc extends Bloc<Object?, SharedPostState> {
  final int postId;

  SharedPostBloc(IPostsRepository postsRepository, this.postId)
      : super(SharedPostState(state: SharedPostStates.initial)) {
    on<GetPostEvent>(
      (event, emit) async {
        emit(SharedPostState(state: SharedPostStates.loading));
        var post = await postsRepository.getPost(
            AuthenticationRepository().authenticationService.currentUser()!.id,
            postId); // The id should be the id of the post's author.
        emit(SharedPostState(state: SharedPostStates.loaded, post: post));
        // RouteGenerator.mainNavigatorkey.currentState!.pop();
      },
    );

    add(GetPostEvent());
  }
}
