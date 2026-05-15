import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_guide/core/utils/app_colors.dart';

class DetailsTopButtonWidget extends StatelessWidget {
  const DetailsTopButtonWidget({
    super.key,
    this.onTap,
    required this.icon,
    this.color,
  });

  final VoidCallback? onTap;
  final IconData icon;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      child: IconButton(
        onPressed: onTap,
        icon: Icon(icon, color: color ?? AppColors.whiteColor, size: 25.sp),
      ),
    );
  }
}
