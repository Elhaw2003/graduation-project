import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:smart_guide/core/shared_widgets/custom_spacing_widget.dart';
import 'package:smart_guide/core/utils/app_text_style.dart';
import 'package:smart_guide/feature/auth/domain/user_type_enum.dart';
import 'package:smart_guide/generated/locale_keys.g.dart';

class RegisterHeaderSection extends StatelessWidget {
  const RegisterHeaderSection({super.key, required this.userTypeEnum});
  final UserTypeEnum userTypeEnum;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Text(
            userTypeEnum == UserTypeEnum.tourist
                ? LocaleKeys.registerTitleAsTourist.tr()
                : LocaleKeys.registerTitleAsGuide.tr(),
            style: AppTextStyle.black1F2937W500S20,
            textAlign: TextAlign.center,
          ),
        ),
        CustomHeightSpacingWidget(height: 5),
        Center(
          child: Text(
            userTypeEnum == UserTypeEnum.tourist
                ? LocaleKeys.registerDescriptionAsTourist.tr()
                : LocaleKeys.registerDescriptionAsGuide.tr(),
            style: AppTextStyle.black1F2937W400S15,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
