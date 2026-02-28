import 'package:flutter/material.dart';
import 'package:smart_guide/core/shared_widgets/custom_arrow_back_button.dart';
import 'package:smart_guide/core/utils/app_colors.dart';
import 'package:smart_guide/feature/auth/reset_password/presentation/view/widget/reset_password_body.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        leading: CustomArrowBackButton(),
      ),
      body: ResetPasswordBody(),
    );
  }
}
