import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_guide/core/routing/app_routes.dart';
import 'package:smart_guide/core/shared_widgets/custom_spacing_widget.dart';
import 'package:smart_guide/core/utils/app_colors.dart';
import 'package:smart_guide/feature/auth/select_role/presentation/view/widget/select_role_widget.dart';
import 'package:smart_guide/feature/guides/presentation/view/choose_humen_guides_screen.dart';
import 'package:smart_guide/feature/guides/presentation/view/widgets/text_section_in_choose_guide.dart';
import 'package:smart_guide/generated/assets.dart';
import 'package:smart_guide/generated/locale_keys.g.dart';

class ChooseGuidesBody extends StatelessWidget {
  const ChooseGuidesBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CustomHeightSpacingWidget(height: 86),
          TextSectionInChooseGuids(
            title: LocaleKeys.chooseYourGuide.tr(),
            subTitle: LocaleKeys.pickALocalExpertOrSmartAI.tr(),
          ),
          CustomHeightSpacingWidget(height: 104),
          SelectRoleWidget(
            textColor: AppColors.secondaryColor,
            iconColor: AppColors.secondaryColor,
            isSelected: true,
            colorButton: AppColors.whiteColor,
            title: 'Human Guide',
            icon: Assets.imagesSvgperson,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChooseHumenGuidesScreen(),
                ),
              );
            },
          ),
          CustomHeightSpacingWidget(height: 32),
          SelectRoleWidget(
            textColor: AppColors.secondaryColor,
            iconColor: AppColors.secondaryColor,
            isSelected: true,
            colorButton: AppColors.whiteColor,
            title: 'Ai Guide',
            icon: Assets.imagesSvgrobot,
            onTap: () {
              GoRouter.of(context).pushNamed(AppRoutes.aiGuideScreen);
            },
          ),
        ],
      ),
    );
  }
}
