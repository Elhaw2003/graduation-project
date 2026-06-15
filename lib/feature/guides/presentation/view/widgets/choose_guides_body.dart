import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_guide/core/routing/app_routes.dart';
import 'package:smart_guide/core/shared_widgets/custom_spacing_widget.dart';
import 'package:smart_guide/feature/guides/presentation/view/widgets/guide_selection_card.dart';
import 'package:smart_guide/feature/guides/presentation/view/widgets/text_section_in_choose_guide.dart';
import 'package:smart_guide/generated/assets.dart';
import 'package:smart_guide/generated/locale_keys.g.dart';

class ChooseGuidesBody extends StatelessWidget {
  const ChooseGuidesBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CustomHeightSpacingWidget(height: 80.h),
        TextSectionInChooseGuids(
          title: LocaleKeys.chooseYourGuide.tr(),
          subTitle: LocaleKeys.pickALocalExpertOrSmartAI.tr(),
        ),
        CustomHeightSpacingWidget(height: 60.h),
        // كارت Human Guides
        GuideSelectionCard(
          title: LocaleKeys.humanGuides.tr(),
          iconPath: Assets.imagesSvgHuman,
          isSvg: true,
          onTap: () {
            context.pushNamed(AppRoutes.allGuidesScreen);
          },
        ),
        CustomHeightSpacingWidget(height: 30.h),
        // كارت AI Guide
        // GuideSelectionCard(
        //   title: LocaleKeys.aiGuide.tr(),
        //   iconPath: Assets.imagesSvgRobot,
        //   isSvg: true,
        //   onTap: () {
        //     context.pushNamed(AppRoutes.aiGuideScreen);
        //   },
        // ),
      ],
    );
  }
}
