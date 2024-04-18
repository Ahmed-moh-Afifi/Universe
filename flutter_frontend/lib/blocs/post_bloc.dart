import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:universe/models/post.dart';
import 'package:universe/models/reaction.dart';
import 'package:universe/repositories/authentication_repository.dart';
import 'package:universe/repositories/data_repository.dart';

class PostState {
  final int? reactionsCount;
  final bool? isLiked;

  const PostState({this.reactionsCount, this.isLiked});
}

class LikeClicked {
  bool isLiked;

  LikeClicked(this.isLiked);
}

class ListenToReactionCountChanges {}

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
        await DataRepository()
            .dataProvider
            .getPostReactionsCountStream(post)
            .listen(
          (event) async {
            emit(
              PostState(
                reactionsCount: event,
                isLiked: await DataRepository().dataProvider.isPostLikedByUser(
                    post,
                    AuthenticationRepository()
                        .authenticationService
                        .getUser()!),
              ),
            );
          },
        ).asFuture();
      },
    );

    add(ListenToReactionCountChanges());
  }
}
