import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_guide/core/shared_widgets/custom_arrow_back_button.dart';
import 'package:smart_guide/core/shared_widgets/custom_spacing_widget.dart';
import 'package:smart_guide/core/utils/app_text_style.dart';
import 'package:smart_guide/feature/auth/verify_phone_number/presentation/view/widget/pin_widget_code.dart';
import 'package:smart_guide/feature/auth/verify_phone_number/presentation/view/widget/verify_phone_button.dart';
import 'package:smart_guide/generated/locale_keys.g.dart';

class VerifyPhoneNumberBody extends StatefulWidget {
  const VerifyPhoneNumberBody({super.key});

  @override
  State<VerifyPhoneNumberBody> createState() => _VerifyPhoneNumberBodyState();
}

class _VerifyPhoneNumberBodyState extends State<VerifyPhoneNumberBody> {
  TextEditingController otpController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 40.h, left: 16.w, right: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomArrowBackButton(),
          Text(
            LocaleKeys.verifyPhone.tr(),
            style: AppTextStyle.black1F2937W500S20,
          ),
          CustomHeightSpacingWidget(height: 5),
          Text(LocaleKeys.haveSentOtp.tr(), style: AppTextStyle.grey300W400S16),
          CustomHeightSpacingWidget(height: 50),
          PinWidgetCode(
            otpController: otpController,
            onChanged: (value) => setState(() {
              otpController.text = value;
            }),
          ),
          CustomHeightSpacingWidget(height: 20),
          Center(
            child: Text(
              LocaleKeys.enterOtp.tr(),
              style: AppTextStyle.black1F2937W500S20,
            ),
          ),
          CustomHeightSpacingWidget(height: 30),
          VerifyPhoneButton(otpController: otpController),
          CustomHeightSpacingWidget(height: 30),
          // ResendCodeWidget(),
        ],
      ),
    );
  }
}
