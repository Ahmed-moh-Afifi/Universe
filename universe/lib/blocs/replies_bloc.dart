import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:universe/models/data/post.dart';
import 'package:universe/repositories/authentication_repository.dart';

enum RepliesStates {
  notStarted,
  loading,
  loaded,
  failed,
}

class RepliesState {
  final RepliesStates previousState;
  final RepliesStates state;
  final List<Post>? replies;
  final String? error;

  const RepliesState(this.previousState, this.state, this.replies, this.error);
}

class GetReplies {}

class AddReply {
  final String reply;

  AddReply(this.reply);
}

class RepliesBloc extends Bloc<Object, RepliesState> {
  final IPostsDataProvider postsDataProvider;
  final Post post;
  RepliesBloc(this.postsDataProvider, this.post)
      : super(
          const RepliesState(
              RepliesStates.notStarted, RepliesStates.notStarted, null, null),
        ) {
    on<GetReplies>((event, emit) async {
      if (state.state != RepliesStates.loading) {
        emit(RepliesState(state.state, RepliesStates.loading, null, null));
      }
      var replies = await postsDataProvider.getPostReplies(post, null, 25);
      emit(
        RepliesState(
          state.state,
          RepliesStates.loaded,
          replies,
          null,
        ),
      );
    });

    on<AddReply>(
      (event, emit) async {
        if (event.reply.isNotEmpty) {
          emit(RepliesState(state.state, RepliesStates.loading, null, null));
          await postsDataProvider.addReply(
            AuthenticationRepository().authenticationService.currentUser()!,
            post,
            Post(
              title: '',
              body: event.reply,
              author: AuthenticationRepository()
                  .authenticationService
                  .currentUser()!,
              images: [],
              videos: [],
              audios: [],
              widgets: [],
              replyToPost: post.id,
              childPostId: null,
              publishDate: DateTime.now(),
            ),
          );
          add(GetReplies());
        }
      },
    );

    add(GetReplies());
  }
}
