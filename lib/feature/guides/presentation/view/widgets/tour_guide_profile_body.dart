import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_guide/core/shared_widgets/custom_spacing_widget.dart';
import 'package:smart_guide/feature/guides/presentation/view/widgets/action_row_in_tour_guide_screen.dart';
import 'package:smart_guide/feature/guides/presentation/view/widgets/custom_container_about_the_guide.dart';
import 'package:smart_guide/feature/guides/presentation/view/widgets/custom_container_expertise_and_skills.dart';
import 'package:smart_guide/generated/assets.dart';

class TourGuideProfileBody extends StatelessWidget {
  const TourGuideProfileBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 260.h,
          width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(Assets.imagesPngPyramids),
              fit: BoxFit.cover,
            ),
          ),
          child: ActionRowInTourGuideScreen(),
        ),
        CustomHeightSpacingWidget(height: 100),
        CustomContainerAboutTheGuide(),

        CustomContainerExpertiseAndSkills(),
      ],
    );
  }
}
