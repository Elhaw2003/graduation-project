import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_guide/core/utils/app_colors.dart';
import 'package:smart_guide/feature/human_guide/all_guides/presentation/view/widgets/custom_container_info_guides.dart';

class TourGuideProfileImage extends StatelessWidget {
  const TourGuideProfileImage({super.key, required this.imageUrl});
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100.r, // استخدام .r لضمان التساوي (مربع مثالي)
      width: 100.r,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.primaryColor, width: 3.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(3.r), // مسافات متساوية من كل الاتجاهات
        child: ClipOval(
          child: Image.network(
            imageUrl.toHttps(),
            fit: BoxFit.cover, // الصورة هتملا المساحة الدائرية المتاحة لوحدها
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
