import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_guide/core/routing/app_routes.dart';
import 'package:smart_guide/core/shared_widgets/custom_button_widget.dart';
import 'package:smart_guide/core/shared_widgets/custom_spacing_widget.dart';
import 'package:smart_guide/core/utils/app_colors.dart';
import 'package:smart_guide/core/utils/app_text_style.dart';
import 'package:smart_guide/generated/assets.dart';
import 'package:smart_guide/generated/locale_keys.g.dart';

class CustomContainerInfoGuides extends StatelessWidget {
  const CustomContainerInfoGuides({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 15, left: 16.0, right: 8),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Image.asset(
                    Assets.imagePerson,
                    height: 100,
                    width: 100,
                    fit: BoxFit.fill,
                  ),
                ),
                CustomHeightSpacingWidget(height: 4),
                Text(
                  'Trips +150',
                  style: AppTextStyle.secondaryColorW400S13.copyWith(
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Mostafa Hekal - Egyptologist',
                style: AppTextStyle.primaryTextW400S16.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              CustomHeightSpacingWidget(height: 8),
              Row(
                children: [
                  Text(
                    '4.9',
                    style: AppTextStyle.primaryTextW400S16.copyWith(
                      fontSize: 17,
                    ),
                  ),
                  CustomWidthSpacingWidget(width: 4),
                  Icon(Icons.star_sharp, color: AppColors.starColore, size: 17),
                  Icon(Icons.star_sharp, color: AppColors.starColore, size: 17),
                  Icon(Icons.star_sharp, color: AppColors.starColore, size: 17),
                  Icon(Icons.star_sharp, color: AppColors.starColore, size: 17),
                  Icon(Icons.star_sharp, color: AppColors.starColore, size: 17),
                ],
              ),
              Text(
                'Price : \$20/hr',
                style: AppTextStyle.primaryTextW400S14.copyWith(fontSize: 13),
              ),
              CustomHeightSpacingWidget(height: 8),
              CustomButtonWidget(
                onPressed: () {
                  GoRouter.of(
                    context,
                  ).pushNamed(AppRoutes.tourGuideProfileScreen);
                },
                borderRadiusButton: 5,
                buttonHeight: 24,
                buttonWidth: 130,
                child: Text(
                  LocaleKeys.viewProfile.tr(),
                  style: AppTextStyle.primaryTextW400S14.copyWith(
                    color: AppColors.whiteColor,
                    fontSize: 13,
                  ),
                ),
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Image.asset(
                      'icons/flags/png100px/eg.png',
                      package: 'country_icons',
                      height: 20,
                      width: 20,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Image.asset(
                      'icons/flags/png100px/de.png',
                      package: 'country_icons',
                      height: 20,
                      width: 20,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Image.asset(
                      'icons/flags/png100px/fr.png',
                      package: 'country_icons',
                      height: 20,
                      width: 20,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
