import 'package:flutter/material.dart';
import 'package:smart_guide/core/utils/app_colors.dart';
import 'package:smart_guide/feature/explor/presentation/view/widgets/explore_ar_spots_screen_body.dart';

class ExploreArSpotsScreen extends StatelessWidget {
  const ExploreArSpotsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          color: AppColors.backgroundColor,
          child: ExploreArSpotsScreenBody(),
        ),
      ),
    );
  }
}
