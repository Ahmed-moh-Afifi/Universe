import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AnimatedVerifiedBadge extends StatefulWidget {
  final double width;
  final double height;
  const AnimatedVerifiedBadge({this.width = 25, this.height = 25, super.key});

  @override
  AnimatedVerifiedBadgeState createState() => AnimatedVerifiedBadgeState();
}

class AnimatedVerifiedBadgeState extends State<AnimatedVerifiedBadge>
    with TickerProviderStateMixin {
  late final AnimationController _controller =
      AnimationController(duration: const Duration(seconds: 10), vsync: this)
        ..repeat();
  late final Animation<double> _animation =
      CurvedAnimation(parent: _controller, curve: Curves.linear);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: Stack(
        children: [
          RotationTransition(
            turns: _animation,
            child: RepaintBoundary(
              child: SvgPicture.asset(
                width: widget.width,
                height: widget.height,
                'lib/assets/icons/Universe Verification Badge Background.svg',
                colorFilter: ColorFilter.mode(
                    Theme.of(context).colorScheme.primary, BlendMode.srcIn),
              ),
            ),
          ),
          RepaintBoundary(
            child: SvgPicture.asset(
              width: widget.width,
              height: widget.height,
              'lib/assets/icons/Universe Verification Badge Foreground.svg',
              colorFilter: ColorFilter.mode(
                  Theme.of(context).primaryColor, BlendMode.srcIn),
            ),
          )
        ],
      ),
    );
  }
}

class VerifiedBadge extends StatelessWidget {
  final double width;
  final double height;
  const VerifiedBadge({this.width = 25, this.height = 25, super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Stack(
        children: [
          RepaintBoundary(
            child: SvgPicture.asset(
              width: width,
              height: height,
              'lib/assets/icons/Universe Verification Badge Background.svg',
              colorFilter: ColorFilter.mode(
                  Theme.of(context).colorScheme.primary, BlendMode.srcIn),
            ),
          ),
          RepaintBoundary(
            child: SvgPicture.asset(
              width: width,
              height: height,
              'lib/assets/icons/Universe Verification Badge Foreground.svg',
              colorFilter: ColorFilter.mode(
                  Theme.of(context).primaryColor, BlendMode.srcIn),
            ),
          )
        ],
      ),
    );
  }
}
