import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_guide/core/shared_widgets/custom_button_widget.dart';
import 'package:smart_guide/core/shared_widgets/custom_loading_widget.dart';
import 'package:smart_guide/core/utils/app_colors.dart';
import 'package:smart_guide/feature/auth/login/presentation/cubit/login_email/login_with_email_states.dart';
import 'package:smart_guide/feature/auth/login/presentation/cubit/login_email/login_with_email_cubit.dart';
import 'package:smart_guide/generated/locale_keys.g.dart';

class LoginButtonWidget extends StatelessWidget {
  const LoginButtonWidget({
    super.key,
    required this.email,
    required this.password,
    required this.formKey,
    required this.state,
  });
  final TextEditingController email;
  final TextEditingController password;
  final GlobalKey<FormState> formKey;
  final LoginStates state;
  @override
  Widget build(BuildContext context) {
    return CustomButtonWidget(
      buttonWidth: double.infinity,
      title: LocaleKeys.login.tr(),
      buttonColor: state is LoginLoadingStates
          ? AppColors.primaryColor.withValues(alpha: 0.5)
          : AppColors.primaryColor,
      borderSideColor: state is LoginLoadingStates
          ? AppColors.primaryColor.withValues(alpha: 0.5)
          : AppColors.primaryColor,
      child: state is LoginLoadingStates
          ? const CustomLoadingWidget(
              color: AppColors.whiteColor,
              strokeAlign: -1,
              strokeWidth: 2,
              cicleHeight: 25,
              cicleWidth: 25,
            )
          : null,
      onPressed: () {
        if (formKey.currentState!.validate()) {
          context.read<LoginCubit>().login(
            email: email.text.trim(),
            password: password.text.trim(),
          );
        }
      },
    );
  }
}
