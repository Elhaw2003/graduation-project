import 'package:flutter/material.dart';
import 'package:smart_guide/core/utils/app_colors.dart' show AppColors;
import 'package:smart_guide/feature/auth/choosingIdentity/presentation/view/widget/choosing_identity_body.dart';

class choosingIdentityScreen extends StatefulWidget {
  const choosingIdentityScreen({super.key});

  @override
  State<choosingIdentityScreen> createState() => _choosingIdentityScreenState();
}

class _choosingIdentityScreenState extends State<choosingIdentityScreen>
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  late final List<SlideAnimationConfig> _animationConfigs;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _controller.forward();
  }

  void _initializeAnimations() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _animationConfigs = [
      // Tourist card - slides from top
      SlideAnimationConfig(
        animation: _createSlideAnimation(
          begin: const Offset(0, -1.5),
          interval: const Interval(0.0, 0.4),
        ),
      ),
      // Guide card - slides from bottom
      SlideAnimationConfig(
        animation: _createSlideAnimation(
          begin: const Offset(0, 1.5),
          interval: const Interval(0.2, 0.6),
        ),
      ),
      // Logo - slides from top with delay
      SlideAnimationConfig(
        animation: _createSlideAnimation(
          begin: const Offset(0, -1.5),
          interval: const Interval(0.5, 1.0),
        ),
      ),
    ];
  }

  Animation<Offset> _createSlideAnimation({
    required Offset begin,
    required Interval interval,
  }) {
    return Tween<Offset>(
      begin: begin,
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: interval));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor, // Light background from image
      body: ChoosingIdentityBody(animationConfigs: _animationConfigs),
    );
  }
}

// Helper class to hold animation configuration
class SlideAnimationConfig {
  final Animation<Offset> animation;

  const SlideAnimationConfig({required this.animation});
}
