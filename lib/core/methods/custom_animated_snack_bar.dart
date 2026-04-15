import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_guide/core/utils/app_colors.dart';
import 'package:smart_guide/generated/locale_keys.g.dart';
import '../utils/app_text_style.dart';

class CustomAnimatedShowSnackBar {
  static void successSnackBar({
    required BuildContext context,
    required String message,
    MobileSnackBarPosition? mobileSnackBarPosition,
  }) {
    AnimatedSnackBar(
      duration: const Duration(seconds: 3),
      animationDuration: const Duration(milliseconds: 400),
      mobileSnackBarPosition:
          mobileSnackBarPosition ?? MobileSnackBarPosition.bottom,
      mobilePositionSettings: MobilePositionSettings(bottomOnAppearance: 20.w),
      animationCurve: Curves.easeOutBack,
      builder: ((context) {
        return MaterialAnimatedSnackBar(
          titleText: LocaleKeys.success.tr(),
          backgroundColor: AppColors.greenColor,
          foregroundColor: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(10.r),
          iconData: Icons.done,
          titleTextStyle: AppTextStyle.whiteW500S17,
          messageTextStyle: AppTextStyle.whiteW500S17,
          messageText: message,
          type: AnimatedSnackBarType.success,
        );
      }),
    ).show(context);
  }

  static void failureSnackBar({
    required BuildContext context,
    required String message,
    MobileSnackBarPosition? mobileSnackBarPosition,
  }) {
    AnimatedSnackBar(
      duration: const Duration(seconds: 3),
      animationDuration: const Duration(milliseconds: 400),
      mobileSnackBarPosition:
          mobileSnackBarPosition ?? MobileSnackBarPosition.bottom,
      mobilePositionSettings: MobilePositionSettings(bottomOnAppearance: 20.w),
      animationCurve: Curves.easeOutBack,
      builder: ((context) {
        return MaterialAnimatedSnackBar(
          titleText: LocaleKeys.error.tr(),
          backgroundColor: AppColors.redColor,
          foregroundColor: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(15.r),
          iconData: Icons.close,
          titleTextStyle: AppTextStyle.whiteW500S17,
          messageTextStyle: AppTextStyle.whiteW500S17,
          messageText: message,
          type: AnimatedSnackBarType.error,
        );
      }),
    ).show(context);
  }

  static void warningSnackBar({
    required BuildContext context,
    required String message,
    MobileSnackBarPosition? mobileSnackBarPosition,
  }) {
    AnimatedSnackBar(
      duration: const Duration(seconds: 3),
      animationDuration: const Duration(milliseconds: 400),
      mobileSnackBarPosition:
          mobileSnackBarPosition ?? MobileSnackBarPosition.bottom,
      mobilePositionSettings: MobilePositionSettings(bottomOnAppearance: 20.w),
      animationCurve: Curves.easeOutBack,
      builder: ((context) {
        return MaterialAnimatedSnackBar(
          titleText: LocaleKeys.warning.tr(),
          backgroundColor: AppColors.orangeColor,
          foregroundColor: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(10.r),
          iconData: Icons.warning,
          titleTextStyle: AppTextStyle.whiteW500S17,
          messageTextStyle: AppTextStyle.whiteW500S17,
          messageText: message,
          type: AnimatedSnackBarType.warning,
        );
      }),
    ).show(context);
  }

  static void infoSnackBar({
    required BuildContext context,
    required String message,
    MobileSnackBarPosition? mobileSnackBarPosition,
  }) {
    AnimatedSnackBar(
      duration: const Duration(seconds: 3),
      animationDuration: const Duration(milliseconds: 400),
      mobileSnackBarPosition:
          mobileSnackBarPosition ?? MobileSnackBarPosition.bottom,
      mobilePositionSettings: MobilePositionSettings(bottomOnAppearance: 20.w),
      animationCurve: Curves.easeOutBack,
      builder: ((context) {
        return MaterialAnimatedSnackBar(
          titleText: LocaleKeys.info.tr(),
          backgroundColor: AppColors.primaryColor,
          foregroundColor: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(10.r),
          iconData: Icons.help,
          titleTextStyle: AppTextStyle.whiteW500S17,
          messageTextStyle: AppTextStyle.whiteW500S17,
          messageText: message,
          type: AnimatedSnackBarType.info,
        );
      }),
    ).show(context);
  }
}
