import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:universe/models/data/post.dart';
import 'package:universe/models/data/widget.dart';
import 'package:universe/repositories/authentication_repository.dart';
import 'package:universe/route_generator.dart';

enum NewPostStates {
  notStarted,
  informative,
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
  final List<String> audios;
  final List<Widget> widgets;

  const PostEvent({
    required this.content,
    required this.images,
    required this.videos,
    required this.audios,
    required this.widgets,
  });
}

class NewPostBloc extends Bloc<Object, NewPostState> {
  NewPostBloc(IPostsDataProvider postsDataProvider)
      : super(RouteGenerator.newPostState.state == NewPostStates.informative ||
                RouteGenerator.newPostState.state == NewPostStates.success
            ? NewPostState(
                previousState: NewPostStates.notStarted,
                state: NewPostStates.notStarted,
                content: '',
                images: [],
                videos: [])
            : RouteGenerator.newPostState) {
    on<PostEvent>(
      (event, emit) async {
        if (state.state != NewPostStates.informative &&
            state.state != NewPostStates.success) {
          if (event.content.isNotEmpty ||
              event.images.isNotEmpty ||
              event.videos.isNotEmpty) {
            if (!isClosed) {
              emit(
                NewPostState(
                  previousState: state.state,
                  state: NewPostStates.loading,
                  content: '',
                  images: [],
                  videos: [],
                ),
              );
            }
            await postsDataProvider.addPost(
              AuthenticationRepository().authenticationService.currentUser()!,
              Post(
                title: '',
                body: event.content,
                author: AuthenticationRepository()
                    .authenticationService
                    .currentUser()!,
                images: event.images,
                videos: event.videos,
                audios: event.audios,
                widgets: event.widgets,
                replyToPost: null,
                childPostId: null,
                publishDate: DateTime.now(),
              ),
            );
            if (!isClosed) {
              emit(
                NewPostState(
                  previousState: state.state,
                  state: NewPostStates.informative,
                  content: event.content,
                  images: event.images,
                  videos: event.videos,
                ),
              );
            }
            await Future.delayed(
              const Duration(milliseconds: 1500),
              () {
                if (!isClosed) {
                  emit(
                    NewPostState(
                      previousState: state.state,
                      state: NewPostStates.success,
                      content: event.content,
                      images: event.images,
                      videos: event.videos,
                    ),
                  );
                }
                RouteGenerator.mainNavigatorkey.currentState!.pop();
              },
            );
          } else {
            if (!isClosed) {
              emit(
                NewPostState(
                  previousState: state.state,
                  state: NewPostStates.failed,
                  content: '',
                  images: [],
                  videos: [],
                  error: 'invalid or no input',
                ),
              );
            }
          }
        }
      },
    );
  }
}
