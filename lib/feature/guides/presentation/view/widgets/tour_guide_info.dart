
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smart_guide/core/shared_widgets/custom_spacing_widget.dart';
import 'package:smart_guide/core/utils/app_colors.dart';
import 'package:smart_guide/core/utils/app_text_style.dart';
import 'package:smart_guide/feature/guides/presentation/view/widgets/custom_pointe_widgets.dart';
import 'package:smart_guide/generated/assets.dart';

class TourGuideInfoDetiles extends StatelessWidget {
  const TourGuideInfoDetiles({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      width: MediaQuery.of(context).size.width - 145,
      color: Colors.transparent,
      child: Column(
        children: [
          Row(
            children: [
              Text(
                'Abdallah Alqisy- Egyptologist',
                style: AppTextStyle.primaryTextW500S17,
              ),
              SvgPicture.asset(
                Assets.imagesSvgVerified,
                width: 22,
                height: 22,
              ),
            ],
          ),
          Row(
            children: [
              Text(
                'Trips +150',
                style: AppTextStyle.primaryTextW400S14.copyWith(
                  color: AppColors.secondaryColor,
                ),
              ),
              CustomPointe(),
              SvgPicture.asset(
                Assets.imagesSvgLocationIcon,
                width: 18,
                height: 18,
                color: AppColors.secondaryColor,
              ),
              CustomWidthSpacingWidget(width: 4),
              Text(
                'Giza / Cairo',
                style: AppTextStyle.primaryTextW400S14,
              ),
              CustomPointe(),
              Text('\$20/hr', style: AppTextStyle.primaryTextW400S14),
            ],
          ),
        ],
      ),
    );
  }
}
