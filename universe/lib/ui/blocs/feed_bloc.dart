import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:universe/models/data/post.dart';
import 'package:universe/models/requests/api_call_start.dart';
import 'package:universe/repositories/authentication_repository.dart';
import 'package:universe/repositories/posts_repository.dart';

abstract class FeedEvent {}

class LoadFeed extends FeedEvent {}

abstract class FeedState {}

class FeedLoading extends FeedState {}

class FeedLoaded extends FeedState {
  final List<Post> posts;

  FeedLoaded(this.posts);
}

class FeedError extends FeedState {
  final String errorMessage;

  FeedError(this.errorMessage);
}

class FeedBloc extends Bloc<FeedEvent, FeedState> {
  final PostsRepository postsRepository;

  FeedBloc(this.postsRepository) : super(FeedLoading()) {
    on<LoadFeed>(
      (event, emit) async {
        emit(FeedLoading());
        var posts = await postsRepository.getFollowingPosts(
          AuthenticationRepository().authenticationService.currentUser()!.id,
          ApiCallStart(),
          25,
        );

        emit(FeedLoaded(posts));
      },
    );
  }
}
