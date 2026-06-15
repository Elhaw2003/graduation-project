import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_guide/core/utils/app_colors.dart';

class RecommendationCard extends StatelessWidget {
  final Map<String, dynamic> place;

  const RecommendationCard({super.key, required this.place});

  @override
  Widget build(BuildContext context) {
    // 🚀 تأمين جلب اسم المكان بكل الصيغ الممكنة المتوقعة من الـ API
    final String placeName =
        (place['name'] ??
                place['Name'] ??
                place['title'] ??
                place['place_name'] ??
                place['recommendation'] ??
                'Historic Place')
            .toString();

    // 🚀 تأمين جلب رابط الصورة بكل الصيغ الفنية الممكنة
    final String imageUrl =
        (place['image_url'] ??
                place['imageUrl'] ??
                place['image'] ??
                place['Image'] ??
                place['photo'] ??
                '')
            .toString();

    // 🚀 تأمين جلب التقييم والموقع والمحافظة
    final String rating = (place['rating'] ?? place['rate'] ?? '4.8')
        .toString();
    final String location =
        (place['location'] ?? place['governorate'] ?? place['city'] ?? 'Egypt')
            .toString();

    return Container(
      width: 160.w,
      margin: EdgeInsets.only(right: 12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🚀 جزء عرض الصورة مع حماية كاملة ضد الـ Null أو اللينكات المكسورة
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
              child: imageUrl.isNotEmpty && !imageUrl.startsWith('file://')
                  ? Image.network(
                      imageUrl,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _buildPlaceholder(),
                    )
                  : _buildPlaceholder(),
            ),
          ),
          // 🚀 تفاصيل الكارت (الاسم، الموقع، والتقييم)
          Padding(
            padding: EdgeInsets.all(8.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  placeName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryTextColor,
                  ),
                ),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    Icon(
                      Icons.location_on_rounded,
                      size: 12.sp,
                      color: AppColors.primaryColor,
                    ),
                    SizedBox(width: 2.w),
                    Expanded(
                      child: Text(
                        location,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 11.sp, color: Colors.grey),
                      ),
                    ),
                    Icon(Icons.star_rounded, size: 12.sp, color: Colors.amber),
                    SizedBox(width: 2.w),
                    Text(
                      rating,
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 🚀 ويدجت احتياطية تظهر بشكل جمالي إذا كانت الصورة مفقودة من السيرفر لمنع الكراش
  Widget _buildPlaceholder() {
    return Container(
      width: double.infinity,
      color: AppColors.primaryColor.withOpacity(0.1),
      child: Center(
        child: Icon(
          Icons.account_balance_rounded,
          size: 30.sp,
          color: AppColors.primaryColor,
        ),
      ),
    );
  }
}
