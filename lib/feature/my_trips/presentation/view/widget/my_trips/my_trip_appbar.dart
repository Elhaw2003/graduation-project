import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_guide/core/utils/app_colors.dart';
import 'package:smart_guide/core/utils/app_text_style.dart';
import 'package:smart_guide/generated/locale_keys.g.dart';

class MyTripAppbar extends StatelessWidget {
  const MyTripAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 120.h,
      pinned: true,
      backgroundColor: AppColors.backgroundColor,
      elevation: 0,
      leading: const BackButton(color: AppColors.blackColor),
      flexibleSpace: FlexibleSpaceBar(
        expandedTitleScale: 1.4,
        centerTitle: true,
        title: Text(
          LocaleKeys.myTrips.tr(),
          style: AppTextStyle.primaryTextW500S25,
        ),
      ),
    );
  }
}
