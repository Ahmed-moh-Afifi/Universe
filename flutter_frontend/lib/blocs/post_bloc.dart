import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:universe/models/post.dart';
import 'package:universe/models/reaction.dart';
import 'package:universe/repositories/authentication_repository.dart';
import 'package:universe/repositories/data_repository.dart';

class PostState {
  final int? reactionsCount;
  final bool? isLiked;

  const PostState({this.reactionsCount = 0, this.isLiked = false});
}

class LikeClicked {
  bool isLiked;

  LikeClicked(this.isLiked);
}

class ListenToReactionCountChanges {}

class ReactionCountChanged {
  final int reactionCount;
  final bool isLiked;

  ReactionCountChanged({required this.reactionCount, required this.isLiked});
}

class PostBloc extends Bloc<Object, PostState> {
  final Post post;
  PostBloc(this.post) : super(const PostState()) {
    on<LikeClicked>(
      (event, emit) {
        DataRepository().dataProvider.addReaction(
              AuthenticationRepository().authenticationService.getUser()!,
              post,
              Reaction(
                userId: AuthenticationRepository()
                    .authenticationService
                    .getUser()!
                    .uid,
                reactionType: 'like',
                reactionDate: DateTime.now(),
              ),
            );
      },
    );

    on<ListenToReactionCountChanges>(
      (event, emit) async {
        DataRepository().dataProvider.getPostReactionsCountStream(post).listen(
          (event) async {
            print(
                'listening to post with id: ${post.id}. CURRENT LIKES COUNT: $event');
            // if (!isClosed) {
            add(
              ReactionCountChanged(
                reactionCount: event,
                isLiked: await DataRepository().dataProvider.isPostLikedByUser(
                    post,
                    AuthenticationRepository()
                        .authenticationService
                        .getUser()!),
              ),
            );
            // }
          },
        );
      },
    );

    on<ReactionCountChanged>(
      (event, emit) {
        print(
            'reactions count changed: count = ${event.reactionCount}, isLiked = ${event.isLiked}');
        emit(
          PostState(
              reactionsCount: event.reactionCount, isLiked: event.isLiked),
        );
      },
    );

    add(ListenToReactionCountChanges());
  }
}
