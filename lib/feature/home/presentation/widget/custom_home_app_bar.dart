import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_guide/core/routing/app_routes.dart';
import 'package:smart_guide/core/utils/app_colors.dart';
import 'package:smart_guide/core/utils/app_text_style.dart';
import 'package:smart_guide/generated/assets.dart';

class CustomHomeAppBar extends StatelessWidget {
  const CustomHomeAppBar({
    super.key,
    required this.title,
    required this.subTitle,
    this.imageUrl,
  });

  final String title;
  final String subTitle;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: InkWell(
            onTap: () => context.pushNamed(AppRoutes.profileScreen),
            borderRadius: BorderRadius.circular(12.r),
            child: Row(
              children: [
                Hero(
                  tag: 'profile_pic',
                  child: Container(
                    width: 44.r,
                    height: 44.r,
                    padding: EdgeInsets.all(2.r),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.primaryColor,
                        width: 2,
                      ),
                    ),
                    child: ClipOval(
                      child: CachedNetworkImage(
                        imageUrl: imageUrl ?? '',
                        width: 44.r,
                        height: 44.r,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          width: 44.r,
                          height: 44.r,
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            shape: BoxShape.circle,
                          ),
                        ),
                        errorWidget: (context, url, error) => ClipOval(
                          child: Image.asset(
                            Assets.imagesPngSphinx,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(width: 10.w),

                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title.isEmpty ? 'User' : title,
                        style: AppTextStyle.thirdTextW900S20.copyWith(
                          fontSize: 16.sp,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        subTitle,
                        style: AppTextStyle.thirdTextW400S17.copyWith(
                          fontSize: 12.sp,
                          color: Colors.grey,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        _buildActionIcon(
          icon: SvgPicture.asset(
            Assets.imagesSvgSettings,
            height: 18.h,
            color: AppColors.primaryColor,
          ),
          onTap: () => context.pushNamed(AppRoutes.settingsScreen),
        ),

        SizedBox(width: 8.w),

        _buildActionIcon(
          icon: Icon(
            Icons.menu_open_rounded,
            color: AppColors.primaryColor,
            size: 22.sp,
          ),
          onTap: () => Scaffold.of(context).openDrawer(),
        ),
      ],
    );
  }

  Widget _buildActionIcon({required Widget icon, required VoidCallback onTap}) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(milliseconds: 500),
      builder: (context, value, child) =>
          Transform.scale(scale: value, child: child),
      child: Container(
        height: 40.h,
        width: 40.w,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: IconButton(
          onPressed: onTap,
          icon: icon,
          padding: EdgeInsets.zero,
        ),
      ),
    );
  }
}
