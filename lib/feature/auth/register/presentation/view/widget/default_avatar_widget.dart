import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_guide/generated/assets.dart';

class DefaultAvatarWidget extends StatelessWidget {
  const DefaultAvatarWidget({super.key});
  @override
  Widget build(BuildContext context) {
    return Image.asset(
      Assets.imagesPngSubtract,
      width: 150.w,
      height: 150.h,
      fit: BoxFit.fill,
    );
  }
}
