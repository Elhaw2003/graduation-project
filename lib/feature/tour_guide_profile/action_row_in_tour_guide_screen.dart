import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_guide/core/shared_widgets/custom_arrow_back_button.dart';
import 'package:smart_guide/core/shared_widgets/custom_spacing_widget.dart';

class ActionRowInTourGuideScreen extends StatelessWidget {
  const ActionRowInTourGuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomHeightSpacingWidget(height: 84),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomArrowBackButton(iconColor: Colors.white),
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.bookmark_outline_sharp,
                  color: Colors.white,
                  size: 28.sp,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
