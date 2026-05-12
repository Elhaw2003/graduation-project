import 'package:flutter/material.dart';
import 'package:smart_guide/core/shared_widgets/custom_button_widget.dart';
import 'package:smart_guide/core/shared_widgets/custom_spacing_widget.dart';
import 'package:smart_guide/core/utils/app_text_style.dart';
import 'package:smart_guide/feature/explor/presentation/view/widgets/app_bar_for_explore_ar_spots_screen.dart';
import 'package:smart_guide/feature/tour_guide_profile/custom_pointe_widgets.dart';
import 'package:smart_guide/generated/assets.dart';

class ExploreArSpotsScreenBody extends StatelessWidget {
  ExploreArSpotsScreenBody({super.key});
  final List<String> requirements = [
    'Must be near the location',
    'Camera access required',
    'Stable internet connection',
    'Keep device steady',
  ];
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CustomHeightSpacingWidget(height: 75),

            /// App Bar
            const AppBarForExploreArSpotsScreen(),

            const CustomHeightSpacingWidget(height: 35),

            /// AR Card
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: 302,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(Assets.imagesPngExploreAr, height: 275),
                      const CustomHeightSpacingWidget(height: 5),
                      Text(
                        'Discover nearby places with augmented reality',
                        textAlign: TextAlign.center,
                        style: AppTextStyle.secondaryTextW400S17.copyWith(
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),

                /// AR Icon فوق الصورة
                Positioned(
                  top: 199,
                  left: 15,
                  child: Image.asset(
                    Assets.imagesPngArIcon,
                    height: 65,
                    width: 65,
                  ),
                ),
              ],
            ),

            const CustomHeightSpacingWidget(height: 25),

            /// Start Button
            Center(
              child: CustomButtonWidget(
                buttonWidth: 220,
                buttonHeight: 50,
                title: 'Start AR Experience',
                titleStyle: AppTextStyle.whiteW500S17,
              ),
            ),

            const CustomHeightSpacingWidget(height: 30),

            /// Requirements Title
            Text(
              'Requirements for AR Experience',
              style: AppTextStyle.primaryTextW600S22.copyWith(fontSize: 20),
            ),

            const CustomHeightSpacingWidget(height: 15),

            /// Requirements List (بدون ListView)
            Column(
              children: List.generate(
                requirements.length,
                (index) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    children: [
                      const CustomPointe(),
                      const CustomWidthSpacingWidget(width: 10),
                      Text(
                        requirements[index],
                        style: AppTextStyle.secondaryTextW400S17,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const CustomHeightSpacingWidget(height: 40),
          ],
        ),
      ),
    );
  }
}
