import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart_guide/generated/assets.dart';

class CustomArrowForward extends StatelessWidget {
  const CustomArrowForward({super.key, this.onPressed});
  final void Function()? onPressed;
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: SvgPicture.asset(
        Assets.imagesSvgArrowForward,
        width: 16.5.w,
        height: 16.h,
      ),
    );
  }
}
