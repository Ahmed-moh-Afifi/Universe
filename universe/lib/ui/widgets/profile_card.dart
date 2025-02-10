import 'package:flip_card/flip_card.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:universe/models/data/user.dart';
import 'package:universe/repositories/authentication_repository.dart';
import 'package:universe/repositories/chats_repository.dart';
import 'package:universe/repositories/posts_repository.dart';
import 'package:universe/repositories/users_repository.dart';
import 'package:universe/route_generator.dart';
import 'package:universe/ui/blocs/profile_card_bloc.dart';
import 'package:universe/ui/styles/text_styles.dart';
import 'package:universe/ui/widgets/expandable_image.dart';
import 'package:universe/ui/widgets/verified_badge.dart';

class ProfileCard extends StatefulWidget {
  final User user;
  final int? postsCount;
  final int? followersCount;
  final int? followingCount;
  final ProfileCardBloc bloc;
  ProfileCard(
      this.user, this.postsCount, this.followersCount, this.followingCount,
      {super.key})
      : bloc = ProfileCardBloc(
            UsersRepository(), PostsRepository(), ChatsRepository(), user);

  @override
  State<ProfileCard> createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> {
  FlipCardController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = FlipCardController();
    Future.delayed(Duration(milliseconds: 1000), () async {
      await hint();
    });
  }

