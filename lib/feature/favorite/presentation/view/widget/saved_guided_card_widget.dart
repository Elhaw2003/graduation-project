import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smart_guide/core/routing/app_routes.dart';
import 'package:smart_guide/core/utils/app_colors.dart';
import 'package:smart_guide/core/utils/app_text_style.dart';
import 'package:smart_guide/core/utils/image_url_extension.dart';
import 'package:smart_guide/feature/favorite/data/model/saved_guided_model.dart';
import 'package:smart_guide/feature/tour_guide_profile/presentation/cubit/save_guides/save_guides_cubit.dart';

class SavedGuideCardWidget extends StatelessWidget {
  const SavedGuideCardWidget({super.key, required this.guide});
  final SavedGuideModel guide;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.pushNamed(
          AppRoutes.tourGuideProfileScreen,
          pathParameters: {'userId': guide.guideId},
        );
      },
      child: Container(
        width: double.infinity,
        height: 90.h,
        padding: EdgeInsets.all(12.r),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppColors.grey100Color),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10.r,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            /// Circular cached profile image
            ClipOval(
              child:
                  guide.profilePictureUrl != null &&
                      guide.profilePictureUrl!.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: guide.profilePictureUrl!.toHttps(),
                      height: 60.r,
                      width: 60.r,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Shimmer.fromColors(
                        baseColor: AppColors.grey100Color,
                        highlightColor: AppColors.whiteColor,
                        child: Container(
                          height: 60.r,
                          width: 60.r,
                          color: Colors.white,
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        height: 60.r,
                        width: 60.r,
                        color: AppColors.grey100Color,
                        child: Icon(
                          Icons.person,
                          color: AppColors.primaryColor,
                          size: 30.sp,
                        ),
                      ),
                    )
                  : Container(
                      height: 60.r,
                      width: 60.r,
                      color: AppColors.grey100Color,
                      child: Icon(
                        Icons.person,
                        color: AppColors.primaryColor,
                        size: 30.sp,
                      ),
                    ),
            ),
            SizedBox(width: 14.w),

            /// Guide details section
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    guide.name,
                    style: AppTextStyle.primaryTextW600S22.copyWith(
                      fontSize: 16.sp,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 14.sp,
                        color: AppColors.secondaryTextColor,
                      ),
                      SizedBox(width: 4.w),
                      Flexible(
                        child: Text(
                          guide.location,
                          style: AppTextStyle.primaryTextW400S14.copyWith(
                            fontSize: 12.sp,
                            color: AppColors.secondaryTextColor,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            /// Remove button (circular X icon)
            GestureDetector(
              onTap: () {
                context.read<SavedGuidesCubit>().removeGuide(
                  guideId: guide.guideId,
                );
              },
              child: Container(
                padding: EdgeInsets.all(10.r),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.close, color: Colors.redAccent, size: 25.sp),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
