import 'dart:async';
import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:universe/apis/hubs/reactions_count_hub.dart';
import 'package:universe/interfaces/iposts_repository.dart';
import 'package:universe/models/data/post.dart';
import 'package:universe/models/data/post_reaction.dart';
import 'package:universe/repositories/authentication_repository.dart';
import 'package:universe/route_generator.dart';

enum PostStates { initial, loading, loaded, failed }

class PostState {
  final PostStates state;
  final int? reactionsCount;
  bool isLiked;

  PostState(
      {required this.state, this.reactionsCount = 0, required this.isLiked});
}

class LikeClicked {
  bool isLiked;

  LikeClicked(this.isLiked);
}

class ListenToReactionCountChanges {}

class ReactionsCountChanged {
  final int reactionsCount;
  final bool isLiked;

  ReactionsCountChanged(this.reactionsCount, this.isLiked);
}

class ShareClicked {
  final Post post;
  final Function finishedCallback;

  ShareClicked(this.post, this.finishedCallback);
}

class PostBloc extends Bloc<Object, PostState> {
  final IPostsRepository postsRepository;
  final Post post;
  void Function(List<Object?>?)? onReactionCallback;
  bool waitingForReactionEcho = false;

  PostBloc(this.postsRepository, this.post)
      : super(
          PostState(
            state: PostStates.initial,
            isLiked: post.reactedToByCaller,
            reactionsCount: post.reactionsCount,
          ),
        ) {
    log('PostBloc created for post: ${post.toJson()}', name: 'PostBloc');
    on<LikeClicked>(
      (event, emit) async {
        log('Like clicked for post: ${post.id}');
        waitingForReactionEcho = true;
        if (state.isLiked) {
          post.reactionsCount--;
          emit(
            PostState(
              state: state.state,
              reactionsCount: post.reactionsCount,
              isLiked: false,
            ),
          );
          await postsRepository.removeReaction(
            post.author.id,
            post.id,
            post.callerReaction!.id,
          );
          post.callerReaction = null;
          post.reactedToByCaller = false;
          log('Reaction removed', name: 'PostBloc');
        } else {
          post.reactionsCount++;
          emit(
            PostState(
              state: state.state,
              reactionsCount: post.reactionsCount,
              isLiked: true,
            ),
          );
          var reactionId = await postsRepository.addReaction(
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
          post.callerReaction = PostReaction(
            id: reactionId,
            userId: AuthenticationRepository()
                .authenticationService
                .currentUser()!
                .id,
            reactionType: 'like',
            reactionDate: DateTime.now(),
            postId: post.id,
          );
          post.reactedToByCaller = true;
          log('Reaction added: $reactionId', name: 'PostBloc');
        }
      },
    );

    on<ListenToReactionCountChanges>(
      (event, emit) async {
        log('Joining group ${post.id}',
            name: 'ListenToReactionCountChanges (PostBloc)');
        await ReactionsCountHub().invoke('JoinGroup', [post.id.toString()]);

        onReactionCallback = (arguments) {
          log(arguments.toString(),
              name: 'ListenToReactionCountChanges (PostBloc)');
          if (arguments![1] as String ==
                  AuthenticationRepository()
                      .authenticationService
                      .currentUser()!
                      .id &&
              waitingForReactionEcho) {
            waitingForReactionEcho = false;
          } else {
            post.reactionsCount += arguments[0] as int;
            log(isClosed.toString(),
                name: 'ListenToReactionCountChanges (PostBloc)');
            post.reactedToByCaller = state.isLiked;
            if (AuthenticationRepository()
                    .authenticationService
                    .currentUser()!
                    .id ==
                arguments[1] as String) {
              if (arguments[0] as int == 1) {
                post.reactedToByCaller = true;
              } else {
                post.reactedToByCaller = false;
              }
              post.callerReaction = arguments[0] as int == 1
                  ? PostReaction.fromJson(arguments[2] as Map<String, dynamic>)
                  : null;
            }
            add(ReactionsCountChanged(
                post.reactionsCount, post.reactedToByCaller));
            log('Emitted new reactions count: ${post.reactionsCount}',
                name: 'ListenToReactionCountChanges (PostBloc)');
          }
        };
        ReactionsCountHub().on('UpdateReactionsCount', onReactionCallback!);
      },
    );

    on<ReactionsCountChanged>(
      (event, emit) async {
        if (!isClosed) {
          emit(
            PostState(
              state: state.state,
              reactionsCount: event.reactionsCount,
              isLiked: event.isLiked,
            ),
          );
        }
      },
    );

    on<ShareClicked>(
      (event, emit) async {
        log('Share clicked for post: ${post.id}');
        emit(
          PostState(
            state: PostStates.loading,
            reactionsCount: post.reactionsCount,
            isLiked: post.reactedToByCaller,
          ),
        );
        var finalPost = event.post.copyWith(
            childPostId: post.childPostId != -1 ? post.childPostId : post.id);
        postsRepository.sharePost(post.author.id, finalPost);
        emit(
          PostState(
            state: PostStates.loaded,
            reactionsCount: post.reactionsCount,
            isLiked: post.reactedToByCaller,
          ),
        );
        event.finishedCallback();
        RouteGenerator.mainNavigatorkey.currentState!.pop();
      },
    );

    add(ListenToReactionCountChanges());
  }

  @override
  Future<void> close() async {
    log('Closing hubConnection for post: ${post.id}', name: 'PostBloc');
    if (onReactionCallback != null) {
      ReactionsCountHub().off('UpdateReactionsCount', onReactionCallback);
    }
    await ReactionsCountHub().invoke('LeaveGroup', [post.id.toString()]);
    log('Closing PostBloc for post: ${post.id}', name: 'PostBloc');
    return super.close();
  }
}
