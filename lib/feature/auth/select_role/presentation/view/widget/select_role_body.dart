import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_guide/core/routing/app_routes.dart';
import 'package:smart_guide/core/shared_widgets/custom_button_widget.dart';
import 'package:smart_guide/core/shared_widgets/custom_spacing_widget.dart';
import 'package:smart_guide/core/utils/app_colors.dart';
import 'package:smart_guide/core/utils/app_text_style.dart';
import 'package:smart_guide/feature/auth/domain/user_type_enum.dart';
import 'package:smart_guide/feature/auth/select_role/presentation/view/widget/select_role_widget.dart';
import 'package:smart_guide/generated/assets.dart';
import 'package:smart_guide/generated/locale_keys.g.dart';

class SelectRoleBody extends StatefulWidget {
  const SelectRoleBody({super.key});

  @override
  State<SelectRoleBody> createState() => _SelectRoleBodyState();
}

class _SelectRoleBodyState extends State<SelectRoleBody> {
  UserTypeEnum? selectType;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 30.h),
      child: Column(
        children: [
          const CustomHeightSpacingWidget(height: 20),
          // اللوجو في المنتصف
          Align(
            alignment: Alignment.center,
            child: Image.asset(
              Assets.imagesPngLogoWithText,
              height: 80.h,
              fit: BoxFit.contain,
            ),
          ),
          const CustomHeightSpacingWidget(height: 30),

          // نصوص العنوان (Header) كما في الصورة
          FadeInDown(
            child: Column(
              children: [
                Text(
                  LocaleKeys.selectYourProfile.tr(),
                  style: AppTextStyle.primaryTextW500S25.copyWith(
                    fontSize: 22.sp,
                    color: Colors.black,
                  ),
                ),
                const CustomHeightSpacingWidget(height: 8),
                Text(
                  LocaleKeys.selectYourRoleDescription.tr(),
                  style: AppTextStyle.primaryTextW500S17.copyWith(
                    fontSize: 14.sp,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),

          const CustomHeightSpacingWidget(height: 40),

          // كارت Tourist
          FadeInLeft(
            duration: const Duration(milliseconds: 800),
            child: SelectRoleNewWidget(
              isSelected: selectType == UserTypeEnum.Tourist,
              title: LocaleKeys.tourist.tr(),
              image: Assets.imagesPngTourist, // الصورة الجديدة
              onTap: () {
                setState(() {
                  selectType = UserTypeEnum.Tourist;
                });
              },
            ),
          ),

          const CustomHeightSpacingWidget(height: 20),

          // كارت Guide
          FadeInRight(
            duration: const Duration(milliseconds: 800),
            child: SelectRoleNewWidget(
              isSelected: selectType == UserTypeEnum.TourGuide,
              title: LocaleKeys.guideLogin.tr(),
              image: Assets.imagesPngGuide, // الصورة الجديدة
              onTap: () {
                setState(() {
                  selectType = UserTypeEnum.TourGuide;
                });
              },
            ),
          ),

          const Spacer(),

          // زرار التالي
          FadeInUp(
            duration: const Duration(milliseconds: 600),
            child: CustomButtonWidget(
              buttonWidth: double.infinity,
              onPressed: selectType != null
                  ? () {
                      context.pushNamed(
                        AppRoutes.registerScreen,
                        pathParameters: {'userType': selectType!.name},
                      );
                    }
                  : null,
              title: LocaleKeys.next.tr(),
              buttonColor: selectType == null
                  ? AppColors.grey300Color
                  : AppColors.primaryColor,
              borderSideColor: selectType == null
                  ? AppColors.grey300Color
                  : AppColors.primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
