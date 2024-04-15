import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:universe/models/post.dart';
import 'package:universe/repositories/authentication_repository.dart';
import 'package:universe/repositories/data_repository.dart';
import 'package:universe/route_generator.dart';

enum NewPostStates {
  notStarted,
  loading,
  success,
  failed,
}

class NewPostState {
  final NewPostStates previousState;
  final NewPostStates state;
  final String content;
  final List<String> images;
  final List<String> videos;
  final String? error;

  NewPostState({
    required this.previousState,
    required this.state,
    required this.content,
    required this.images,
    required this.videos,
    this.error,
  }) {
    saveState();
  }

  void saveState() {
    RouteGenerator.newPostState = this;
  }
}

class PostEvent {
  final String content;
  final List<String> images;
  final List<String> videos;

  const PostEvent({
    required this.content,
    required this.images,
    required this.videos,
  });
}

class NewPostBloc extends Bloc<Object, NewPostState> {
  NewPostBloc(super.initialState) {
    on<PostEvent>(
      (event, emit) async {
        if (event.content.isNotEmpty ||
            event.images.isNotEmpty ||
            event.videos.isNotEmpty) {
          emit(
            NewPostState(
              previousState: state.state,
              state: NewPostStates.loading,
              content: '',
              images: [],
              videos: [],
            ),
          );
          await DataRepository().dataProvider.addPost(
                AuthenticationRepository().authenticationService.getUser()!,
                Post(
                  title: '',
                  body: event.content,
                  authorId: AuthenticationRepository()
                      .authenticationService
                      .getUser()!
                      .uid,
                  images: event.images,
                  videos: event.videos,
                  publishDate: DateTime.now(),
                ),
              );
          emit(
            NewPostState(
                previousState: state.state,
                state: NewPostStates.success,
                content: event.content,
                images: event.images,
                videos: event.videos),
          );
        } else {
          emit(NewPostState(
            previousState: state.state,
            state: NewPostStates.failed,
            content: '',
            images: [],
            videos: [],
            error: 'invalid or no input',
          ));
        }
      },
    );
  }
}
