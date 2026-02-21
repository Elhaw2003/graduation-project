import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_guide/generated/assets.dart';

class LoginAppbar extends StatelessWidget {
  const LoginAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      actions: [
        Padding(
          padding: EdgeInsets.only(right: 10.w, left: 10.w),
          child: Image.asset(
            Assets.pngLogoWithText,
            fit: BoxFit.fill,
            width: 50.w,
            height: 50.h,
          ),
        ),
      ],
    );
  }
}
