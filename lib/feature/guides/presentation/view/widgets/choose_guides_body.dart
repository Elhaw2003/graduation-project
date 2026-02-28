import 'package:flutter/material.dart';
import 'package:smart_guide/core/shared_widgets/custom_spacing_widget.dart';
import 'package:smart_guide/core/utils/app_colors.dart';
import 'package:smart_guide/feature/auth/select_role/presentation/view/widget/select_role_widget.dart';
import 'package:smart_guide/feature/guides/presentation/view/widgets/text_section_in_choose_guide.dart';
import 'package:smart_guide/generated/assets.dart';

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
          TextSectionInChooseGuids(),
          CustomHeightSpacingWidget(height: 104),
          SelectRoleWidget(
            textColor: AppColors.secondaryColor,
            iconColor: AppColors.secondaryColor,
            isSelected: true,
            colorButton: AppColors.whiteColor,
            title: 'Human Guide',
            icon: Assets.imagesSvgPerson,
            onTap: () {},
          ),
          CustomHeightSpacingWidget(height: 32),
          SelectRoleWidget(
            textColor: AppColors.secondaryColor,
            iconColor: AppColors.secondaryColor,
            isSelected: true,
            colorButton: AppColors.whiteColor,
            title: 'Ai Guide',
            icon: Assets.imagesSvgRobot,
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
