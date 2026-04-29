import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_guide/core/utils/app_colors.dart';
import 'package:smart_guide/core/utils/app_text_style.dart';
import 'package:smart_guide/generated/locale_keys.g.dart';

class RememberMeWidget extends StatelessWidget {
  const RememberMeWidget({super.key, required this.value, this.onChanged});
  final bool value;
  final void Function(bool?)? onChanged;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Checkbox(
          value: value,
          onChanged: onChanged,
          activeColor: AppColors.primaryColor,
          checkColor: AppColors.whiteColor,
          side: BorderSide(color: AppColors.greyCFC9C9olor),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.r),
          ),
        ),
        Text(
          LocaleKeys.rememberMe.tr(),
          style: AppTextStyle.primaryTextW500S17,
        ),
      ],
    );
  }
}
