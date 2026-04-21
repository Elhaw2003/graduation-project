import 'package:flutter/material.dart';
import 'package:smart_guide/core/shared_widgets/custom_arrow_forward.dart';
import 'package:smart_guide/core/utils/app_text_style.dart';
import 'package:smart_guide/feature/settings/presentation/view/widget/settings_card_widget.dart';
import 'package:smart_guide/generated/assets.dart';

class PrfileDetails extends StatelessWidget {
  const PrfileDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingsCardWidget(
      items: [
        ListTileCardWidget(
          title: "Your Info",
          titleStyle: AppTextStyle.secondaryTextPoppinsColorW500S16,
          svgIconPath: Assets.imagesSvgPersonalInfo,
        ),
        ListTileCardWidget(
          title: "johann.muller@gmail.com",
          svgIconPath: Assets.imagesSvgEmail,
          trailing: CustomArrowForward(),
        ),
        ListTileCardWidget(
          title: "+49 151 234 56789",
          svgIconPath: Assets.imagesSvgPhone,
          trailing: CustomArrowForward(),
        ),
        ListTileCardWidget(
          title: "German (Deutsch)",
          svgIconPath: Assets.imagesSvgLangauge,
          trailing: CustomArrowForward(),
        ),
        ListTileCardWidget(
          title: "Germany",
          svgIconPath: Assets.imagesSvgNational,
          trailing: CustomArrowForward(),
        ),
        ListTileCardWidget(
          title: "German",
          svgIconPath: Assets.imagesSvgCity,
          trailing: CustomArrowForward(),
        ),
      ],
    );
  }
}
