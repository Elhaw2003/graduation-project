import 'package:flutter/material.dart';
import 'package:smart_guide/core/utils/app_colors.dart';
import 'package:smart_guide/core/utils/app_text_style.dart';

class TextSectionInChooseGuids extends StatelessWidget {
  const TextSectionInChooseGuids({
    super.key,
    required this.title,
    required this.subTitle,
  });
  final String title;
  final String subTitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(title, style: AppTextStyle.primaryTextW600S22),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Text(
            subTitle,
            textAlign: TextAlign.center,
            style: AppTextStyle.primaryTextW400S15.copyWith(
              color: AppColors.grey300Color,
            ),
          ),
        ),
      ],
    );
  }
}
