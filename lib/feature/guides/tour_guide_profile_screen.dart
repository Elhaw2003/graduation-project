import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_guide/core/routing/app_routes.dart';
import 'package:smart_guide/core/shared_widgets/custom_button_widget.dart';
import 'package:smart_guide/core/utils/app_colors.dart';
import 'package:smart_guide/core/utils/app_text_style.dart';
import 'package:smart_guide/feature/guides/presentation/view/widgets/tour_guide_info.dart';
import 'package:smart_guide/feature/guides/presentation/view/widgets/tour_guide_profile_body.dart';
import 'package:smart_guide/feature/guides/presentation/view/widgets/tour_guide_profile_image.dart';

class TourGuideProfileScreen extends StatelessWidget {
  const TourGuideProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Stack(
        children: [
          /// 🔹 الجزء اللي بيعمل Scroll
          SingleChildScrollView(
            child: Stack(
              children: [
                TourGuideProfileBody(),

                Positioned(top: 215, left: 15, child: TourGuideProfileImage()),

                Positioned(top: 275, left: 145, child: TourGuideInfoDetiles()),

                /// مسافة عشان المءحتوى ميستخباش تحت الكونتينر
                SizedBox(height: 200),
              ],
            ),
          ),

          /// 🔹 الجزء الثابت تحت
          // Positioned(
          //   bottom: 30,
          //   left: 25,
          //   right: 25,
          //   child: Container(
          //     height: 64,
          //     decoration: BoxDecoration(
          //       color: AppColors.backgroundColor,
          //       borderRadius: BorderRadius.circular(10),
          //       boxShadow: [
          //         BoxShadow(
          //           color: Colors.black.withOpacity(0.5),
          //           spreadRadius: 1,
          //           blurRadius: 5,
          //           offset: Offset(0, 3),
          //         ),
          //       ],
          //     ),
          //     child: Center(
          //       child: CustomButtonWidget(
          //         borderSideColor: AppColors.greenColor,
          //         title: 'Book Now',
          //         titleStyle: AppTextStyle.secondaryTextW400S17,
          //         buttonColor: Colors.transparent,
          //         buttonWidth: 50,
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(15),
        child: CustomButtonWidget(
          onPressed: () {
            if (context.mounted) context.pushNamed(AppRoutes.bookNowScreen);
          },
          borderSideColor: AppColors.greenColor,
          title: 'Book Now',
          titleStyle: AppTextStyle.secondaryTextW400S17,
          buttonColor: Colors.transparent,
          buttonWidth: double.infinity,
        ),
      ),
    );
  }
}
