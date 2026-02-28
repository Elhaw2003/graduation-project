import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:smart_guide/core/utils/app_text_style.dart';
import 'package:smart_guide/generated/locale_keys.g.dart';

class TextSectionInChooseGuids extends StatelessWidget {
  const TextSectionInChooseGuids({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
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
