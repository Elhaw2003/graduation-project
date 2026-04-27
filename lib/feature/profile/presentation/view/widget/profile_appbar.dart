import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_guide/core/shared_widgets/custom_button_widget.dart';
import 'package:smart_guide/core/shared_widgets/custom_spacing_widget.dart';
import 'package:smart_guide/core/utils/app_colors.dart';
import 'package:smart_guide/generated/assets.dart';
import 'package:smart_guide/core/utils/app_text_style.dart';
import 'package:smart_guide/generated/locale_keys.g.dart';

class ProfileAppbar extends StatelessWidget {
  const ProfileAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    final expandedHeight = 264.h;
    return SliverAppBar(
      expandedHeight: expandedHeight,
      pinned: true,
      stretch: true,
      elevation: 10,
      forceElevated: true,
      automaticallyImplyLeading: false,
      shadowColor: AppColors.blackColor.withOpacity(0.15),
      backgroundColor: AppColors.secondaryColor,
      leading: const BackButton(color: Colors.white),
      flexibleSpace: LayoutBuilder(
        builder: (context, constraints) {
          final topPadding = MediaQuery.of(context).padding.top;
          final minHeight = kToolbarHeight + topPadding;
          final t = ((constraints.maxHeight - minHeight) /
                  (expandedHeight - minHeight))
              .clamp(0.0, 1.0);

          return FlexibleSpaceBar(
            collapseMode: CollapseMode.pin,
            background: Opacity(
              opacity: t,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 50.r,
                    backgroundImage: AssetImage(Assets.imagesPngSphinx),
                  ),
                  CustomHeightSpacingWidget(height: 16),
                  Text('John Doe', style: AppTextStyle.whitePoppinsW500S24),
                  CustomHeightSpacingWidget(height: 8),
                  CustomButtonWidget(
                    buttonHeight: 40,
                    buttonColor: AppColors.secondaryColor,
                    borderSideColor: AppColors.whiteColor,
                    buttonWidth: 180.w,
                    borderRadiusButton: 12,
                    title: LocaleKeys.editProfile.tr(),
                    titleStyle: AppTextStyle.whitePoppinsW400S16,
                    prefixIcon: Icons.edit_outlined,
                    prefixIconColor: AppColors.whiteColor,
                    prefixIconSize: 20.sp,
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
