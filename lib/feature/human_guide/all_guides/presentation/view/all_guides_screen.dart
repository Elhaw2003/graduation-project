// AllGuidesScreen.dart

import 'package:flutter/material.dart';
import 'package:smart_guide/core/utils/app_colors.dart';
import 'package:smart_guide/feature/human_guide/all_guides/presentation/view/widgets/all_guides_body.dart';

class AllGuidesScreen extends StatefulWidget {
  const AllGuidesScreen({super.key});

  @override
  State<AllGuidesScreen> createState() => _AllGuidesScreenState();
}

class _AllGuidesScreenState extends State<AllGuidesScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Stack(
          children: [AllGuidesBody(animationController: _animationController)],
        ),
      ),
    );
  }
}
