import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:universe/models/post.dart';
import 'package:universe/models/reaction.dart';
import 'package:universe/repositories/authentication_repository.dart';
import 'package:universe/repositories/data_repository.dart';

class PostState {
  final int? reactionsCount;
  final Reaction? reaction;

  const PostState({this.reactionsCount = 0, this.reaction});
}

class LikeClicked {
  bool isLiked;

  LikeClicked(this.isLiked);
}

class ListenToReactionCountChanges {}

class ReactionCountChanged {
  final int reactionCount;
  final Reaction? reaction;

  ReactionCountChanged({required this.reactionCount, required this.reaction});
}

class PostBloc extends Bloc<Object, PostState> {
  StreamSubscription<int>? streamSubscription;
  final Post post;
  PostBloc(this.post) : super(const PostState()) {
    on<LikeClicked>(
      (event, emit) {
        if (state.reaction != null) {
          DataRepository().dataProvider.removeReaction(post, state.reaction!);
        } else {
          DataRepository().dataProvider.addReaction(
                AuthenticationRepository().authenticationService.currentUser()!,
                post,
                Reaction(
                  userId: AuthenticationRepository()
                      .authenticationService
                      .currentUser()!
                      .uid,
                  reactionType: 'like',
                  reactionDate: DateTime.now(),
                ),
              );
        }
      },
    );

    on<ListenToReactionCountChanges>(
      (event, emit) async {
        streamSubscription = DataRepository()
            .dataProvider
            .getPostReactionsCountStream(post)
            .listen(
          (event) async {
            // print(
            //     'listening to post with id: ${post.id}. CURRENT LIKES COUNT: $event');
            // if (!isClosed) {
            add(
              ReactionCountChanged(
                reactionCount: event,
                reaction:
                    await DataRepository().dataProvider.isPostReactedToByUser(
                          post,
                          AuthenticationRepository()
                              .authenticationService
                              .currentUser()!,
                        ),
              ),
            );
            // }
          },
        );
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
