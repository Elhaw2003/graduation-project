import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_guide/core/shared_widgets/custom_arrow_back_button.dart';
import 'package:smart_guide/core/utils/app_colors.dart';
import 'package:smart_guide/core/utils/app_text_style.dart';

class CustomSliverAppbarWidget extends StatelessWidget {
  const CustomSliverAppbarWidget({super.key, required this.title});
  final String title;
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 120.h,
      pinned: true,
      centerTitle: true,
      leading: CustomArrowBackButton(),
      elevation: 4,
      surfaceTintColor: Colors.transparent,
      backgroundColor: AppColors.backgroundColor,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Text(title, style: AppTextStyle.primaryTextW500S17),
        // ده الشكل وهو تحت قبل الـ scroll
        expandedTitleScale: 1.4,
        background: Container(color: AppColors.backgroundColor),
      ),
    );
  }
}
