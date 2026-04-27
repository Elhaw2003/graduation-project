import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_guide/core/utils/app_colors.dart';
import '../utils/app_text_style.dart';

class CustomAnimatedShowSnackBar {
  static bool _isNetworkMessage(String message) {
    final m = message.toLowerCase();
    return m.contains('لا يوجد اتصال') ||
        m.contains('internet') ||
        m.contains('connection') ||
        m.contains('timeout') ||
        m.contains('dns') ||
        m.contains('network');
  }

  static void failureOrWarningSnackBar({
    required BuildContext context,
    required String message,
    MobileSnackBarPosition? mobileSnackBarPosition,
  }) {
    if (_isNetworkMessage(message)) {
      return warningSnackBar(
        context: context,
        message: message,
        mobileSnackBarPosition: mobileSnackBarPosition,
      );
    }

    return failureSnackBar(
      context: context,
      message: message,
      mobileSnackBarPosition: mobileSnackBarPosition,
    );
  }

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
          // titleText: LocaleKeys.success.tr(),
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
          // titleText: LocaleKeys.error.tr(),
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
          // titleText: LocaleKeys.warning.tr(),
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
          // titleText: LocaleKeys.info.tr(),
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
