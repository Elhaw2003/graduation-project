import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_guide/core/shared_widgets/custom_spacing_widget.dart';
import 'package:smart_guide/core/utils/app_colors.dart';
import 'package:smart_guide/core/utils/app_text_style.dart';

class BuildIconContext extends StatelessWidget {
  const BuildIconContext({super.key, required this.icon, this.title});
  final IconData icon;
  final String? title;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 15.sp, color: AppColors.secondaryColor),
        CustomWidthSpacingWidget(width: 5),
        Flexible(
          fit: FlexFit.loose,
          child: Text(
            title ?? "Not Found",
            style: AppTextStyle.primaryTextW400S16,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
