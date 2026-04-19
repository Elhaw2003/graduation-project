import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smart_guide/core/shared_widgets/custom_arrow_back_button.dart';
import 'package:smart_guide/core/utils/app_text_style.dart';
import 'package:smart_guide/generated/assets.dart';
import 'package:smart_guide/generated/locale_keys.g.dart';

class PopularPlacesScreen extends StatelessWidget {
  const PopularPlacesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          LocaleKeys.popularPlaces.tr(),
          style: AppTextStyle.blackPoppinsW500S24,
        ),
        centerTitle: true,
        leading: CustomArrowBackButton(),
        actions: [
          Container(
            padding: const EdgeInsets.all(8.0),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.r),
            ),
            margin: EdgeInsets.only(right: 8.0.w, left: 8.0.w),
            child: SvgPicture.asset(
              Assets.imagesSvgPopularPlaces,
              width: 24.w,
              height: 24.h,
            ),
          ),
        ],
      ),
    );
  }
}
