import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:universe/interfaces/idata_provider.dart';
import 'package:universe/models/post.dart';

class PostState {}

class LikeClicked {
  bool isLiked;

  LikeClicked(this.isLiked);
}

class PostBloc extends Bloc<Object, PostState> {
  IDataProvider dataProvider;
  PostBloc(this.dataProvider, Post post) : super(PostState()) {
    on<LikeClicked>(
      (event, emit) {},
    );
  }
}
