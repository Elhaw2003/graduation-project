import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:smart_guide/core/shared_widgets/custom_button_widget.dart';
import 'package:smart_guide/core/utils/app_text_style.dart';
import 'package:smart_guide/generated/locale_keys.g.dart';

class SendCodeButton extends StatelessWidget {
  const SendCodeButton({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomButtonWidget(
      buttonWidth: double.infinity,
      title: LocaleKeys.sendCode.tr(),
      titleStyle: AppTextStyle.whiteW600S20,
    );
  }
}
