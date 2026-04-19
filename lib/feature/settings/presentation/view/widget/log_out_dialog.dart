import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_guide/core/utils/app_colors.dart';
import 'package:smart_guide/core/utils/app_text_style.dart';
import 'package:smart_guide/core/shared_widgets/custom_spacing_widget.dart';
import 'package:smart_guide/feature/auth/login/presentation/view/widget/remember_me_widget.dart';
import 'package:smart_guide/feature/settings/presentation/view/widget/log_out_button_widget.dart';
import 'package:smart_guide/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';

class LogOutDialog extends StatelessWidget {
  const LogOutDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.whiteColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Icon(Icons.error_outline, color: Colors.red, size: 130.sp),
          ),
          CustomHeightSpacingWidget(height: 16),
          Text(
            LocaleKeys.logoutPrompt.tr(),
            style: AppTextStyle.primaryPoppinsTextW500S20,
            textAlign: TextAlign.center,
          ),
          Text(
            LocaleKeys.logoutMessage.tr(),
            style: AppTextStyle.redAppColorpoppinsW500S13,
            textAlign: TextAlign.center,
          ),
          CustomHeightSpacingWidget(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: AppColors.secondaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  LocaleKeys.cancel.tr(),
                  style: AppTextStyle.whitePoppinsW500S20,
                ),
              ),
              LogOutButtonWidget(),
            ],
          ),
          CustomHeightSpacingWidget(height: 5),
          RememberMeWidget(),
        ],
      ),
    );
  }
}
