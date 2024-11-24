import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:uuid/uuid.dart';

class ExpandableImage extends StatelessWidget {
  final String url;
  final String tag;
  const ExpandableImage(this.url, this.tag, {super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          TransparentRoute(
            builder: (context) => HeroPhotoViewRouteWrapper(
              imageProvider: CachedNetworkImageProvider(url),
              tag: tag,
            ),
          ),
        );
      },
      child: Hero(
        tag: tag,
        child: CachedNetworkImage(
          imageUrl: url,
          // loadingBuilder: (_, child, chunk) =>
          //     chunk != null ? const Text("loading") : child,
        ),
      ),
    );
  }
}

class ExpandableImageProvider extends StatelessWidget {
  final ImageProvider imageProvider;
  final Widget image;
  final String tag;
  const ExpandableImageProvider(this.imageProvider, this.tag, this.image,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          TransparentRoute(
            builder: (context) => HeroPhotoViewRouteWrapper(
              imageProvider: imageProvider,
              tag: tag,
            ),
          ),
        );
      },
      child: Hero(
        tag: tag,
        child: image,
      ),
    );
  }
}

class TransparentRoute extends PageRoute<void> {
  final WidgetBuilder builder;

  TransparentRoute({required this.builder});

  @override
  Color? get barrierColor => Colors.transparent;

  @override
  String? get barrierLabel => "Transparent Route";

  @override
  bool get maintainState => true;

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => true;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return builder(context);
  }
}

class HeroPhotoViewRouteWrapper extends StatefulWidget {
  const HeroPhotoViewRouteWrapper({
    super.key,
    required this.imageProvider,
    required this.tag,
    this.backgroundDecoration,
    this.minScale,
    this.maxScale,
  });

  final ImageProvider imageProvider;
  final BoxDecoration? backgroundDecoration;
  final dynamic minScale;
  final dynamic maxScale;
  final String tag;

  @override
  State<HeroPhotoViewRouteWrapper> createState() =>
      _HeroPhotoViewRouteWrapperState();
}

class _HeroPhotoViewRouteWrapperState extends State<HeroPhotoViewRouteWrapper>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _blurAnimation;
  double verticalDragOffset = 0.0;
  bool isClosing = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _blurAnimation = Tween<double>(begin: 0.0, end: 50.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _closeWithReverseAnimation() {
    if (!isClosing) {
      isClosing = true;
      _controller.reverse();
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: GestureDetector(
        onVerticalDragUpdate: (details) {
          setState(() {
            verticalDragOffset += details.primaryDelta ?? 0;
          });
        },
        onVerticalDragEnd: (details) async {
          if (verticalDragOffset.abs() > 100) {
            _closeWithReverseAnimation();
          } else {
            setState(() {
              verticalDragOffset = 0.0;
            });
          }
        },
        child: Stack(
          children: [
            AnimatedBuilder(
              animation: _blurAnimation,
              builder: (context, child) {
                return BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: _blurAnimation.value,
                    sigmaY: _blurAnimation.value,
                  ),
                  child: Container(
                    color: Colors.black.withOpacity(0),
                  ),
                );
              },
            ),
            Transform.translate(
              offset: Offset(0, verticalDragOffset),
              child: Hero(
                tag: widget.tag,
                child: PhotoView(
                  imageProvider: widget.imageProvider,
                  backgroundDecoration: const BoxDecoration(
                    color: Colors.transparent,
                  ),
                  minScale: PhotoViewComputedScale.contained,
                  maxScale: PhotoViewComputedScale.contained,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ExpandableItem extends StatelessWidget {
  final Widget source;
  final Widget destination;
  final String tag;
  ExpandableItem(this.source, this.destination, {super.key})
      : tag = Uuid().v4();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          TransparentRoute(
            builder: (context) => HeroItemRouteWrapper(
              destination: destination,
              tag: tag,
            ),
          ),
        );
      },
      child: Hero(
        tag: tag,
        child: source,
      ),
    );
  }
}

class HeroItemRouteWrapper extends StatefulWidget {
  const HeroItemRouteWrapper({
    super.key,
    required this.destination,
    required this.tag,
    this.backgroundDecoration,
  });

  final Widget destination;
  final BoxDecoration? backgroundDecoration;
  final String tag;

  @override
  State<HeroItemRouteWrapper> createState() => _HeroItemRouteWrapperState();
}

class _HeroItemRouteWrapperState extends State<HeroItemRouteWrapper>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _blurAnimation;
  double verticalDragOffset = 0.0;
  bool isClosing = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _blurAnimation = Tween<double>(begin: 0.0, end: 50.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _closeWithReverseAnimation() {
    if (!isClosing) {
      isClosing = true;
      _controller.reverse();
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: GestureDetector(
        onVerticalDragUpdate: (details) {
          setState(() {
            verticalDragOffset += details.primaryDelta ?? 0;
          });
        },
        onVerticalDragEnd: (details) async {
          if (verticalDragOffset.abs() > 100) {
            _closeWithReverseAnimation();
          } else {
            setState(() {
              verticalDragOffset = 0.0;
            });
          }
        },
        child: Stack(
          children: [
            AnimatedBuilder(
              animation: _blurAnimation,
              builder: (context, child) {
                return BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: _blurAnimation.value,
                    sigmaY: _blurAnimation.value,
                  ),
                  child: Container(
                    color: Colors.black.withOpacity(0),
                  ),
                );
              },
            ),
            Transform.translate(
              offset: Offset(0, verticalDragOffset),
              child: Align(
                alignment: Alignment.center,
                child: Hero(
                  tag: widget.tag,
                  child: widget.destination,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
