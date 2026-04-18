import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_guide/core/shared_widgets/custom_loading_widget.dart';
import 'package:smart_guide/core/shared_widgets/custom_rich_text_widget.dart';
import 'package:smart_guide/core/utils/app_text_style.dart';
import 'package:smart_guide/feature/auth/verify_otp/presentation/cubit/resend_otp/resend_otp_cubit.dart';
import 'package:smart_guide/generated/locale_keys.g.dart';

class ResendCodeWidget extends StatefulWidget {
  const ResendCodeWidget({
    super.key,
    required this.resendOtpState,
    required this.email,
  });
  final ResendOtpState resendOtpState;
  final String email;
  @override
  State<ResendCodeWidget> createState() => _ResendCodeWidgetState();
}

class _ResendCodeWidgetState extends State<ResendCodeWidget> {
  int _resendSeconds = 60;
  Timer? _resendTimer;
  bool _canResend = true;
  @override
  void dispose() {
    _resendTimer?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _startResendTimer();
  }

  void _startResendTimer() {
    setState(() {
      _canResend = false;
      _resendSeconds = 60;
    });
    _resendTimer?.cancel();
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendSeconds > 0) {
        setState(() => _resendSeconds--);
      } else {
        setState(() => _canResend = true);
        timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: _canResend
          ? TextButton(
              onPressed: () {
                context.read<ResendOtpCubit>().resendOtp(
                  // ابعت الإيميل أو التليفون المطلوب هنا
                  email: widget.email,
                );
                _startResendTimer();
              },
              child: widget.resendOtpState is ResendOtpLoadingState
                  ? const CustomLoadingWidget(
                      cicleHeight: 25,
                      cicleWidth: 25,
                      strokeWidth: 2,
                      strokeAlign: -1,
                    )
                  : Text(
                      LocaleKeys.resend.tr(),
                      style: AppTextStyle.black1F2937W400S15.copyWith(
                        decoration: TextDecoration.underline,
                      ),
                    ),
            )
          : CustomRichTextWidget(
              title: LocaleKeys.didntReceiveCode.tr(),
              secondTitle:
                  "${LocaleKeys.resendIn.tr()} $_resendSeconds ${LocaleKeys.second.tr()}",
            ),
    );
  }
}
