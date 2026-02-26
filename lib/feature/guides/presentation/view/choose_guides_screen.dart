import 'package:flutter/material.dart';
import 'package:smart_guide/core/utils/app_colors.dart';
import 'package:smart_guide/feature/guides/presentation/view/widgets/choose_guides_body.dart';

class ChooseGuidesScreen extends StatelessWidget {
  const ChooseGuidesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,

      body: const ChooseGuidesBody(),
    );
  }
}
