import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_guide/core/shared_widgets/custom_spacing_widget.dart';
import 'package:smart_guide/core/utils/app_text_style.dart';
import 'package:smart_guide/feature/auth/verify_email/presentation/view/widget/verify_email_button.dart';
import 'package:smart_guide/feature/auth/verify_phone_number/presentation/view/widget/pin_widget_code.dart';
import 'package:smart_guide/feature/auth/verify_phone_number/presentation/view/widget/resend_code_widget.dart';
import 'package:smart_guide/generated/locale_keys.g.dart';

class VerifyEmailBody extends StatefulWidget {
  const VerifyEmailBody({super.key});

  @override
  State<VerifyEmailBody> createState() => _VerifyEmailBodyState();
}

class _VerifyEmailBodyState extends State<VerifyEmailBody> {
  TextEditingController otpController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 28.w, left: 22.w, top: 28.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            LocaleKeys.verifyEmail.tr(),
            style: AppTextStyle.primaryTextW500S25,
          ),
          CustomHeightSpacingWidget(height: 5),
          Text(LocaleKeys.haveSentOtp.tr(), style: AppTextStyle.grey300W400S16),
          CustomHeightSpacingWidget(height: 30),
          PinWidgetCode(
            otpController: otpController,
            onChanged: (value) => setState(() {
              otpController.text = value;
            }),
          ),
          CustomHeightSpacingWidget(height: 30),
          VerifyEmailButton(otpController: otpController),
          CustomHeightSpacingWidget(height: 15),
          CustomHeightSpacingWidget(height: 15),
          ResendCodeWidget(),
        ],
      ),
    );
  }
}
