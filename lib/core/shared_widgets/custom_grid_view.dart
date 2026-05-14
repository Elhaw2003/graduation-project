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
    this.city,
    this.type,
    this.period,
  });

  final String title;
  final String imageUrl;
  final dynamic rating;
  final String placeId;
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
            /// =====================================================
            /// IMAGE
            /// =====================================================
            Expanded(
              flex: 6,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: CachedNetworkImage(
                      imageUrl: imageUrl,

                      fit: BoxFit.cover,

                      fadeInDuration: const Duration(milliseconds: 250),

                      placeholder: (context, url) {
                        return Shimmer.fromColors(
                          baseColor: Colors.grey.shade300,
                          highlightColor: Colors.grey.shade100,
                          child: Container(color: Colors.white),
                        );
                      },

                      errorWidget: (context, url, error) {
                        return Container(
                          color: Colors.grey.shade200,
                          child: Icon(
                            Icons.image_not_supported,
                            color: Colors.grey.shade500,
                            size: 35.sp,
                          ),
                        );
                      },
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
                  if (type != null && type!.trim().isNotEmpty)
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
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            /// =====================================================
            /// CONTENT
            /// =====================================================
            Expanded(
              flex: 4,
              child: Padding(
                padding: EdgeInsets.all(12.r),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// TITLE
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyle.primaryTextW400S16.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 12.sp,
                      ),
                    ),

                    CustomHeightSpacingWidget(height: 8.h),

                    /// LOCATION
                    if (city != null && city!.trim().isNotEmpty)
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_rounded,
                            size: 15.sp,
                            color: AppColors.redAppColor,
                          ),

                          CustomWidthSpacingWidget(width: 4.w),

                          Expanded(
                            child: Text(
                              city!,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 11.sp,
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),

                    const Spacer(),

                    /// PERIOD
                    if (period != null && period!.trim().isNotEmpty)
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
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
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
