import 'package:flutter/material.dart';
import 'package:flutter_animated_icons/icons8.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:universe/blocs/new_post_bloc.dart';

class NewPost extends StatefulWidget {
  const NewPost({super.key});

  @override
  State<NewPost> createState() => _NewPostState();
}

class _NewPostState extends State<NewPost> with TickerProviderStateMixin {
  late AnimationController _doneController;
  final bloc = NewPostBloc();

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
      create: (context) => bloc,
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
              context: context,
              builder: (context) => AlertDialog(
                title: const Text("Error"),
                content: Text(state.error!),
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
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(20),
                            ),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Color.fromRGBO(80, 80, 80, 0.3),
                          hintText: "What's on your mind?",
                        ),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onLongPress: null,
                    onPressed: () => bloc.add(
                      PostEvent(
                        content: postController.text,
                        images: [],
                        videos: [],
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        state.state == NewPostStates.informative
                            ? Lottie.asset(
                                Icons8.checkmark_ok,
                                controller: _doneController..forward(),
                                width: 30,
                                height: 30,
                                frameRate: FrameRate(30),
                              )
                            : state.state == NewPostStates.loading
                                ? const Center(
                                    child: SizedBox(
                                      width: 30,
                                      height: 30,
                                      child: CircularProgressIndicator(
                                        color: Colors.black,
                                      ),
                                    ),
                                  )
                                : SvgPicture.asset(
                                    'lib/assets/icons/share.svg',
                                    colorFilter: const ColorFilter.mode(
                                        Colors.black, BlendMode.srcIn),
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
