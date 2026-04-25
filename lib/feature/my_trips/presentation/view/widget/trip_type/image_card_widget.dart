import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_guide/core/utils/app_text_style.dart';

class ImageCardWidget extends StatelessWidget {
  const ImageCardWidget({super.key, required this.image, required this.title});

  final String image;
  final String title;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 140.w,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15.r),
            bottomLeft: Radius.circular(15.r),
          ),
          image: DecorationImage(
            image: AssetImage(
              image.isEmpty ? 'assets/images/placeholder.png' : image,
            ),
            fit: BoxFit.cover,
          ),
        ),
        alignment: Alignment.center,
        padding: EdgeInsets.all(8.r),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: AppTextStyle.whiteW500S22.copyWith(
            fontSize: 24,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
