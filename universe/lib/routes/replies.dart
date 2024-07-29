import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:universe/apis/posts_data_provider.dart';
import 'package:universe/blocs/replies_bloc.dart';
import 'package:universe/models/post.dart';
import 'package:universe/models/user.dart';
import 'package:universe/repositories/authentication_repository.dart';
import 'package:universe/route_generator.dart';
import 'package:universe/styles/text_styles.dart';
import 'package:universe/widgets/post.dart';

class Replies extends StatelessWidget {
  final Post post;
  final User user;
  final RepliesBloc bloc;
  final TextEditingController replyController = TextEditingController();

  Replies({required this.post, required this.user, super.key})
      : bloc = RepliesBloc(
          PostsDataProvider(
            AuthenticationRepository().authenticationService.currentUser()!.uid,
          ),
          post,
        );

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => bloc,
      child: BlocConsumer<RepliesBloc, RepliesState>(
        listener: (context, state) {
          if (state.state == RepliesStates.loading) {
            showDialog(
              barrierColor: const Color.fromRGBO(255, 255, 255, 0.05),
              barrierDismissible: false,
              context: context,
              builder: (context) => PopScope(
                canPop: false,
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              ),
            );
          }

          if ((state.state == RepliesStates.loaded ||
                  state.state == RepliesStates.failed) &&
              state.previousState == RepliesStates.loading) {
            RouteGenerator.mainNavigatorkey.currentState?.pop();
          }

          if (state.state == RepliesStates.failed) {
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
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                'Replies',
                style: TextStyles.titleStyle,
              ),
            ),
            body: state.state == RepliesStates.loaded
                ? SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.all(10),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(1),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: PostWidget(
                            post: post,
                            user: user,
                          ),
                        ),
                        const Divider(
                          indent: 0,
                          endIndent: 0,
                          color: Color.fromRGBO(80, 80, 80, 0.3),
                        ),
                        ListView.separated(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (context, index) => Padding(
                            padding: const EdgeInsets.only(left: 5, right: 5),
                            child: PostWidget(
                              post: state.replies![index],
                              user: state.replies![index].author!,
                            ),
                          ),
                          separatorBuilder: (context, index) => const Divider(
                            indent: 0,
                            endIndent: 0,
                            color: Color.fromRGBO(80, 80, 80, 0.3),
                          ),
                          itemCount: state.replies!.length,
                        ),
                        const SizedBox(
                          height: 100,
                        )
                      ],
                    ),
                  )
                : Container(),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton:
                LayoutBuilder(builder: (context, constraints) {
              return Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(40),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(1),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                margin: const EdgeInsets.only(left: 10, right: 10),
                width: constraints.maxWidth,
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: replyController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                            borderSide: BorderSide.none,
                          ),
                          hintText: 'Write a reply',
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => bloc.add(AddReply(replyController.text)),
                      icon: SvgPicture.asset(
                        'lib/assets/icons/share.svg',
                        colorFilter: ColorFilter.mode(
                            Theme.of(context).colorScheme.primary,
                            BlendMode.srcIn),
                      ),
                    ),
                  ],
                ),
              );
            }),
          );
        },
      ),
    );
  }
}
