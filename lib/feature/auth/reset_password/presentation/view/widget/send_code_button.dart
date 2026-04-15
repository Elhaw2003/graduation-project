import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_guide/core/shared_widgets/custom_button_widget.dart';
import 'package:smart_guide/core/shared_widgets/custom_loading_widget.dart';
import 'package:smart_guide/core/utils/app_colors.dart';
import 'package:smart_guide/core/utils/app_text_style.dart';
import 'package:smart_guide/feature/auth/reset_password/presentation/cubit/reset_password_cubit.dart';
import 'package:smart_guide/generated/locale_keys.g.dart';

class SendCodeButton extends StatelessWidget {
  const SendCodeButton({
    super.key,
    required this.email,
    required this.state,
    required this.formKey,
  });
  final String email;
  final ResetPasswordState state;
  final GlobalKey<FormState> formKey;
  @override
  Widget build(BuildContext context) {
    return CustomButtonWidget(
      onPressed: () {
        if (formKey.currentState!.validate()) {
          context.read<ResetPasswordCubit>().resetPassword(email: email);
        }
      },
      buttonColor: state is ResetPasswordLoadingState
          ? AppColors.primaryColor.withValues(alpha: 0.5)
          : AppColors.primaryColor,
      borderSideColor: state is ResetPasswordLoadingState
          ? AppColors.primaryColor.withValues(alpha: 0.5)
          : AppColors.primaryColor,
      buttonWidth: double.infinity,
      title: LocaleKeys.sendCode.tr(),
      titleStyle: AppTextStyle.whiteW600S20,
      child: state is ResetPasswordLoadingState
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
