import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_guide/core/shared_widgets/custom_spacing_widget.dart';
import 'package:smart_guide/core/utils/app_text_style.dart';
import 'package:smart_guide/generated/assets.dart';
import 'package:smart_guide/generated/locale_keys.g.dart';

class SplashBody extends StatelessWidget {
  const SplashBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          BounceInDown(
            duration: Duration(seconds: 4),
            child: Image.asset(
              fit: BoxFit.fill,
              Assets.imagesPngLogoWithoutText,
              width: 180.w,
            ),
          ),
          CustomHeightSpacingWidget(height: 10),
          FadeInUp(
            duration: Duration(seconds: 4),
            delay: Duration(seconds: 1),
            child: Text(
              LocaleKeys.appName.tr(),
              style: AppTextStyle.darkTealColorWBoldS26,
            ),
          ),

          FadeInUp(
            duration: Duration(seconds: 3),
            delay: Duration(seconds: 2),
            child: Text(
              LocaleKeys.egypt.tr(),
              style: AppTextStyle.goldColorW600S22,
            ),
          ),
        ],
      ),
    );
  }
}
