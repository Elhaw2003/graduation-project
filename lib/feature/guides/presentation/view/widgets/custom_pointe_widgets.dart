import 'package:flutter/material.dart';
import 'package:smart_guide/core/utils/app_colors.dart';

class CustomPointe extends StatelessWidget {
  const CustomPointe({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: Container(
        height: 6,
        width: 6,
        decoration: BoxDecoration(
          color: AppColors.primaryTextColor,
          borderRadius: BorderRadius.circular(3),
        ),
      ),
    );
  }
}
