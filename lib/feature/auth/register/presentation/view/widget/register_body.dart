import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_guide/core/shared_widgets/custom_arrow_back_button.dart';
import 'package:smart_guide/core/shared_widgets/custom_spacing_widget.dart';
import 'package:smart_guide/core/shared_widgets/custom_text_field_widget.dart';
import 'package:smart_guide/core/utils/app_colors.dart';
import 'package:smart_guide/core/utils/app_text_style.dart';
import 'package:smart_guide/feature/auth/domain/user_type_enum.dart';
import 'package:smart_guide/feature/auth/register/presentation/view/widget/custom_drop_down_field.dart';
import 'package:smart_guide/feature/auth/register/presentation/view/widget/regisetr_image_picker_section.dart';
import 'package:smart_guide/feature/auth/register/presentation/view/widget/register_button.dart';
import 'package:smart_guide/feature/auth/register/presentation/view/widget/register_header_section.dart';
import 'package:smart_guide/generated/locale_keys.g.dart';

class RegisterBody extends StatefulWidget {
  const RegisterBody({super.key, required this.userTypeEnum});
  final UserTypeEnum userTypeEnum;

  @override
  State<RegisterBody> createState() => _RegisterBodyState();
}

class _RegisterBodyState extends State<RegisterBody> {
  bool isVisiblePassword = false;
  bool isVisibleConfirmPassword = false;
  String? countrySelected;
  String? langauageSelected;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(
          left: 16.w,
          right: 16.w,
          top: 40.h,
          bottom: 40.h,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomArrowBackButton(),
            RegisterHeaderSection(userTypeEnum: widget.userTypeEnum),
            CustomHeightSpacingWidget(height: 50),
            RegisterImagePickerSection(),
            CustomHeightSpacingWidget(height: 40),
            Text(LocaleKeys.name.tr(), style: AppTextStyle.primaryTextW500S17),
            CustomHeightSpacingWidget(height: 5),
            CustomTextFieldWidget(hintText: LocaleKeys.enterFullName.tr()),
            CustomHeightSpacingWidget(height: 15),
            Text(LocaleKeys.email.tr(), style: AppTextStyle.primaryTextW500S17),
            CustomHeightSpacingWidget(height: 5),
            CustomTextFieldWidget(hintText: LocaleKeys.enterEmail.tr()),
            CustomHeightSpacingWidget(height: 15),
            Text(LocaleKeys.phone.tr(), style: AppTextStyle.primaryTextW500S17),
            CustomHeightSpacingWidget(height: 5),
            CustomTextFieldWidget(hintText: LocaleKeys.enterPhone.tr()),
            CustomHeightSpacingWidget(height: 15),
            Text(
              LocaleKeys.password.tr(),
              style: AppTextStyle.primaryTextW500S17,
            ),
            CustomHeightSpacingWidget(height: 5),
            CustomTextFieldWidget(
              hintText: LocaleKeys.enterPassword.tr(),
              helperText: LocaleKeys.passwordDescription.tr(),
              helperMaxLines: 2,
              suffixIcon: Icons.visibility_outlined,
              suffixColor: isVisiblePassword
                  ? AppColors.blackColor
                  : AppColors.secondaryTextColor,
              suffixOnPressed: () {
                setState(() {
                  isVisiblePassword = !isVisiblePassword;
                });
              },
              obscureText: !isVisiblePassword,
            ),
            CustomHeightSpacingWidget(height: 15),
            Text(
              LocaleKeys.confirmPassword.tr(),
              style: AppTextStyle.primaryTextW500S17,
            ),
            CustomHeightSpacingWidget(height: 5),
            CustomTextFieldWidget(
              hintText: LocaleKeys.confirmPassword.tr(),
              suffixIcon: Icons.visibility_outlined,
              suffixColor: isVisibleConfirmPassword
                  ? AppColors.blackColor
                  : AppColors.secondaryTextColor,
              suffixOnPressed: () {
                setState(() {
                  isVisibleConfirmPassword = !isVisibleConfirmPassword;
                });
              },
              obscureText: !isVisibleConfirmPassword,
            ),
            CustomHeightSpacingWidget(height: 15),
            Text(
              LocaleKeys.yourCountry.tr(),
              style: AppTextStyle.primaryTextW500S17,
            ),
            CustomHeightSpacingWidget(height: 5),
            CustomDropdownField(
              value: countrySelected,
              hint: LocaleKeys.selectYourCountry,
              items: ["Egypt", "USA", "France", "Congo"],
              onChanged: (value) {
                setState(() {
                  countrySelected = value;
                });
              },
            ),
            CustomHeightSpacingWidget(height: 15),
            Text(
              LocaleKeys.languagesYouSpeak.tr(),
              style: AppTextStyle.primaryTextW500S17,
            ),
            CustomHeightSpacingWidget(height: 5),
            CustomDropdownField(
              value: langauageSelected,
              hint: LocaleKeys.selectLanguagesYouSpeak.tr(),
              items: ["English", "Arabic", "French", "Congo"],
              onChanged: (value) {
                setState(() {
                  langauageSelected = value;
                });
              },
            ),
            CustomHeightSpacingWidget(height: 15),
            Text(
              LocaleKeys.briefOverview.tr(),
              style: AppTextStyle.primaryTextW500S17,
            ),
            CustomHeightSpacingWidget(height: 5),
            CustomTextFieldWidget(
              hintText: LocaleKeys.describeYourself.tr(),
              minLines: 4,
              maxLines: 6,
            ),
            CustomHeightSpacingWidget(height: 15),
            Text(
              LocaleKeys.yearsOfExperience.tr(),
              style: AppTextStyle.primaryTextW500S17,
            ),
            CustomHeightSpacingWidget(height: 5),
            CustomTextFieldWidget(
              hintText: LocaleKeys.enterYearsOfExperience.tr(),
              helperText: LocaleKeys.numbersOnly.tr(),
            ),
            CustomHeightSpacingWidget(height: 15),
            Text(
              LocaleKeys.uploadIdOrLicense.tr(),
              style: AppTextStyle.primaryTextW500S17,
            ),
            CustomHeightSpacingWidget(height: 5),
            CustomTextFieldWidget(
              hintText: LocaleKeys.clickToUpload.tr(),
              helperText:
                  LocaleKeys.uploadLimit.tr() + LocaleKeys.imageSizeLimit.tr(),
              helperMaxLines: 2,
            ),
            CustomHeightSpacingWidget(height: 30),
            RegisterButton(),
          ],
        ),
      ),
    );
  }
}
