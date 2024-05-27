import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class VerifiedBadge extends StatefulWidget {
  final double width;
  final double height;
  const VerifiedBadge({this.width = 25, this.height = 25, super.key});

  @override
  VerifiedBadgeState createState() => VerifiedBadgeState();
}

class VerifiedBadgeState extends State<VerifiedBadge>
    with TickerProviderStateMixin {
  late final AnimationController _controller =
      AnimationController(duration: const Duration(seconds: 20), vsync: this)
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
            child: SvgPicture.asset(
              width: widget.width,
              height: widget.height,
              'lib/assets/icons/Universe Verification Badge Background.svg',
              colorFilter: ColorFilter.mode(
                  Theme.of(context).colorScheme.primary, BlendMode.srcIn),
            ),
          ),
          SvgPicture.asset(
            width: widget.width,
            height: widget.height,
            'lib/assets/icons/Universe Verification Badge Foreground.svg',
            colorFilter: ColorFilter.mode(
                Theme.of(context).primaryColor, BlendMode.srcIn),
          )
        ],
      ),
    );
  }
}
