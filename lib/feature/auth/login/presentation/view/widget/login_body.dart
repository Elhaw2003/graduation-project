import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_guide/core/shared_widgets/custom_button_widget.dart';
import 'package:smart_guide/core/shared_widgets/custom_rich_text_widget.dart';
import 'package:smart_guide/core/shared_widgets/custom_spacing_widget.dart';
import 'package:smart_guide/core/shared_widgets/custom_text_field_widget.dart';
import 'package:smart_guide/core/utils/app_colors.dart';
import 'package:smart_guide/core/utils/app_text_style.dart';
import 'package:smart_guide/feature/auth/domain/user_type_enum.dart';
import 'package:smart_guide/feature/auth/login/presentation/view/widget/login_button_widget.dart';
import 'package:smart_guide/feature/auth/login/presentation/view/widget/remember_and_forgot_wiget.dart';
import 'package:smart_guide/generated/assets.dart';
import 'package:smart_guide/generated/locale_keys.g.dart';

class LoginBody extends StatelessWidget {
  const LoginBody({super.key, required this.userTypeEnum});
  final UserTypeEnum userTypeEnum;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomHeightSpacingWidget(height: 40),
            Row(
              children: [
                CustomButtonWidget(
                  buttonWidth: 191,
                  buttonColor: userTypeEnum == UserTypeEnum.tourist
                      ? AppColors.primaryColor
                      : AppColors.whiteColor,
                  borderSideColor: userTypeEnum == UserTypeEnum.tourist
                      ? AppColors.primaryColor
                      : AppColors.whiteColor,
                  title: LocaleKeys.tourist.tr(),
                  titleStyle: userTypeEnum == UserTypeEnum.tourist
                      ? AppTextStyle.whiteW500S22
                      : AppTextStyle.primaryW500S22,
                  suffixSvgIcon: Assets.imagesSvgAirplane,
                  suffixIconColor: userTypeEnum == UserTypeEnum.tourist
                      ? AppColors.whiteColor
                      : AppColors.primaryColor,
                  suffixIconSize: 30,
                  buttonHeight: 50,
                ),
                CustomWidthSpacingWidget(width: 15),
                CustomButtonWidget(
                  buttonWidth: 191,
                  buttonHeight: 50,
                  buttonColor: userTypeEnum == UserTypeEnum.guide
                      ? AppColors.primaryColor
                      : AppColors.whiteColor,
                  borderSideColor: userTypeEnum == UserTypeEnum.guide
                      ? AppColors.primaryColor
                      : AppColors.whiteColor,
                  title: LocaleKeys.guide.tr(),
                  titleStyle: userTypeEnum == UserTypeEnum.guide
                      ? AppTextStyle.whiteW500S22
                      : AppTextStyle.primaryW500S22,
                  suffixSvgIcon: Assets.imagesSvgCompass,
                  suffixIconColor: userTypeEnum == UserTypeEnum.guide
                      ? AppColors.whiteColor
                      : AppColors.primaryColor,
                  suffixIconSize: 30,
                ),
              ],
            ),
            CustomHeightSpacingWidget(height: 10),
            Text(
              LocaleKeys.loginWelcome.tr(),
              style: AppTextStyle.primaryTextW400S15,
            ),
            CustomHeightSpacingWidget(height: 35),
            Text(
              LocaleKeys.nationalId.tr(),
              style: AppTextStyle.primaryTextW500S17,
            ),
            CustomHeightSpacingWidget(height: 5),
            CustomTextFieldWidget(hintText: LocaleKeys.enterNationalId.tr()),
            CustomHeightSpacingWidget(height: 15),
            Text(
              LocaleKeys.nationalId.tr(),
              style: AppTextStyle.primaryTextW500S17,
            ),
            CustomHeightSpacingWidget(height: 5),
            CustomTextFieldWidget(hintText: LocaleKeys.enterPassword.tr()),
            CustomHeightSpacingWidget(height: 10),
            RememberAndForgotWiget(),
            CustomHeightSpacingWidget(height: 30),
            LoginButtonWidget(),
            CustomHeightSpacingWidget(height: 10),
            Center(
              child: CustomRichTextWidget(
                title: LocaleKeys.dontHaveAccount.tr(),
                secondTitle: LocaleKeys.createAccount.tr(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
