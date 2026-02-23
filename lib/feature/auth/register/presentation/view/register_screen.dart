import 'package:flutter/material.dart';
import 'package:smart_guide/core/utils/app_colors.dart';
import 'package:smart_guide/feature/auth/domain/user_type_enum.dart';
import 'package:smart_guide/feature/auth/register/presentation/view/widget/register_body.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key, required this.userTypeEnum});
  final UserTypeEnum userTypeEnum;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: RegisterBody(userTypeEnum: userTypeEnum),
    );
  }
}
