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
import 'package:smart_guide/feature/auth/new_password/presentation/cubit/new_password_cubit.dart';
import 'package:smart_guide/feature/auth/new_password/presentation/view/widget/reset_password_button.dart';
import 'package:smart_guide/generated/locale_keys.g.dart';

class NewPasswordBody extends StatefulWidget {
  const NewPasswordBody({super.key, required this.email, required this.otp});
  final String email;
  final String otp;

  @override
  State<NewPasswordBody> createState() => _NewPasswordBodyState();
}

class _NewPasswordBodyState extends State<NewPasswordBody> {
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NewPasswordCubit, NewPasswordState>(
      listener: (context, state) {
        if (state is NewPasswordFailureState) {
          CustomAnimatedShowSnackBar.failureSnackBar(
            context: context,
            message: state.message,
          );
        } else if (state is NewPasswordSuccessState) {
          CustomAnimatedShowSnackBar.successSnackBar(
            context: context,
            message: state.message,
          );

          Future.delayed(const Duration(seconds: 1), () {
            // التعديل: نستخدم goNamed ونبعت الـ userType في الـ pathParameters
            if (context.mounted) {
              context.goNamed(AppRoutes.passwordResetSuccessfullyScreen);
            }
          });
        }
      },
      builder: (context, state) {
        return AbsorbPointer(
          absorbing: state is NewPasswordLoadingState,
          child: Padding(
            padding: EdgeInsets.only(right: 16.w, left: 16.w, top: 28.h),
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
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
                      validator: (value) {
                        return Validators.validatePassword(value);
                      },
                      controller: newPasswordController,
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
                      validator: (value) {
                        return Validators.validateRetypePassword(
                          value: value,
                          originalPassword: newPasswordController.text.trim(),
                        );
                      },
                      controller: confirmPasswordController,
                      prefixIcon: Icons.lock_outline,
                      prefixColor: AppColors.grey300Color,
                      hintText: LocaleKeys.confirmPassword.tr(),
                    ),
                    CustomHeightSpacingWidget(height: 30),
                    ResetPasswordButton(
                      state: state,
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          context.read<NewPasswordCubit>().newPassword(
                            email: widget.email,
                            password: newPasswordController.text.trim(),
                            confirmPassword: confirmPasswordController.text
                                .trim(),
                            otp: widget.otp,
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
