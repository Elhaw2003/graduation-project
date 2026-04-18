import 'package:flutter/material.dart';
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
      children: [
        Text(title, style: AppTextStyle.primaryTextW600S22),
        Text(
          subTitle,
          textAlign: TextAlign.center,
          LocaleKeys.choose_your_guide.tr(),
          style: AppTextStyle.primaryTextW600S22,
        ),
        Text(
          textAlign: TextAlign.center,
          LocaleKeys.pick_a_local_expert_or_smart_ai.tr(),
          style: AppTextStyle.secondaryTextW400S17,
        ),
      ],
    );
  }
}
