import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:universe/interfaces/iposts_repository.dart';
import 'package:universe/models/data/post.dart';
import 'package:universe/models/data/post_reaction.dart';
import 'package:universe/repositories/authentication_repository.dart';

class PostState {
  final int? reactionsCount;
  final PostReaction? reaction;

  const PostState({this.reactionsCount = 0, this.reaction});
}

class LikeClicked {
  bool isLiked;

  LikeClicked(this.isLiked);
}

class ListenToReactionCountChanges {}

class ReactionCountChanged {
  final int reactionCount;
  final PostReaction? reaction;

  ReactionCountChanged({required this.reactionCount, required this.reaction});
}

class PostBloc extends Bloc<Object, PostState> {
  final IPostsRepository postsRepository;
  StreamSubscription<int>? streamSubscription;
  final Post post;
  PostBloc(this.postsRepository, this.post) : super(const PostState()) {
    on<LikeClicked>(
      (event, emit) {
        if (state.reaction != null) {
          postsRepository.removeReaction(
            post.author.id,
            post.id,
            state.reaction!.id!,
          );
        } else {
          postsRepository.addReaction(
            post.author.id,
            post.id,
            PostReaction(
              userId: AuthenticationRepository()
                  .authenticationService
                  .currentUser()!
                  .id,
              reactionType: 'like',
              reactionDate: DateTime.now(),
              postId: post.id,
            ),
          );
        }
      },
    );

    on<ListenToReactionCountChanges>(
      (event, emit) async {
        // streamSubscription =
        //     postsDataProvider.getPostReactionsCountStream(post).listen(
        //   (event) async {
        //     // print(
        //     //     'listening to post with id: ${post.id}. CURRENT LIKES COUNT: $event');
        //     // if (!isClosed) {
        //     add(
        //       ReactionCountChanged(
        //         reactionCount: event,
        //         reaction: await postsDataProvider.isPostReactedToByUser(
        //           post,
        //           AuthenticationRepository()
        //               .authenticationService
        //               .currentUser()!,
        //         ),
        //       ),
        //     );
        //     // }
        //   },
        // );
      },
    );

    on<ReactionCountChanged>(
      (event, emit) {
        // print(
        //     'reactions count changed: count = ${event.reactionCount}, reaction = ${event.reaction}');
        emit(
          PostState(
            reactionsCount: event.reactionCount,
            reaction: event.reaction,
          ),
        );
      },
    );

    add(ListenToReactionCountChanges());
  }

  @override
  Future<void> close() async {
    if (streamSubscription != null) {
      await streamSubscription!.cancel();
    }
    return super.close();
  }
}
