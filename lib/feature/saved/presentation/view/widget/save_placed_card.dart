import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_guide/core/routing/app_routes.dart';
import 'package:smart_guide/core/utils/app_colors.dart';
import 'package:smart_guide/core/utils/app_text_style.dart';
import 'package:smart_guide/feature/saved/data/model/save_placed_card_model.dart';
import 'package:smart_guide/feature/saved/presentation/cubit/saved_places_cubit.dart';

class SavePlacedCard extends StatelessWidget {
  const SavePlacedCard({super.key, required this.savedPlaceedCardModel});
  final SavedPlaceedCardModel savedPlaceedCardModel;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(
        '${AppRoutes.detailsScreen}/${savedPlaceedCardModel.placeId}',
        // extra: resolvePlaceImage(place.imageUrl, index),
      ),
      child: Container(
        height: 190.h,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.blackColor.withOpacity(0.08),
              blurRadius: 15.r,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.r),
          child: Stack(
            children: [
              // Place image
              Positioned.fill(
                child: CachedNetworkImage(
                  imageUrl: savedPlaceedCardModel.imageUrl,
                  fit: BoxFit.cover,
                  errorWidget: (context, url, error) => Container(
                    color: Colors.grey.shade200,
                    child: Icon(Icons.image_not_supported, size: 35.sp),
                  ),
                  placeholder: (context, url) => Container(
                    color: Colors.grey.shade200,
                    child: Icon(Icons.image, size: 35.sp),
                  ),
                ),
              ),

              // Dark overlay for text readability
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.05),
                        Colors.black.withOpacity(0.85),
                      ],
                    ),
                  ),
                ),
              ),

              // Tag badge and delete button
              Positioned(
                top: 15.h,
                left: 15.w,
                right: 15.w,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 5.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.arrowBackColor,
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(
                          color: AppColors.arrowBackColor.withOpacity(0.6),
                          width: 0.8,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.star_rounded,
                            size: 12.sp,
                            color: Colors.amber,
                          ),
                          SizedBox(width: 2.w),
                          Text(
                            savedPlaceedCardModel.rating.toStringAsFixed(1),
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.amber,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        context.read<SavedPlacesCubit>().removePlace(
                          placeId: savedPlaceedCardModel.placeId,
                        );
                      },
                      child: CircleAvatar(
                        radius: 18.r,
                        backgroundColor: Colors.red.withOpacity(0.8),
                        child: Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 20.sp,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Bottom text labels
              Positioned(
                bottom: 15.h,
                left: 15.w,
                right: 15.w,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      savedPlaceedCardModel.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyle.whitePoppinsW500S24.copyWith(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      savedPlaceedCardModel.subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: AppColors.whiteColor.withOpacity(0.9),
                        fontSize: 13.sp,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
