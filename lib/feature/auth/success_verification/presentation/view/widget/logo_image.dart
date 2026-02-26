import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_guide/generated/assets.dart';

class LogoImage extends StatelessWidget {
  const LogoImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      Assets.imagesPngLogoWithText,
      fit: BoxFit.fill,
      width: 150.w,
      height: 150.h,
    );
  }
}
