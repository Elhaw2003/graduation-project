import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:smart_guide/generated/assets.dart';

class DoneLottieWidget extends StatelessWidget {
  const DoneLottieWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Lottie.asset(
      Assets.lottieDone,
      width: 250.w,
      height: 250.h,
      fit: BoxFit.contain,
      reverse: false,
      repeat: false,
    );
  }
}
