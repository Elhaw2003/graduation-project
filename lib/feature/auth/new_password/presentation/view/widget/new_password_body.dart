import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_guide/core/shared_widgets/custom_spacing_widget.dart';
import 'package:smart_guide/core/shared_widgets/custom_text_field_widget.dart';
import 'package:smart_guide/core/utils/app_colors.dart';
import 'package:smart_guide/core/utils/app_text_style.dart';
import 'package:smart_guide/feature/auth/new_password/presentation/view/widget/reset_password_button.dart';
import 'package:smart_guide/generated/locale_keys.g.dart';

class NewPasswordBody extends StatelessWidget {
  const NewPasswordBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 16.w, left: 16.w, top: 28.h),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              LocaleKeys.createNewPassword.tr(),
              style: AppTextStyle.primaryTextW500S25,
            ),
            CustomHeightSpacingWidget(height: 5),
            Text(
              LocaleKeys.enterYourNewPasswordBelow.tr(),
              style: AppTextStyle.grey300W400S16,
            ),
            CustomHeightSpacingWidget(height: 30),
            Text(
              LocaleKeys.newPassword.tr(),
              style: AppTextStyle.primaryTextW500S17,
            ),
            CustomHeightSpacingWidget(height: 15),
            CustomTextFieldWidget(
              controller: TextEditingController(),
              prefixIcon: Icons.lock_outline,
              prefixColor: AppColors.grey300Color,
              hintText: LocaleKeys.enterYourPassword.tr(),
            ),
            CustomHeightSpacingWidget(height: 30),
            Text(
              LocaleKeys.confirmPassword.tr(),
              style: AppTextStyle.primaryTextW500S17,
            ),
            CustomHeightSpacingWidget(height: 10),
            CustomTextFieldWidget(
              controller: TextEditingController(),
              prefixIcon: Icons.lock_outline,
              prefixColor: AppColors.grey300Color,
              hintText: LocaleKeys.confirmPassword.tr(),
            ),
            CustomHeightSpacingWidget(height: 30),
            ResetPasswordButton(),
          ],
        ),
      ),
    );
  }
}
