import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_guide/core/routing/app_routes.dart';
import 'package:smart_guide/core/utils/app_text_style.dart';
import 'package:smart_guide/generated/locale_keys.g.dart';

class ResetPasswordWidget extends StatelessWidget {
  const ResetPasswordWidget({super.key, required this.email});
  final TextEditingController email;
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        // التعديل الجوهري هنا: نبعت الـ Path Parameter والـ Extra مع بعض
        context.pushNamed(
          AppRoutes.resetPasswordScreen,
          extra: email.text.trim(), // تمرير الإيميل كـ extra
        );
      },
      child: Text(
        LocaleKeys.forgotPassword.tr(),
        style: AppTextStyle.primaryW400S13,
      ),
    );
  }
}