  Future<void> hint() async {
    if (mounted) {
      await _controller!.toggleCard();
      await Future.delayed(Duration(milliseconds: 600));
      if (mounted) {
        await _controller!.toggleCard();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FlipCard(
      fill: Fill.fillBack,
      controller: _controller,
      flipOnTouch: true,
      front: GestureDetector(
        onHorizontalDragEnd: (details) {
          if (details.primaryVelocity! < 0) {
            _controller!.toggleCard();
          }
        },
        child: Container(
          margin: const EdgeInsets.all(0),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: Theme.of(context).colorScheme.secondary),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            children: [
              widget.user.id ==
                      AuthenticationRepository()
                          .authenticationService
                          .currentUser()!
                          .id
                  ? Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        onPressed: () => RouteGenerator
                            .mainNavigatorkey.currentState!
                            .pushNamed(
                          RouteGenerator.editProfile,
                          arguments: RouteGenerator.profile,
                        ),
                        icon: Icon(Icons.edit),
                      ),
                    )
                  : const SizedBox(
                      width: 0,
                      height: 0,
                    ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    margin: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(60),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: ExpandableImage(
                      widget.user.photoUrl ?? 'https://via.placeholder.com/150',
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${widget.user.firstName} ${widget.user.lastName}',
                          style: TextStyles.titleStyle,
                        ),
                        widget.user.verified
                            ? const Padding(
                                padding: EdgeInsets.only(left: 10),
                                child: AnimatedVerifiedBadge(),
                              )
                            : const SizedBox(
                                width: 0,
                                height: 0,
                              ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Text(
                      '@${widget.user.userName}',
                      style: TextStyles.subtitleStyle,
                    ),
                  ),
                  IntrinsicHeight(
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SizedBox(
                            width: 100,
                            child: TextButton(
                              style: const ButtonStyle(
                                surfaceTintColor:
                                    WidgetStatePropertyAll(Colors.transparent),
                                overlayColor:
                                    WidgetStatePropertyAll(Colors.transparent),
                                splashFactory: NoSplash.splashFactory,
                              ),
                              onPressed: () {},
                              child: Column(
                                children: [
                                  Text((widget.postsCount ?? '').toString()),
                                  Text(
                                    'posts',
                                    style: TextStyles.subtitleStyle,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const VerticalDivider(
                            width: 1,
                            thickness: 1,
                            color: Color.fromRGBO(80, 80, 80, 0.3),
                          ),
                          SizedBox(
                            width: 100,
                            child: TextButton(
                              style: const ButtonStyle(
                                surfaceTintColor:
                                    WidgetStatePropertyAll(Colors.transparent),
                                overlayColor:
                                    WidgetStatePropertyAll(Colors.transparent),
                                splashFactory: NoSplash.splashFactory,
                              ),
                              onPressed: () => RouteGenerator
                                  .mainNavigatorkey.currentState!
                                  .pushNamed(
                                RouteGenerator.followersPage,
                                arguments: widget.user,
                              ),
                              child: Column(
                                children: [
                                  Text(
                                      (widget.followersCount ?? '').toString()),
                                  Text(
                                    'followers',
                                    style: TextStyles.subtitleStyle,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const VerticalDivider(
                            width: 1,
                            thickness: 1,
                            color: Color.fromRGBO(80, 80, 80, 0.3),
                          ),
                          SizedBox(
                            width: 100,
                            child: TextButton(
                              style: const ButtonStyle(
                                surfaceTintColor:
                                    WidgetStatePropertyAll(Colors.transparent),
                                overlayColor:
                                    WidgetStatePropertyAll(Colors.transparent),
                                splashFactory: NoSplash.splashFactory,
                              ),
                              onPressed: () => RouteGenerator
                                  .mainNavigatorkey.currentState!
                                  .pushNamed(
                                RouteGenerator.followingPage,
                                arguments: widget.user,
                              ),
                              child: Column(
                                children: [
                                  Text(
                                      (widget.followingCount ?? '').toString()),
                                  Text(
                                    'following',
                                    style: TextStyles.subtitleStyle,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      back: GestureDetector(
        onHorizontalDragEnd: (details) {
          if (details.primaryVelocity! > 0) {
            _controller!.toggleCard();
          }
        },
        child: Container(
          margin: const EdgeInsets.all(0),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: Theme.of(context).colorScheme.secondary),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                widget.user.bio == null || widget.user.bio!.isEmpty
                    ? ''
                    : 'About',
                style: widget.user.bio == null || widget.user.bio!.isEmpty
                    ? TextStyles.subtitleStyle
                    : TextStyles.titleStyle,
              ),
              widget.user.bio == null || widget.user.bio!.isEmpty
                  ? const SizedBox(
                      width: 0,
                      height: 0,
                    )
                  : Text(
                      widget.user.bio!,
                      style: TextStyles.subtitleStyle,
                    ),
              Spacer(),
              Container(
                height: 45,
                margin: const EdgeInsets.only(bottom: 10),
                child: TextButton(
                  style: ButtonStyle(
                      shape: WidgetStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                      side: BorderSide(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  )),
                  onPressed: () => widget.bloc.add(const ChatEvent()),
                  child: Text(
                    'Message',
                    style: TextStyles.subtitleStyle.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: ExpandableItem(
                      Material(
                        color: Colors.transparent,
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            // color: Color.fromRGBO(35, 35, 35, 1),
                            border: Border.all(
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                          child: Center(
                            child: Text('Contact Info',
                                style: TextStyles.subtitleStyle.copyWith(
                                    fontWeight: FontWeight.bold, fontSize: 16)),
                          ),
                        ),
                      ),
                      Material(
                        color: Colors.transparent,
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.8,
                          height: 300,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: Theme.of(context).colorScheme.surface,
                            border: Border.all(
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                          padding: const EdgeInsets.all(30),
                          child: Text(
                            'Email: ${widget.user.email}',
                            style: TextStyles.subtitleStyle,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: widget.user.links != null ? 5 : 0),
                  widget.user.links != null
                      ? Expanded(
                          child: ExpandableItem(
                            Material(
                              color: Colors.transparent,
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  // color: Color.fromRGBO(35, 35, 35, 1),
                                  border: Border.all(
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                  ),
                                ),
                                child: Center(
                                  child: Text('Links',
                                      style: TextStyles.subtitleStyle.copyWith(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16)),
                                ),
                              ),
                            ),
                            Material(
                              color: Colors.transparent,
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.8,
                                height: 300,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: Theme.of(context).colorScheme.surface,
                                  border: Border.all(
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                  ),
                                ),
                                padding: const EdgeInsets.all(30),
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      ListView.builder(
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemCount: widget.user.links?.length,
                                        itemBuilder: (context, index) =>
                                            TextButton(
                                          style: ButtonStyle(
                                            alignment: Alignment.centerLeft,
                                          ),
                                          onPressed: () => widget.bloc.add(
                                            OpenLinkEvent(
                                              type: LinkType.http,
                                              link: widget.user.links![index],
                                            ),
                                          ),
                                          child: Text(
                                            widget.user.links![index],
                                            style: TextStyles.subtitleStyle,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      : const SizedBox(width: 0),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
