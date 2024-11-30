import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:universe/interfaces/iposts_repository.dart';
import 'package:universe/models/data/post.dart';
import 'package:universe/models/requests/api_call_start.dart';
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
  final IPostsRepository postsRepository;
  final Post post;
  RepliesBloc(this.postsRepository, this.post)
      : super(
          const RepliesState(
              RepliesStates.notStarted, RepliesStates.notStarted, null, null),
        ) {
    on<GetReplies>((event, emit) async {
      if (state.state != RepliesStates.loading) {
        emit(RepliesState(state.state, RepliesStates.loading, null, null));
      }
      var replies = await postsRepository.getPostReplies(
        post.author.id,
        post.id,
        ApiCallStart(),
        25,
      );
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
          await postsRepository.addReply(
            post.author.id,
            post.id,
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
              replyToPostId: post.id,
              childPostId: -1,
              publishDate: DateTime.now(),
              reactionsCount: 0,
              repliesCount: 0,
              reactedToByCaller: false,
            ),
          );
          add(GetReplies());
        }
      },
    );

    add(GetReplies());
  }
}
