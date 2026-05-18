import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
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
          child: imageUrl.isNotEmpty
              ? CachedNetworkImage(
                  imageUrl: imageUrl.toHttps(),
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Shimmer.fromColors(
                    baseColor: AppColors.grey100Color,
                    highlightColor: AppColors.whiteColor,
                    child: Container(
                      height: 100.r,
                      width: 100.r,
                      color: AppColors.whiteColor,
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: AppColors.grey100Color,
                    child: Icon(
                      Icons.person,
                      size: 50.r,
                      color: AppColors.primaryColor,
                    ),
                  ),
                )
              : Container(
                  color: AppColors.grey100Color,
                  child: Icon(
                    Icons.person,
                    size: 50.r,
                    color: AppColors.primaryColor,
                  ),
                ),
        ),
      ),
    );
  }
}