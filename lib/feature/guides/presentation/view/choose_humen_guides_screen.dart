import 'package:flutter/material.dart';
import 'package:smart_guide/core/shared_widgets/custom_arrow_back_button.dart';
import 'package:smart_guide/core/utils/app_colors.dart';
import 'package:smart_guide/feature/guides/presentation/view/widgets/choose_humen_guides_screen_body.dart';

class ChooseHumenGuidesScreen extends StatelessWidget {
  const ChooseHumenGuidesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ChooseHumenGuidesScreenBody(),
              ),

              /// Back Button
              Positioned(
                top: 103,
                left: 0,
                child: CustomArrowBackButton(
                  iconColor: AppColors.arrowBackColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
