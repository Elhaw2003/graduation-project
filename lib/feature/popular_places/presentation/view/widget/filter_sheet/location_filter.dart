import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:smart_guide/core/utils/app_text_style.dart';
import 'package:smart_guide/core/utils/app_colors.dart';
import 'package:smart_guide/core/shared_widgets/custom_spacing_widget.dart';
import 'package:smart_guide/core/shared_widgets/custom_text_field_widget.dart';
import 'package:smart_guide/generated/locale_keys.g.dart';

class LocationFilter extends StatelessWidget {
  const LocationFilter({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocaleKeys.location.tr(),
          style: AppTextStyle.primaryPoppinsTextW600S18,
        ),
        const CustomHeightSpacingWidget(height: 12),
        CustomTextFieldWidget(
          hintText: LocaleKeys.searchForCityOrPlace.tr(),
          fillColor: AppColors.backgroundColor,
          suffixIcon: Icons.search,
          suffixColor: AppColors.primaryColor,
        ),
      ],
    );
  }
}
