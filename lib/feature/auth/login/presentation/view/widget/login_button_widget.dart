import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:smart_guide/core/shared_widgets/custom_button_widget.dart';
import 'package:smart_guide/generated/locale_keys.g.dart';

class LoginButtonWidget extends StatelessWidget {
  const LoginButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomButtonWidget(
      buttonWidth: double.infinity,
      title: LocaleKeys.login.tr(),
    );
  }
}
