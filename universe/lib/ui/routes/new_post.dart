import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:universe/repositories/posts_files_repository.dart';
import 'package:universe/ui/blocs/new_post_bloc.dart';
import 'package:universe/repositories/posts_repository.dart';

class NewPost extends StatefulWidget {
  final NewPostBloc bloc;
  NewPost({super.key})
      : bloc = NewPostBloc(PostsRepository(), PostsFilesRepository());

  @override
  State<NewPost> createState() => _NewPostState();
}

class _NewPostState extends State<NewPost> with TickerProviderStateMixin {
  late AnimationController _doneController;

  @override
  void initState() {
    super.initState();
    _doneController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
  }

  @override
  void dispose() {
    _doneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final postController = TextEditingController();
    return BlocProvider<NewPostBloc>(
      create: (context) => widget.bloc,
      child: BlocListener<NewPostBloc, NewPostState>(
        listener: (context, state) {
          if (state.state == NewPostStates.loading) {
            // showDialog(
            //   barrierDismissible: false,
            //   context: context,
            //   builder: (context) => const PopScope(
            //     canPop: false,
            //     child: Center(
            //       child: CircularProgressIndicator(),
            //     ),
            //   ),
            // );
          }

          // if (state.previousState == NewPostStates.loading) {
          //   RouteGenerator.mainNavigatorkey.currentState?.pop();
          // }

          if (state.state == NewPostStates.failed) {
            showDialog(
              barrierColor: const Color.fromRGBO(255, 255, 255, 0.05),
              context: context,
              builder: (context) => BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: AlertDialog(
                  title: const Text("Error"),
                  content: Text(state.error!),
                ),
              ),
            );
          }
        },
        child: BlocBuilder<NewPostBloc, NewPostState>(
          builder: (context, state) => SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: SizedBox(
                      height: 300,
                      child: TextField(
                        expands: true,
                        maxLines: null,
                        minLines: null,
                        controller: postController,
                        textAlignVertical: TextAlignVertical.top,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(20),
                            ),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Theme.of(context).colorScheme.secondary,
                          hintText: "What's on your mind?",
                        ),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onLongPress: null,
                    onPressed: () => widget.bloc.add(
                      PostEvent(
                        content: postController.text,
                        images: [],
                        videos: [],
                        audios: [],
                        widgets: [],
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        state.state == NewPostStates.informative ||
                                // Lottie.asset(
                                //     Icons8.checkmark_ok,
                                //     controller: _doneController..forward(),
                                //     width: 30,
                                //     height: 30,
                                //     frameRate: FrameRate(30),
                                //   )
                                // :
                                state.state == NewPostStates.loading
                            ? Center(
                                child: SizedBox(
                                  width: 30,
                                  height: 30,
                                  child: CircularProgressIndicator(
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                  ),
                                ),
                              )
                            : SvgPicture.asset(
                                'lib/assets/icons/share.svg',
                                colorFilter: ColorFilter.mode(
                                    Theme.of(context).primaryColor,
                                    BlendMode.srcIn),
                              ),
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('Share'),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
