import 'package:flutter/material.dart';
import 'package:smart_guide/core/utils/app_colors.dart';
import 'package:smart_guide/feature/home/presentation/widget/home_body.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: HomeBody(),
    );
  }
}
