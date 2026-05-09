import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_guide/core/utils/app_text_style.dart';

class DetailsTourTitleTextWidget extends StatelessWidget {
  const DetailsTourTitleTextWidget({super.key, required this.text});
  final String text;
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTextStyle.primaryTextW400S16.copyWith(
        fontSize: 13.5.sp,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}
