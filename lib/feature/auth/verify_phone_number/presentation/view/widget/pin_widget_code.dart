import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:smart_guide/core/utils/app_colors.dart';

class PinWidgetCode extends StatelessWidget {
  const PinWidgetCode({super.key, required this.otpController, this.onChanged});
  final TextEditingController otpController;
  final void Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return PinCodeTextField(
      appContext: context,
      pastedTextStyle: TextStyle(
        color: AppColors.primaryColor,
        fontWeight: FontWeight.bold,
      ),
      length: 6,
      animationType: AnimationType.scale,
      animationCurve: Curves.easeInOut,
      animationDuration: const Duration(milliseconds: 200),
      separatorBuilder: (context, index) {
        if (index == 2) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            child: SizedBox(
              width: 15.w,
              child: Divider(
                color: AppColors.blackColor,
                thickness: 3.w,
                height: 3,
              ),
            ),
          );
        }
        return SizedBox(width: 8.w);
      },
      pinTheme: PinTheme(
        shape: PinCodeFieldShape.box,
        borderRadius: BorderRadius.circular(12.r),
        inactiveBorderWidth: 1.w,
        activeBorderWidth: 1.w,
        fieldHeight: 50.h,
        fieldWidth: 50.w,
        activeFillColor: Colors.transparent,
        activeColor: AppColors.primaryColor,
        inactiveFillColor: Colors.transparent,
        inactiveColor: AppColors.blackColor,
        selectedFillColor: Colors.transparent,
        selectedColor: AppColors.primaryColor,
      ),
      cursorColor: AppColors.blackColor,
      showCursor: true,
      enableActiveFill: true,
      controller: otpController,
      keyboardType: TextInputType.number,
      onChanged: onChanged,
      // validator: (value) {
      //   return Validators.validateOtp(value);
      // },
    );
  }
}
