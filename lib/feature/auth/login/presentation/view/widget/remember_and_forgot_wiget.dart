import 'package:flutter/material.dart';
import 'package:smart_guide/feature/auth/login/presentation/view/widget/reset_password_widget.dart';
import 'package:smart_guide/feature/auth/login/presentation/view/widget/remember_me_widget.dart';

class RememberAndForgotWiget extends StatelessWidget {
  const RememberAndForgotWiget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [RememberMeWidget(), ResetPasswordWidget()],
    );
  }
}
