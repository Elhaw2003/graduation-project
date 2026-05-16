import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_guide/core/utils/app_colors.dart';
import 'package:smart_guide/core/utils/image_url_extension.dart';

class TourGuideProfileImage extends StatelessWidget {
  const TourGuideProfileImage({super.key, required this.imageUrl});
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100.r,
      width: 100.r,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.primaryColor, width: 3.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(3.r),
        child: ClipOval(
          child: Image.network(
            imageUrl.toHttps(),
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: AppColors.grey100Color,
                child: Icon(
                  Icons.person,
                  size: 50.r,
                  color: AppColors.primaryColor,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
