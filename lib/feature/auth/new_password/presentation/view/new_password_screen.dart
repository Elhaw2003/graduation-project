import 'package:flutter/material.dart';
import 'package:smart_guide/core/shared_widgets/custom_arrow_back_button.dart';
import 'package:smart_guide/core/utils/app_colors.dart';
import 'package:smart_guide/feature/auth/new_password/presentation/view/widget/new_password_body.dart';

class NewPasswordScreen extends StatelessWidget {
  const NewPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: AppColors.backgroundColor,
        leading: CustomArrowBackButton(),
      ),
      body: NewPasswordBody(),
    );
  }
}
