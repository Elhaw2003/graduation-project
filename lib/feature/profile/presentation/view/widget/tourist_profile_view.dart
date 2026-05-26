import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_guide/core/shared_widgets/custom_arrow_forward.dart';
import 'package:smart_guide/core/utils/app_text_style.dart';
import 'package:smart_guide/feature/profile/data/model/tourist_profile_model.dart';
import 'package:smart_guide/feature/settings/presentation/view/widget/settings_card_widget.dart';
import 'package:smart_guide/generated/assets.dart';

class TouristProfileView extends StatelessWidget {
  const TouristProfileView({super.key, required this.profile});

  final TouristProfileModel profile;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 17.w),
      child: SettingsCardWidget(
        items: [
          ListTileCardWidget(
            title: 'Your Info',
            titleStyle: AppTextStyle.secondaryTextPoppinsColorW500S16,
            svgIconPath: Assets.imagesSvgPersonalInfo,
          ),
          ListTileCardWidget(
            title: profile.email.isNotEmpty ? profile.email : 'No Email',
            svgIconPath: Assets.imagesSvgEmail,
            // trailing: const CustomArrowForward(),
          ),
          ListTileCardWidget(
            title: profile.whatsAppNumber.isNotEmpty
                ? profile.whatsAppNumber
                : 'No Phone',
            svgIconPath: Assets.imagesSvgPhone,
            // trailing: const CustomArrowForward(),
          ),
          ListTileCardWidget(
            title: profile.country.isNotEmpty ? profile.country : 'No Country',
            svgIconPath: Assets.imagesSvgNational,
            // trailing: const CustomArrowForward(),
          ),
          ListTileCardWidget(
            title: profile.userName.isNotEmpty ? profile.userName : 'User',
            svgIconPath: Assets.imagesSvgCity,
            // trailing: const CustomArrowForward(),
          ),
        ],
      ),
    );
  }
}
