import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_guide/core/shared_widgets/custom_spacing_widget.dart';
import 'package:smart_guide/core/utils/app_colors.dart';
import 'package:smart_guide/core/utils/app_text_style.dart';
import 'package:smart_guide/generated/locale_keys.g.dart';

class PopularPlaceCard extends StatelessWidget {
  final String title;
  final String rating;
  final String category;
  final String? imageUrl;

  final bool isSaved;

  final void Function()? onPressed;
  final void Function()? onSaveTap;

  const PopularPlaceCard({
    super.key,
    required this.title,
    required this.rating,
    required this.category,
    required this.imageUrl,
    required this.isSaved,
    this.onPressed,
    this.onSaveTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      height: 185.h,
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.horizontal(left: Radius.circular(16.r)),
            child: CachedNetworkImage(
              imageUrl: imageUrl ?? '',
              width: 140.w,
              height: double.infinity,
              fit: BoxFit.cover,

              placeholder: (context, url) => Container(
                color: Colors.grey.shade200,
                child: const Center(child: CircularProgressIndicator()),
              ),

              errorWidget: (context, url, error) => Container(
                color: Colors.grey.shade200,
                child: const Icon(Icons.image_not_supported_outlined, size: 40),
              ),
            ),
          ),

          Expanded(
            child: Padding(
              padding: EdgeInsets.all(12.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyle.primary400TextW500S16.copyWith(
                            color: AppColors.primaryColor,
                          ),
                        ),
                      ),

                      GestureDetector(
                        onTap: onSaveTap,
                        child: Container(
                          padding: EdgeInsets.all(8.r),
                          decoration: BoxDecoration(
                            color: isSaved
                                ? AppColors.primaryColor.withOpacity(0.1)
                                : Colors.grey.shade100,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            isSaved
                                ? Icons.bookmark
                                : Icons.bookmark_border_rounded,
                            color: isSaved
                                ? AppColors.primaryColor
                                : Colors.grey,
                            size: 22.sp,
                          ),
                        ),
                      ),
                    ],
                  ),

                  CustomHeightSpacingWidget(height: 10),

                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber, size: 16.sp),

                      SizedBox(width: 4.w),

                      Text(
                        rating,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: AppColors.secondaryTextColor,
                        ),
                      ),
                    ],
                  ),

                  CustomHeightSpacingWidget(height: 12),

                  _buildIconText(
                    Icons.castle_outlined,
                    category,
                    color: AppColors.blackColor,
                  ),

                  const Spacer(),

                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: onPressed,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 8.h,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        elevation: 0,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            LocaleKeys.viewDetails.tr(),
                            style: TextStyle(
                              color: AppColors.whiteColor,
                              fontSize: 12.sp,
                            ),
                          ),

                          CustomWidthSpacingWidget(width: 5.w),

                          const Icon(
                            Icons.arrow_forward,
                            color: AppColors.whiteColor,
                            size: 14,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIconText(IconData icon, String text, {Color? color}) {
    return Row(
      children: [
        Icon(icon, size: 14.sp, color: color ?? Colors.grey),

        SizedBox(width: 6.w),

        Expanded(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 12.sp, color: Colors.grey[700]),
          ),
        ),
      ],
    );
  }
}
