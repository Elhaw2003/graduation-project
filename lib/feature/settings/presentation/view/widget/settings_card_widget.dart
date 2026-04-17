import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smart_guide/core/utils/app_colors.dart';
import 'package:smart_guide/core/utils/app_text_style.dart';

class SettingsCardWidget extends StatelessWidget {
  const SettingsCardWidget({super.key, required this.items});

  final List<Widget> items;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(8.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.blackColor.withOpacity(0.15),
            offset: const Offset(0, 4),
            blurRadius: 4.r,
            spreadRadius: 0.r,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: items.asMap().entries.map((entry) {
          int index = entry.key;
          Widget item = entry.value;
          return Column(
            children: [
              item,
              if (index < items.length - 1)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Divider(
                    height: 1,
                    thickness: 0.5,
                    color: Colors.grey.shade300,
                  ),
                ),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class ListTileCardWidget extends StatelessWidget {
  const ListTileCardWidget({
    super.key,
    required this.title,
    this.titleStyle,
    required this.svgIconPath,
    this.trailing,
    this.onTap, // ضفنا الـ onTap هنا
  });

  final String title;
  final TextStyle? titleStyle;
  final String svgIconPath;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: SvgPicture.asset(
        svgIconPath,
        width: 20.w,
        height: 20.h,
        colorFilter: ColorFilter.mode(AppColors.primaryColor, BlendMode.srcIn),
      ),
      title: Text(
        title,
        style: titleStyle ?? AppTextStyle.primaryPoppinsTextW500S15,
      ),
      trailing: trailing,
    );
  }
}
