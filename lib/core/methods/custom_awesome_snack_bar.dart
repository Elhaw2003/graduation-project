import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:smart_guide/core/utils/app_colors.dart';
import 'package:smart_guide/generated/locale_keys.g.dart';

class CustomAwesomeSnackBarWidget {
  static void showSuccessSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        dismissDirection: DismissDirection.down,
        content: AwesomeSnackbarContent(
          title: LocaleKeys.success.tr(),
          message: message,
          contentType: ContentType.success,
        ),
        behavior: SnackBarBehavior.floating, // مهم للتحكم في الهوامش
        backgroundColor: Colors.transparent, // مهم علشان يظهر التصميم الأصلي
        elevation: 0, // optional
        duration: Duration(seconds: 3),
        closeIconColor: AppColors.whiteColor,
      ),
    );
  }

  static void showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: AwesomeSnackbarContent(
          title: LocaleKeys.error.tr(),
          message: message,
          contentType: ContentType.failure,
        ),
        behavior: SnackBarBehavior.floating, // مهم للتحكم في الهوامش
        backgroundColor: Colors.transparent, // مهم علشان يظهر التصميم الأصلي
        elevation: 0, // optional
        duration: Duration(seconds: 3),
      ),
    );
  }

  static void showWarningSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: AwesomeSnackbarContent(
          title: LocaleKeys.warning.tr(),
          message: message,
          contentType: ContentType.warning,
        ),
        behavior: SnackBarBehavior.floating, // مهم للتحكم في الهوامش
        backgroundColor: Colors.transparent, // مهم علشان يظهر التصميم الأصلي
        elevation: 0, // optional
        duration: Duration(seconds: 3),
      ),
    );
  }

  static void showInfoSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: AwesomeSnackbarContent(
          title: LocaleKeys.info.tr(),
          message: message,
          contentType: ContentType.help,
        ),
        behavior: SnackBarBehavior.floating, // مهم للتحكم في الهوامش
        backgroundColor: Colors.transparent, // مهم علشان يظهر التصميم الأصلي
        elevation: 0, // optional
        duration: Duration(seconds: 3),
      ),
    );
  }
}
