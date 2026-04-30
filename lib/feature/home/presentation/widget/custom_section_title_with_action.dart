import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_guide/core/routing/app_routes.dart';
import 'package:smart_guide/core/utils/app_text_style.dart';
import 'package:smart_guide/generated/locale_keys.g.dart';

class CustomSectionTitleWithAction extends StatelessWidget {
  const CustomSectionTitleWithAction({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          LocaleKeys.popularPlaces.tr(),
          style: AppTextStyle.primaryTextW500S21,
        ),
        TextButton(
          onPressed: () {
            context.pushNamed(AppRoutes.popularPlacesScreen);
          },
          child: Text(
            LocaleKeys.showAll.tr(),
            style: AppTextStyle.primaryW500S16,
          ),
        ),
      ],
    );
  }
}
