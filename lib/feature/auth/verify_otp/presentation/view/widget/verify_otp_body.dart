import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_guide/core/methods/custom_animated_snack_bar.dart';
import 'package:smart_guide/core/routing/app_routes.dart';
import 'package:smart_guide/core/shared_widgets/custom_spacing_widget.dart';
import 'package:smart_guide/core/utils/app_text_style.dart';
import 'package:smart_guide/feature/auth/verify_otp/presentation/cubit/resend_otp/resend_otp_cubit.dart';
import 'package:smart_guide/feature/auth/verify_otp/presentation/cubit/verify_otp/verify_otp_cubit.dart';
import 'package:smart_guide/feature/auth/verify_otp/presentation/view/widget/verify_otp_button.dart';
import 'package:smart_guide/feature/auth/verify_phone_number/presentation/view/widget/pin_widget_code.dart';
import 'package:smart_guide/feature/auth/verify_phone_number/presentation/view/widget/resend_code_widget.dart';
import 'package:smart_guide/generated/locale_keys.g.dart';

class VerifyOtpBody extends StatefulWidget {
  const VerifyOtpBody({super.key, required this.email});
  final String email;
  @override
  State<VerifyOtpBody> createState() => _VerifyEmailOtpState();
}

class _VerifyEmailOtpState extends State<VerifyOtpBody> {
  TextEditingController otpController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<VerifyOtpCubit, VerifyOtpState>(
      listener: (context, state) {
        if (state is VerifyOtpFailureState) {
          CustomAnimatedShowSnackBar.failureOrWarningSnackBar(
            context: context,
            message: state.message,
          );
        } else if (state is VerifyOtpSuccessState) {
          CustomAnimatedShowSnackBar.successSnackBar(
            context: context,
            message: state.message,
          );

          Future.delayed(const Duration(seconds: 1), () {
            // التعديل لضمان استمرار الـ userType في الـ Path
            if (context.mounted) {
              context.pushNamed(
                AppRoutes.newPasswordScreen,
                extra: {"email": widget.email, "otp": otpController.text},
              );
            }
          });
        }
      },
      builder: (context, state) {
        return BlocConsumer<ResendOtpCubit, ResendOtpState>(
          listener: (context, resendOtpState) {
            if (resendOtpState is ResendOtpFailureState) {
              CustomAnimatedShowSnackBar.failureOrWarningSnackBar(
                context: context,
                message: resendOtpState.message,
              );
            }
            // if (resendOtpState is ResendOtpSuccessState) {
            //   CustomAnimatedShowSnackBar.successSnackBar(
            //     context: context,
            //     message: resendOtpState.message,
            //   );
            // }
          },
          builder: (context, resendOtpState) {
            return AbsorbPointer(
              absorbing:
                  state is VerifyOtpLoadingState ||
                  resendOtpState is ResendOtpLoadingState,
              child: Padding(
                padding: EdgeInsets.only(right: 28.w, left: 22.w, top: 28.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      LocaleKeys.verifyEmail.tr(),
                      style: AppTextStyle.primaryTextW500S25,
                    ),
                    CustomHeightSpacingWidget(height: 5),
                    Text(
                      "${LocaleKeys.haveSentOtp.tr()} ${widget.email}",
                      style: AppTextStyle.grey300W400S16,
                    ),
                    CustomHeightSpacingWidget(height: 30),
                    PinWidgetCode(
                      otpController: otpController,
                      onChanged: (value) => setState(
                        () {},
                      ), // الـ Controller كدة كدة قيمته اتحدثت
                    ),
                    CustomHeightSpacingWidget(height: 30),
                    VerifyOtpButton(
                      otpController: otpController,
                      email: widget.email,
                      state: state,
                    ),
                    CustomHeightSpacingWidget(height: 15),
                    CustomHeightSpacingWidget(height: 15),
                    ResendCodeWidget(
                      resendOtpState: resendOtpState,
                      email: widget.email,
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
