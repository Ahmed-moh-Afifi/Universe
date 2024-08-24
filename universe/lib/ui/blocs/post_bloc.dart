import 'dart:async';
import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:signalr_netcore/hub_connection_builder.dart';
import 'package:universe/interfaces/iposts_repository.dart';
import 'package:universe/models/data/post.dart';
import 'package:universe/models/data/post_reaction.dart';
import 'package:universe/repositories/authentication_repository.dart';

class PostState {
  final int? reactionsCount;
  bool isLiked;

  PostState({this.reactionsCount = 0, required this.isLiked});
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

class PostBloc extends Bloc<Object, PostState> {
  // PostReaction? reaction;
  final IPostsRepository postsRepository;
  final Post post;
  bool waitingForReactionEcho = false;
  PostBloc(this.postsRepository, this.post)
      : super(
          PostState(
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
        const serverUrl = 'http://100.107.94.17:5149/ReactionsCountHub';
        final hubConnection = HubConnectionBuilder().withUrl(serverUrl).build();
        await hubConnection.start();
        log('Connection started', name: 'PostBloc');

        log('Joining group ${post.id}', name: 'PostBloc');
        await hubConnection.invoke('JoinGroup',
            args: [hubConnection.connectionId!, post.id.toString()]);

        hubConnection.on('UpdateReactionsCount', (arguments) {
          log(arguments.toString(), name: 'PostBloc');
          if (arguments![1] as String ==
                  AuthenticationRepository()
                      .authenticationService
                      .currentUser()!
                      .id &&
              waitingForReactionEcho) {
            waitingForReactionEcho = false;
            log(hubConnection.state.toString(), name: 'PostBloc');
          } else {
            post.reactionsCount += arguments[0] as int;
            log(isClosed.toString(), name: 'PostBloc');
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
                name: 'PostBloc');
          }
        });
      },
    );

    on<ReactionsCountChanged>(
      (event, emit) async {
        emit(
          PostState(
            reactionsCount: event.reactionsCount,
            isLiked: event.isLiked,
          ),
        );
      },
    );

    add(ListenToReactionCountChanges());
  }

  @override
  Future<void> close() async {
    log('Closing PostBloc for post: ${post.id}', name: 'PostBloc');
    // await ReactionsCountHub()
    //     .unsubscribeFromPostReactionsCount(post.id.toString());
    return super.close();
  }
}
