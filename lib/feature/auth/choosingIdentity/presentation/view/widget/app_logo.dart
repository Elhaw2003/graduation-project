import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppLogo extends StatelessWidget {
  final double width;
  final double height;

  const AppLogo({super.key, this.width = 120, this.height = 120});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/png/logo_with_text.png',
      width: width.w,
      height: height.h,
    );
  }
}
