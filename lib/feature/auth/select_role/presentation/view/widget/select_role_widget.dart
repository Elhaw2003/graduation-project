import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smart_guide/core/shared_widgets/custom_spacing_widget.dart';
import 'package:smart_guide/core/utils/app_colors.dart';
import 'package:smart_guide/core/utils/app_text_style.dart';

class SelectRoleWidget extends StatelessWidget {
  const SelectRoleWidget({
    super.key,
    required this.title,
    required this.icon,
    this.onTap,
    this.colorButton,
    this.isSelected,
  });
  final String title;
  final String icon;
  final void Function()? onTap;
  final Color? colorButton;
  final bool? isSelected;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        curve: Curves.fastOutSlowIn,
        duration: Duration(milliseconds: 300),
        height: 200.h,
        width: 190.w,
        decoration: BoxDecoration(
          color: colorButton ?? AppColors.primaryColor,
          // border: Border.all(color: AppColors.grey100Color),
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            if (isSelected!)
              BoxShadow(
                color: AppColors.primaryColor.withAlpha(40),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ignore: deprecated_member_use
            SvgPicture.asset(
              icon,
              height: 80.h,
              width: 80.w,
              colorFilter: ColorFilter.mode(
                AppColors.whiteColor,
                BlendMode.srcIn,
              ),
            ),
            CustomHeightSpacingWidget(height: 5),
            Text(title, style: AppTextStyle.whiteW600S25),
          ],
        ),
      ),
    );
  }
}
