import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_guide/core/utils/app_colors.dart';
import 'package:smart_guide/core/utils/app_text_style.dart';
import 'package:smart_guide/feature/favorite/data/model/favorite_place_model.dart';
import 'package:smart_guide/generated/locale_keys.g.dart';

class FavoritePlaceCard extends StatelessWidget {
  const FavoritePlaceCard({super.key, required this.place});
  final PlaceItemModel place;
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.r),
      child: SizedBox(
        width: 140.w,
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                place.image,
                fit: BoxFit.cover,
              ),
            ),
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.blackColor.withValues(alpha: 0.25),
                      AppColors.blackColor.withValues(alpha: 0.55),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 8.h,
              right: 8.w,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.9),
                  shape: BoxShape.circle,
                ),
                child: Padding(
                  padding: EdgeInsets.all(6.r),
                  child: Icon(
                    place.isFavorite
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: AppColors.redAppColor,
                    size: 18.sp,
                  ),
                ),
              ),
            ),
            Positioned(
              left: 10.w,
              right: 10.w,
              bottom: 10.h,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    place.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyle.whiteW600S20.copyWith(
                      fontSize: 12.sp,
                      height: 1.2,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  SizedBox(
                    height: 28.h,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        foregroundColor: AppColors.whiteColor,
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        textStyle: AppTextStyle.whitePoppinsW400S16.copyWith(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      child: Text(LocaleKeys.exploreMore.tr()),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
