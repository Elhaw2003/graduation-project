import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_guide/core/routing/app_routes.dart';
import 'package:smart_guide/core/shared_widgets/custom_button_widget.dart';
import 'package:smart_guide/core/utils/app_colors.dart';
import 'package:smart_guide/core/utils/app_text_style.dart';
import 'package:smart_guide/generated/locale_keys.g.dart';

class VerifyPhoneButton extends StatelessWidget {
  const VerifyPhoneButton({super.key, this.otpController});
  final TextEditingController? otpController;
  @override
  Widget build(BuildContext context) {
    return CustomButtonWidget(
      onPressed: otpController!.text.length != 6
          ? null
          : () {
              GoRouter.of(context).pushNamed(AppRoutes.touristApp);
            },
      buttonColor: otpController!.text.length != 6
          ? AppColors.primaryColor.withValues(alpha: 0.5)
          : AppColors.primaryColor,
      buttonWidth: double.infinity,
      titleStyle: otpController!.text.length != 6
          ? AppTextStyle.whiteW600S20.copyWith(
              color: AppColors.whiteColor.withValues(alpha: 0.5),
            )
          : AppTextStyle.whiteW500S27,
      title: LocaleKeys.verify.tr(),
    );
  }
}
