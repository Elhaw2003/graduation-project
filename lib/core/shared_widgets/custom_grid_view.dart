import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smart_guide/core/routing/app_routes.dart';
import 'package:smart_guide/core/shared_widgets/custom_spacing_widget.dart';
import 'package:smart_guide/core/utils/app_colors.dart';
import 'package:smart_guide/core/utils/app_text_style.dart';

class CustomGridView extends StatelessWidget {
  const CustomGridView({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.rating,
    required this.placeId,
    required this.isSaved,
    required this.onSaveTap,
    this.city,
    this.type,
    this.period,
  });

  final String title;
  final String imageUrl;
  final dynamic rating;
  final String placeId;

  final bool isSaved;
  final VoidCallback onSaveTap;

  final String? city;
  final String? type;
  final String? period;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.push('${AppRoutes.detailsScreen}/$placeId');
      },
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 12,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// ================= IMAGE =================
            Expanded(
              flex: 6,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: imageUrl.trim().isNotEmpty
                        ? CachedNetworkImage(
                            imageUrl: imageUrl,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Shimmer.fromColors(
                              baseColor: Colors.grey.shade300,
                              highlightColor: Colors.grey.shade100,
                              child: Container(color: Colors.white),
                            ),
                            errorWidget: (context, url, error) => Container(
                              color: Colors.grey.shade200,
                              child: Icon(
                                Icons.image_not_supported,
                                size: 35.sp,
                              ),
                            ),
                          )
                        : Container(
                            color: Colors.grey.shade200,
                            child: Icon(Icons.image_not_supported, size: 35.sp),
                          ),
                  ),

                  /// GRADIENT
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withOpacity(0.05),
                            Colors.black.withOpacity(0.35),
                          ],
                        ),
                      ),
                    ),
                  ),

                  /// TYPE
                  if (type != null && type!.isNotEmpty)
                    Positioned(
                      top: 12.h,
                      left: 12.w,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 5.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30.r),
                        ),
                        child: Text(
                          type!,
                          style: TextStyle(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primaryColor,
                          ),
                        ),
                      ),
                    ),

                  /// RATING
                  Positioned(
                    bottom: 12.h,
                    right: 12.w,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 5.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.55),
                        borderRadius: BorderRadius.circular(30.r),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.star_rounded,
                            color: Colors.amber,
                            size: 14.sp,
                          ),
                          CustomWidthSpacingWidget(width: 4.w),
                          Text(
                            rating.toString(),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 11.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  /// ================= BOOKMARK =================
                  Positioned(
                    top: 12.h,
                    right: 12.w,
                    child: GestureDetector(
                      onTap: onSaveTap,
                      child: Container(
                        padding: EdgeInsets.all(8.r),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.4),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isSaved ? Icons.bookmark : Icons.bookmark_border,
                          color: isSaved
                              ? AppColors.primaryColor
                              : Colors.white,
                          size: 20.sp,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            /// ================= CONTENT =================
            Expanded(
              flex: 4,
              child: Padding(
                padding: EdgeInsets.all(12.r),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyle.primaryTextW400S16.copyWith(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    CustomHeightSpacingWidget(height: 8.h),

                    if (city != null && city!.isNotEmpty)
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            size: 15.sp,
                            color: Colors.red,
                          ),
                          CustomWidthSpacingWidget(width: 4.w),
                          Expanded(
                            child: Text(
                              city!,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 11.sp,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),

                    const Spacer(),

                    if (period != null && period!.isNotEmpty)
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 5.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Text(
                          period!,
                          style: TextStyle(
                            fontSize: 10.sp,
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
