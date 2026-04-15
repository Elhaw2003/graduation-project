import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_guide/core/routing/app_routes.dart';
import 'package:smart_guide/core/shared_widgets/custom_button_widget.dart';
import 'package:smart_guide/core/shared_widgets/custom_spacing_widget.dart';
import 'package:smart_guide/core/utils/app_text_style.dart';
import 'package:smart_guide/feature/auth/success_verification/presentation/view/widget/background_image_widget.dart';
import 'package:smart_guide/feature/auth/success_verification/presentation/view/widget/done_lottie_widget.dart';
import 'package:smart_guide/feature/auth/success_verification/presentation/view/widget/logo_image.dart';
import 'package:smart_guide/generated/locale_keys.g.dart';

class SuccessVerificationBody extends StatelessWidget {
  const SuccessVerificationBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        BackgroundImageWidget(),
        Padding(
          padding: EdgeInsets.only(
            top: 100.h,
            bottom: 100.h,
            right: 25.w,
            left: 25.w,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              LogoImage(),
              CustomHeightSpacingWidget(height: 50),
              DoneLottieWidget(),
              CustomHeightSpacingWidget(height: 20),
              Text(
                LocaleKeys.registerSuccessfully.tr(),
                style: AppTextStyle.backgroundW500S20,
              ),
              CustomHeightSpacingWidget(height: 5),
              Text(
                LocaleKeys.welcomeMessage.tr(),
                style: AppTextStyle.backgroundW500S15,
              ),
              CustomHeightSpacingWidget(height: 10),
              Text(
                LocaleKeys.accountReady.tr(),
                style: AppTextStyle.backgroundW500S15.copyWith(fontSize: 14.sp),
              ),
              Spacer(),
              CustomButtonWidget(
                buttonWidth: double.infinity,
                title: LocaleKeys.loginPrompt.tr(),
                titleStyle: AppTextStyle.whiteW600S20.copyWith(
                  fontWeight: FontWeight.w500,
                ),
                onPressed: () {
                  context.go(AppRoutes.loginScreen);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
