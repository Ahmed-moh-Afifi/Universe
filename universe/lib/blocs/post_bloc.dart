import 'dart:async';
import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:universe/apis/hubs/reactions_count_hub.dart';
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
        log('Listening to reaction count changes for post: ${post.id}');
        await ReactionsCountHub().connect();
        await ReactionsCountHub()
            .subscribeToPostReactionsCount(post.id.toString());
        ReactionsCountHub().onReactionsCountChanged((change, userId) {
          log('Reaction count changed: count = ${post.reactionsCount + change}, userId = $userId');
          emit(
            PostState(
              reactionsCount: post.reactionsCount + change,
              reaction: userId ==
                      AuthenticationRepository()
                          .authenticationService
                          .currentUser()!
                          .id
                  ? PostReaction(
                      userId: userId,
                      reactionType: 'like',
                      reactionDate: DateTime.now(),
                      postId: post.id,
                    )
                  : null,
            ),
          );
        });
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
    log('Closing PostBloc for post: ${post.id}');
    return super.close();
  }
}
