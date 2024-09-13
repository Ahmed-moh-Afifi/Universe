import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:universe/interfaces/iposts_files_repository.dart';
import 'package:universe/interfaces/iposts_repository.dart';
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
  NewPostBloc(
      IPostsRepository postsRepository, IPostsFilesRepository filesRepository)
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

            final post = Post(
              title: '',
              body: event.content,
              author: AuthenticationRepository()
                  .authenticationService
                  .currentUser()!,
              images: event.images,
              videos: event.videos,
              audios: event.audios,
              widgets: event.widgets,
              replyToPost: -1,
              childPostId: -1,
              publishDate: DateTime.now(),
              reactionsCount: 0,
              repliesCount: 0,
              reactedToByCaller: false,
            );

            final ImagePicker picker = ImagePicker();

            var images = await picker.pickMultiImage();

            var multipartImages = images.map((e) {
              return MultipartFile.fromFileSync(e.path);
            }).toList();

            log('Images selected: $images', name: 'NewPostBloc');
            log('Multipart images: $multipartImages', name: 'NewPostBloc');

            log('Post: ${post.toJson()}', name: 'NewPostBloc');

            // Add post files.
            var imagesUrls =
                await filesRepository.uploadImage(post.uid!, multipartImages);
            post.images = imagesUrls.isNotEmpty ? imagesUrls : post.images;

            log('Images uploaded: ${post.images}', name: 'NewPostBloc');

            await postsRepository.addPost(post);

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
