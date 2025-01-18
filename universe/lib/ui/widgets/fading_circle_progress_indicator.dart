import 'dart:math';
import 'package:flutter/material.dart';

class FadingCircleLoader extends StatefulWidget {
  final int radius;
  const FadingCircleLoader({this.radius = 100, super.key});

  @override
  _FadingCircleLoaderState createState() => _FadingCircleLoaderState();
}

class _FadingCircleLoaderState extends State<FadingCircleLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.radius * 2,
      width: widget.radius * 2,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return CustomPaint(
            painter: FadingArcPainter(progress: _controller.value),
          );
        },
      ),
    );
  }
}

class FadingArcPainter extends CustomPainter {
  final double progress;

  FadingArcPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..shader = SweepGradient(
        startAngle: 0,
        endAngle: 2 * pi,
        colors: [
          Colors.white.withOpacity(0.0),
          Colors.white.withOpacity(0.8),
          Colors.white,
        ],
        stops: const [0.0, 0.7, 1.0],
        transform: GradientRotation(2 * pi * progress),
      ).createShader(
        Rect.fromCircle(
            center: size.center(Offset.zero), radius: size.width / 2),
      )
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    final Offset center = size.center(Offset.zero);
    final double radius = size.width / 2;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      0,
      2 * pi,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(FadingArcPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
