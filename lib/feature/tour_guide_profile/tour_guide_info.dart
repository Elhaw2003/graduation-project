import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smart_guide/core/utils/app_colors.dart';
import 'package:smart_guide/core/utils/app_text_style.dart';
import 'package:smart_guide/generated/assets.dart';

class TourGuideInfoDetiles extends StatelessWidget {
  const TourGuideInfoDetiles({
    super.key,
    required this.firstName,
    required this.lastName,
    required this.rating,
    required this.price,
    required this.number,
    required this.cities,
  });

  final String firstName;
  final String lastName;
  final String rating;
  final String price;
  final String number;
  final List<String> cities;

  @override
  Widget build(BuildContext context) {
    // Dynamic calculation of text for covered cities or falling back to default
    final String locationText = cities.isNotEmpty ? cities.join(' / ') : 'Cairo / Giza';

    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Flexible(
                child: Text(
                  '${firstName.isNotEmpty ? firstName : 'Local'} ${lastName.isNotEmpty ? lastName : 'Guide'}',
                  style: AppTextStyle.primaryTextW500S17.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.sp,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(width: 6.w),
              SvgPicture.asset(
                Assets.imagesSvgVerified,
                width: 20.w,
                height: 20.h,
              ),
            ],
          ),
          SizedBox(height: 6.h),
          Row(
            children: [
              Text(
                'Trips +150',
                style: AppTextStyle.primaryTextW400S14.copyWith(
                  color: AppColors.secondaryColor,
                  fontSize: 12.sp,
                ),
              ),
              SizedBox(width: 8.w),
              Text(
                '•',
                style: AppTextStyle.primaryTextW400S14.copyWith(
                  color: AppColors.secondaryColor,
                  fontSize: 12.sp,
                ),
              ),
              SizedBox(width: 8.w),
              SvgPicture.asset(
                Assets.imagesSvgLocationIcon,
                width: 14.w,
                height: 14.h,
              ),
              SizedBox(width: 4.w),
              Flexible(
                child: Text(
                  locationText,
                  style: AppTextStyle.primaryTextW400S14.copyWith(
                    color: AppColors.secondaryColor,
                    fontSize: 12.sp,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(width: 8.w),
              Text(
                '•',
                style: AppTextStyle.primaryTextW400S14.copyWith(
                  color: AppColors.secondaryColor,
                  fontSize: 12.sp,
                ),
              ),
              SizedBox(width: 8.w),
              Text(
                price,
                style: AppTextStyle.primaryTextW400S14.copyWith(
                  color: AppColors.secondaryColor,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}