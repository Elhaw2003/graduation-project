import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:smart_guide/core/shared_widgets/custom_spacing_widget.dart';
import 'package:smart_guide/core/shared_widgets/custom_text_field_widget.dart';
import 'package:smart_guide/core/utils/app_colors.dart';
import 'package:smart_guide/feature/home/presentation/widget/custom_container_for_filters.dart'
    show CustomContainerForFilters;
import 'package:smart_guide/generated/locale_keys.g.dart';

class CustomContainerForSearch extends StatelessWidget {
  const CustomContainerForSearch({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12.0),
      child: Container(
        width: double.infinity,
        height: 150,
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              CustomTextFieldWidget(
                suffixIcon: Icons.search,
                suffixColor: AppColors.primaryColor,
                hintTextStyle: TextStyle(color: AppColors.secondaryTextColor),
                hintText: LocaleKeys.searchDestinationsAndGuides.tr(),
                fillColor: AppColors.backgroundColor,
              ),
              CustomHeightSpacingWidget(height: 16),
              CustomContainerForFilters(),
            ],
          ),
        ),
      ),
    );
  }
}
