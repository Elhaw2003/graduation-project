import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_guide/core/methods/custom_animated_snack_bar.dart';
import 'package:smart_guide/core/methods/input_validator.dart';
import 'package:smart_guide/core/routing/app_routes.dart';
import 'package:smart_guide/core/shared_widgets/custom_spacing_widget.dart';
import 'package:smart_guide/core/shared_widgets/custom_text_field_widget.dart';
import 'package:smart_guide/core/utils/app_colors.dart';
import 'package:smart_guide/core/utils/app_text_style.dart';
import 'package:smart_guide/feature/auth/reset_password/presentation/cubit/reset_password_cubit.dart';
import 'package:smart_guide/feature/auth/reset_password/presentation/view/widget/send_code_button.dart';
import 'package:smart_guide/generated/locale_keys.g.dart';

class ResetPasswordBody extends StatefulWidget {
  const ResetPasswordBody({super.key, required this.email});
  final String email;
  @override
  State<ResetPasswordBody> createState() => _ResetPasswordBodyState();
}

class _ResetPasswordBodyState extends State<ResetPasswordBody> {
  TextEditingController emailController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  void initState() {
    emailController.text = widget.email;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ResetPasswordCubit, ResetPasswordState>(
      listener: (context, state) {
        if (state is ResetPasswordFailureState) {
          CustomAnimatedShowSnackBar.failureSnackBar(
            context: context,
            message: state.message,
          );
        } else if (state is ResetPasswordSuccessState) {
          CustomAnimatedShowSnackBar.successSnackBar(
            context: context,
            message: state.message,
          );

          Future.delayed(const Duration(seconds: 1), () {
            // التعديل هنا لربط الـ Path Parameter بالـ userType
            if (context.mounted) {
              context.pushNamed(
                AppRoutes.verifyOtpScreen,
                extra: emailController.text.trim(),
              );
            }
          });
        }
      },
      builder: (context, state) {
        return AbsorbPointer(
          absorbing: state is ResetPasswordLoadingState,
          child: Padding(
            padding: EdgeInsets.only(right: 28.w, left: 22.w, top: 28.h),
            child: Form(
              key: formKey,
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
                  Text(
                    LocaleKeys.email.tr(),
                    style: AppTextStyle.primaryTextW500S17,
                  ),
                  CustomHeightSpacingWidget(height: 10),
                  CustomTextFieldWidget(
                    validator: (value) {
                      return Validators.validateEmail(value);
                    },
                    controller: emailController,
                    prefixIcon: Icons.email_outlined,
                    prefixColor: AppColors.grey300Color,
                    hintText: LocaleKeys.emailHintText.tr(),
                  ),
                  CustomHeightSpacingWidget(height: 30),
                  SendCodeButton(
                    email: emailController.text.trim(),
                    state: state,
                    formKey: formKey,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
