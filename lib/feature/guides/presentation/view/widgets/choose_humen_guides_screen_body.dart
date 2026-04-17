import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:smart_guide/core/shared_widgets/custom_spacing_widget.dart';
import 'package:smart_guide/core/shared_widgets/custom_text_field_widget.dart';
import 'package:smart_guide/core/utils/app_colors.dart';
import 'package:smart_guide/core/utils/app_text_style.dart';
import 'package:smart_guide/feature/guides/presentation/view/widgets/custom_container_info_guides.dart';

import 'package:smart_guide/feature/guides/presentation/view/widgets/text_section_in_choose_guide.dart';
import 'package:smart_guide/generated/locale_keys.g.dart';

class ChooseHumenGuidesScreenBody extends StatelessWidget {
  const ChooseHumenGuidesScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CustomHeightSpacingWidget(height: 86),
        Center(
          child: TextSectionInChooseGuids(
            title: LocaleKeys.verifiedLocalGuides.tr(),
            subTitle: LocaleKeys
                .exploreEgyptThroughTheEyesOfExpertsWhoKnowEveryStory
                .tr(),
          ),
        ),
        CustomHeightSpacingWidget(height: 24),
        Row(
          children: [
            CustomTextFieldWidget(
              width: MediaQuery.of(context).size.width - 86,
              hintTextStyle: AppTextStyle.primaryW400S15.copyWith(
                color: AppColors.secondaryTextColor,
              ),
              hintText: LocaleKeys.searchDestinationsAndGuides.tr(),
              prefixIcon: Icons.search,
              prefixColor: AppColors.secondaryTextColor,
            ),
            CustomWidthSpacingWidget(
              width: 4,
            ),
            Container(
              height: 45,
              width: 50,
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Icon(
                Icons.filter_alt_outlined,
                color: AppColors.whiteColor,
              ),
            ),
          ],
        ),
        CustomHeightSpacingWidget(height: 32),
        ListView.separated(
          itemBuilder: (context, index) {
            return CustomContainerInfoGuides();
          },
          itemCount: 10,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),

          separatorBuilder: (context, index) {
            return CustomHeightSpacingWidget(height: 16);
          },
        ),
      ],
    );
  }
}
