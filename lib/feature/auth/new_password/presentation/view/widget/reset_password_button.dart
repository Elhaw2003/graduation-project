import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:smart_guide/core/shared_widgets/custom_button_widget.dart';
import 'package:smart_guide/core/shared_widgets/custom_loading_widget.dart';
import 'package:smart_guide/core/utils/app_colors.dart';
import 'package:smart_guide/core/utils/app_text_style.dart';
import 'package:smart_guide/feature/auth/new_password/presentation/cubit/new_password_cubit.dart';
import 'package:smart_guide/generated/locale_keys.g.dart';

class ResetPasswordButton extends StatelessWidget {
  const ResetPasswordButton({super.key, required this.state, this.onPressed});
  final NewPasswordState state;
  final void Function()? onPressed;
  @override
  Widget build(BuildContext context) {
    return CustomButtonWidget(
      onPressed: onPressed,
      buttonWidth: double.infinity,
      title: LocaleKeys.resetPassword.tr(),
      titleStyle: AppTextStyle.whiteW600S20,
      buttonColor: state is NewPasswordLoadingState
          ? AppColors.primaryColor.withValues(alpha: 0.5)
          : AppColors.primaryColor,
      borderSideColor: state is NewPasswordLoadingState
          ? AppColors.primaryColor.withValues(alpha: 0.5)
          : AppColors.primaryColor,
      child: state is NewPasswordLoadingState
          ? const CustomLoadingWidget(
              color: AppColors.whiteColor,
              strokeAlign: -1,
              strokeWidth: 2,
              cicleHeight: 25,
              cicleWidth: 25,
            )
          : null,
    );
  }
}
