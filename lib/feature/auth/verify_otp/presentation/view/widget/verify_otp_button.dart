import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:smart_guide/core/shared_widgets/custom_button_widget.dart';
import 'package:smart_guide/core/shared_widgets/custom_loading_widget.dart';
import 'package:smart_guide/core/utils/app_colors.dart';
import 'package:smart_guide/core/utils/app_text_style.dart';
import 'package:smart_guide/feature/auth/verify_otp/presentation/cubit/verify_otp/verify_otp_cubit.dart';
import 'package:smart_guide/generated/locale_keys.g.dart';

class VerifyOtpButton extends StatelessWidget {
  const VerifyOtpButton({
    super.key,
    required this.state,
    this.otpController,
    this.email,
  });
  final TextEditingController? otpController;
  final VerifyOtpState state;
  final String? email;
  @override
  Widget build(BuildContext context) {
    return CustomButtonWidget(
      onPressed:
          (otpController?.text.length ?? 0) < 6 ||
              state is VerifyOtpLoadingState
          ? null
          : () {
              context.read<VerifyOtpCubit>().verifyOtp(
                email: email ?? '',
                otp: otpController!.text,
              );
            },
      buttonColor:
          otpController!.text.length != 6 || state is VerifyOtpLoadingState
          ? AppColors.primaryColor.withValues(alpha: 0.5)
          : AppColors.primaryColor,
      borderSideColor:
          otpController!.text.length != 6 || state is VerifyOtpLoadingState
          ? AppColors.primaryColor.withValues(alpha: 0.5)
          : AppColors.primaryColor,
      buttonWidth: double.infinity,
      titleStyle: otpController!.text.length != 6
          ? AppTextStyle.whiteW600S20.copyWith(
              color: AppColors.whiteColor.withValues(alpha: 0.5),
            )
          : AppTextStyle.whiteW500S27,
      title: LocaleKeys.verify.tr(),
      child: state is VerifyOtpLoadingState
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
