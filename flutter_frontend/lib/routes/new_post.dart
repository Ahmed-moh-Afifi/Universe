import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:universe/blocs/new_post_bloc.dart';
import 'package:universe/route_generator.dart';

class NewPost extends StatelessWidget {
  final bloc = NewPostBloc(RouteGenerator.newPostState);
  NewPost({super.key});

  @override
  Widget build(BuildContext context) {
    final postController = TextEditingController();
    return BlocProvider<NewPostBloc>(
      create: (context) => bloc,
      child: BlocListener<NewPostBloc, NewPostState>(
        listener: (context, state) {
          if (state.state == NewPostStates.loading) {
            showDialog(
              barrierDismissible: false,
              context: context,
              builder: (context) => const PopScope(
                canPop: false,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            );
          }

          if ((state.state == NewPostStates.success ||
                  state.state == NewPostStates.failed) &&
              state.previousState == NewPostStates.loading) {
            RouteGenerator.mainNavigatorkey.currentState?.pop();
          }

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
          builder: (context, state) => Scaffold(
            bottomNavigationBar: const BottomAppBar(
              height: 0,
              shape: CircularNotchedRectangle(),
              notchMargin: 6,
            ),
            floatingActionButton: FloatingActionButton(
              shape: const CircleBorder(),
              onPressed: () => bloc.add(
                PostEvent(
                  content: postController.text,
                  images: [],
                  videos: [],
                ),
              ),
              child: SvgPicture.asset(
                'lib/assets/icons/share.svg',
                colorFilter:
                    const ColorFilter.mode(Colors.black, BlendMode.srcIn),
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            body: SingleChildScrollView(
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
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
