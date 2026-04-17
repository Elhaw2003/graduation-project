import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_guide/core/utils/app_colors.dart';

class CustomArrowBackButton extends StatelessWidget {
  const CustomArrowBackButton({super.key, this.iconColor});
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        context.pop();
      },
      icon: Icon(Icons.arrow_back, color: iconColor ?? AppColors.primaryColor),
    );
  }
}
