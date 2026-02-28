import 'package:flutter/material.dart';
import 'package:smart_guide/core/shared_widgets/custom_arrow_back_button.dart';
import 'package:smart_guide/core/utils/app_colors.dart';
import 'package:smart_guide/feature/auth/verify_email/presentation/view/widget/verify_email_body.dart';

class VerifyEmailScreen extends StatelessWidget {
  const VerifyEmailScreen({super.key, required this.email});
  final String email;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        leading: CustomArrowBackButton(),
      ),
      body: VerifyEmailBody(),
    );
  }
}
