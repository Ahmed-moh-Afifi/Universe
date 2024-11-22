import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:loading_btn/loading_btn.dart';
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
          if (state.state == NewPostStates.loading) {}

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
                // crossAxisAlignment: CrossAxisAlignment.stretch,
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
                  state.images.isNotEmpty
                      ? SizedBox(
                          height: 100,
                          child: ListView.builder(
                            itemCount: state.images.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              var image = state.images[index].clone();
                              return FutureBuilder(
                                  future: image.finalize().toList(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.done) {
                                      return Image.memory(
                                        (snapshot.data as List<Uint8List>)
                                            .reduce((value, element) =>
                                                Uint8List(value.length +
                                                    element.length)
                                                  ..setAll(0, value)
                                                  ..setAll(
                                                      value.length, element)),
                                        fit: BoxFit.cover,
                                      );
                                    }
                                    return const SizedBox(
                                      width: 30,
                                      height: 30,
                                      child: CircularProgressIndicator(),
                                    );
                                  });
                            },
                          ),
                        )
                      : const SizedBox(),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => widget.bloc.add(SelectImagesEvent()),
                        icon: Icon(Icons.image_outlined),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.videocam_outlined,
                        ),
                      ),
                    ],
                  ),
                  LoadingBtn(
                    height: 66,
                    width: MediaQuery.of(context).size.width,
                    borderRadius: 10,
                    animate: true,
                    loader: Container(
                      padding: const EdgeInsets.all(10),
                      child: const Center(
                        child: SpinKitDoubleBounce(
                          color: Colors.black,
                        ),
                      ),
                    ),
                    onTap: (startLoading, stopLoading, btnState) {
                      if (btnState == ButtonState.idle &&
                          state.state != NewPostStates.loading) {
                        startLoading();
                        widget.bloc.add(
                          PostEvent(
                            content: postController.text,
                            images: [],
                            videos: [],
                            audios: [],
                            widgets: [],
                            finishedCallback: stopLoading,
                          ),
                        );
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        state.state == NewPostStates.informative ||
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
