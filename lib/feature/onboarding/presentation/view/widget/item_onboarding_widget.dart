import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_guide/core/routing/app_routes.dart';
import 'package:smart_guide/core/services/cache/cache_helper.dart';
import 'package:smart_guide/core/shared_widgets/custom_button_widget.dart';
import 'package:smart_guide/core/shared_widgets/custom_spacing_widget.dart';
import 'package:smart_guide/core/utils/app_text_style.dart';
import 'package:smart_guide/feature/onboarding/data/list/page_views_screens.dart';
import 'package:smart_guide/feature/onboarding/presentation/view/widget/smooth_indicator_widget.dart';
import 'package:smart_guide/generated/locale_keys.g.dart';

class ItemOnboardingWidget extends StatelessWidget {
  const ItemOnboardingWidget({
    super.key,
    required this.index,
    required this.controller,
  });
  final int index;
  final PageController controller;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(onboardings[index].title, style: AppTextStyle.backgroundW600S25),
          CustomHeightSpacingWidget(height: 10),
          Text(
            onboardings[index].description,
            style: AppTextStyle.backgroundW500S17,
          ),
          const CustomHeightSpacingWidget(height: 25),
          SmoothIndicatorWidget(controller: controller),
          CustomHeightSpacingWidget(height: 25),
          CustomButtonWidget(
            buttonWidth: double.infinity,
            onPressed: () async{
              if (index < onboardings.length - 1) {
                controller.nextPage(
                  duration: Duration(milliseconds: 600),
                  curve: Curves.fastOutSlowIn,
                );
              } else {
                await CacheHelper.setBool(CacheHelper.kIsOnBoardingViewSeen, true);
                if (context.mounted) {
                  GoRouter.of(context).go(AppRoutes.loginScreen);
                }
              }
            },
            title: index < onboardings.length - 1
                ? LocaleKeys.next.tr()
                : LocaleKeys.discoverEgypt.tr(),
          ),
        ],
      ),
    );
  }
}
