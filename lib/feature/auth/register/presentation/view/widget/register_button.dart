import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_guide/core/routing/app_routes.dart';
import 'package:smart_guide/core/shared_widgets/custom_button_widget.dart';
import 'package:smart_guide/generated/locale_keys.g.dart';

class RegisterButton extends StatelessWidget {
  const RegisterButton({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomButtonWidget(
      onPressed: () {
        GoRouter.of(context).pushNamed(AppRoutes.verifyPhoneNumberScreen);
      },
      buttonWidth: double.infinity,
      title: LocaleKeys.createAccount.tr(),
    );
  }
}
