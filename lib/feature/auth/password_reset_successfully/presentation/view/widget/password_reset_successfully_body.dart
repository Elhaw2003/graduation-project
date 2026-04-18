import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_guide/core/routing/app_routes.dart';
import 'package:smart_guide/core/shared_widgets/custom_button_widget.dart';
import 'package:smart_guide/core/shared_widgets/custom_spacing_widget.dart';
import 'package:smart_guide/core/utils/app_text_style.dart';
import 'package:smart_guide/generated/assets.dart';
import 'package:smart_guide/generated/locale_keys.g.dart';

class PasswordResetSuccessfullyBody extends StatelessWidget {
  const PasswordResetSuccessfullyBody({super.key,});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 25.w, left: 25.w, bottom: 100.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Spacer(),
          FadeInDown(
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeOutBack,
            child: Image.asset(
              Assets.imagesPngPasswordResetSuccess,
              height: 235.h,
              width: 220.w,
            ),
          ),
          CustomHeightSpacingWidget(height: 35),
          FadeInUp(
            delay: const Duration(milliseconds: 300),
            duration: const Duration(milliseconds: 600),
            child: Text(
              LocaleKeys.passwordResetSuccess.tr(),
              textAlign: TextAlign.center,
              style: AppTextStyle.greenColorW600S20,
            ),
          ),
          CustomHeightSpacingWidget(height: 5),
          FadeInUp(
            delay: const Duration(milliseconds: 500),
            duration: const Duration(milliseconds: 600),
            child: Text(
              LocaleKeys.passwordResetSuccessMessage.tr(),
              textAlign: TextAlign.center,
              style: AppTextStyle.primary400TextW500S16,
            ),
          ),
          const Spacer(),
          FadeInUp(
            delay: const Duration(milliseconds: 700),
            duration: const Duration(milliseconds: 600),
            child: CustomButtonWidget(
              onPressed: () {
                // التعديل هنا: نستخدم goNamed ونبعت الـ userType اللي معانا
                context.goNamed(
                  AppRoutes.loginScreen,
                );
              },
              titleStyle: AppTextStyle.backgroundW600S20,
              buttonWidth: double.infinity,
              title: LocaleKeys.continu.tr(),
            ),
          ),
        ],
      ),
    );
  }
}
