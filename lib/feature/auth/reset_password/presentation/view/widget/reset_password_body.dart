import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_guide/core/shared_widgets/custom_spacing_widget.dart';
import 'package:smart_guide/core/shared_widgets/custom_text_field_widget.dart';
import 'package:smart_guide/core/utils/app_colors.dart';
import 'package:smart_guide/core/utils/app_text_style.dart';
import 'package:smart_guide/feature/auth/reset_password/presentation/view/widget/send_code_button.dart';
import 'package:smart_guide/generated/locale_keys.g.dart';

class ResetPasswordBody extends StatelessWidget {
  const ResetPasswordBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 28.w, left: 22.w, top: 28.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            LocaleKeys.enterEmail.tr(),
            style: AppTextStyle.primaryTextW500S25,
          ),
          CustomHeightSpacingWidget(height: 5),
          Text(
            LocaleKeys.enterEmailAndSendCode.tr(),
            style: AppTextStyle.grey300W400S16,
          ),
          CustomHeightSpacingWidget(height: 30),
          Text(LocaleKeys.email.tr(), style: AppTextStyle.primaryTextW500S17),
          CustomHeightSpacingWidget(height: 10),
          CustomTextFieldWidget(
            prefixIcon: Icons.email_outlined,
            prefixColor: AppColors.grey300Color,
            hintText: LocaleKeys.emailHintText.tr(),
          ),
          CustomHeightSpacingWidget(height: 30),
          SendCodeButton(),
        ],
      ),
    );
  }
}
