import 'package:flutter/material.dart';
import 'package:smart_guide/feature/auth/domain/user_type_enum.dart';
import 'package:smart_guide/feature/auth/login/presentation/view/widget/login_appbar.dart';
import 'package:smart_guide/feature/auth/login/presentation/view/widget/login_body.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key, required this.userTypeEnum});
  final UserTypeEnum userTypeEnum;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(flexibleSpace: LoginAppbar()),
      body: LoginBody(userTypeEnum: userTypeEnum),
    );
  }
}
