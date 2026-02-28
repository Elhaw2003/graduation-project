import 'package:flutter/material.dart';
import 'package:smart_guide/core/utils/app_colors.dart';
import 'package:smart_guide/feature/auth/password_reset_successfully/presentation/view/widget/password_reset_successfully_body.dart';

class PasswordResetSuccessfullyScreen extends StatelessWidget {
  const PasswordResetSuccessfullyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: AppColors.whiteColor,
      body: PasswordResetSuccessfullyBody(),
    );
  }
}
