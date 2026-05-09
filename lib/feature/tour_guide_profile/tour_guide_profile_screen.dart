import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:smart_guide/core/routing/app_routes.dart';
import 'package:smart_guide/core/shared_widgets/custom_button_widget.dart';
import 'package:smart_guide/core/utils/app_colors.dart';
import 'package:smart_guide/core/utils/app_text_style.dart';
import 'package:smart_guide/feature/guides/data/tour_guide_profile/tour_guide_profile_cubit.dart';
import 'package:smart_guide/feature/guides/data/tour_guide_profile/tour_guide_profile_state.dart';

import 'package:smart_guide/feature/human_guide/tour_guide_info.dart';
import 'package:smart_guide/feature/tour_guide_profile/tour_guide_profile_body.dart';
import 'package:smart_guide/feature/tour_guide_profile/tour_guide_profile_image.dart';

class TourGuideProfileScreen extends StatelessWidget {
  const TourGuideProfileScreen({super.key});

  // final String userID;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,

      body: BlocBuilder<TourGuideProfileCubit, TourGuideProfileState>(
        builder: (context, state) {
          if (state is TourGuideProfileLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is TourGuideProfileError) {
            return Center(child: Text(state.message));
          }

          if (state is TourGuideProfileSuccess) {
            final data = state.profile;

            return Stack(
              children: [
                SingleChildScrollView(
                  child: Stack(
                    children: [
                      TourGuideProfileBody(
                        name: data.firstName ?? '',
                        aboutGuide: data.bio ?? '',
                      ),

                      Positioned(
                        top: 215,
                        left: 15,
                        child: TourGuideProfileImage(
                          imageUrl: data.profilePicture ?? '',
                        ),
                      ),

                      Positioned(
                        top: 275,
                        left: 145,
                        child: TourGuideInfoDetiles(
                          firstName: data.firstName ?? '',
                          lastName: data.lastName ?? '',
                          rating: (data.rating ?? 0).toString(),
                          price: "${data.pricePerDay ?? 0}/hr",
                          number: "",
                        ),
                      ),

                      const SizedBox(height: 200),
                    ],
                  ),
                ),
              ],
            );
          }

          return const SizedBox();
        },
      ),

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(15),
        child: CustomButtonWidget(
          onPressed: () {
            if (context.mounted) {
              context.pushNamed(AppRoutes.bookNowScreen);
            }
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
