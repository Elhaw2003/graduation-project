import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_guide/core/routing/app_routes.dart';
import 'package:smart_guide/core/shared_widgets/custom_button_widget.dart';
import 'package:smart_guide/core/shared_widgets/custom_spacing_widget.dart';
import 'package:smart_guide/core/utils/app_colors.dart';
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
      padding: EdgeInsets.all(30.0.sp),
      child: Column(
        children: [
          CustomHeightSpacingWidget(height: 30),
          Align(
            alignment: Alignment.topRight,
            child: Image.asset(
              Assets.imagesPngLogoWithText,
              fit: BoxFit.fill,
              height: 100.h,
              width: 100.w,
            ),
          ),
          CustomHeightSpacingWidget(height: 30),
          SelectRoleWidget(
            textColor: AppColors.whiteColor,
            iconColor: AppColors.whiteColor,
            isSelected:
                selectType.toString() == UserTypeEnum.tourist.toString(),
            colorButton: selectType == UserTypeEnum.tourist
                ? AppColors.primaryColor
                : AppColors.grey300Color,
            title: LocaleKeys.tourist.tr(),
            icon: Assets.imagesSvgAirplane,
            onTap: () {
              setState(() {
                selectType = UserTypeEnum.tourist;
              });
            },
          ),
          CustomHeightSpacingWidget(height: 50),
          SelectRoleWidget(
            textColor: AppColors.whiteColor,
            iconColor: AppColors.whiteColor,
            isSelected: selectType.toString() == UserTypeEnum.guide.toString(),
            colorButton: selectType == UserTypeEnum.guide
                ? AppColors.primaryColor
                : AppColors.grey300Color,
            title: LocaleKeys.guide.tr(),
            onTap: () {
              setState(() {
                selectType = UserTypeEnum.guide;
              });
            },
            icon: Assets.imagesSvgCompass,
          ),
          Spacer(),
          CustomButtonWidget(
            buttonWidth: double.infinity,
            onPressed: selectType != null
                ? () {
                    GoRouter.of(
                      context,
                    ).pushNamed(AppRoutes.registerScreen, extra: selectType);
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
        ],
      ),
    );
  }
}
