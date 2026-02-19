import 'package:flutter/material.dart';

class AnimatedSlideItem extends StatelessWidget {
  final Animation<Offset> animation;
  final Widget child;
  final AxisDirection direction;

  const AnimatedSlideItem({
    super.key,
    required this.animation,
    required this.child,
    this.direction = AxisDirection.down,
  });

  @override
  Widget build(BuildContext context) {
    return SlideTransition(position: animation, child: child);
  }
}
