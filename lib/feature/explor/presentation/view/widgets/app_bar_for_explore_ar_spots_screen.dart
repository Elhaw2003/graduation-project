import 'package:flutter/material.dart';
import 'package:smart_guide/core/shared_widgets/custom_arrow_back_button.dart';
import 'package:smart_guide/core/utils/app_text_style.dart';

class AppBarForExploreArSpotsScreen extends StatelessWidget {
  const AppBarForExploreArSpotsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: CustomArrowBackButton(iconColor: Color(0xff001A72)),
              ),
              Text(
                "Explore AR Spots",
                style: AppTextStyle.primaryTextW500S21.copyWith(
                  color: Color(0xff1F2937),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
