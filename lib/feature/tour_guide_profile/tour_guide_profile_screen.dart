import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_guide/core/routing/app_routes.dart';
import 'package:smart_guide/core/shared_widgets/custom_button_widget.dart';
import 'package:smart_guide/core/utils/app_colors.dart';
import 'package:smart_guide/core/utils/app_text_style.dart';
import 'package:smart_guide/feature/all_guides/presentation/cubit/tour_guides_cubit.dart';
import 'package:smart_guide/feature/all_guides/presentation/cubit/tour_guides_states.dart';
import 'package:smart_guide/feature/tour_guide_profile/tour_guide_profile_body.dart';

class TourGuideProfileScreen extends StatelessWidget {
  const TourGuideProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: BlocBuilder<TourGuidesCubit, TourGuidesState>(
        builder: (context, state) {
          if (state is TourGuidesLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primaryColor),
            );
          }

          if (state is TourGuidesFailure) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  state.errorMessage,
                  style: AppTextStyle.primaryTextW500S17,
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          if (state is GuideDetailsSuccess) {
            final guide = state.tourGuide;

            return SingleChildScrollView(
              // physics: const BouncingScrollPhysics(),
              child: TourGuideProfileBody(
                name: guide.firstName,
                lastName: guide.lastName,
                aboutGuide: guide.bio,
                imageUrl: guide.profilePicture,
                rating: guide.rating.toString(),
                price: "\$${guide.pricePerDay.toInt()}/Day",
                cities: guide.cities,
                languages: guide.languages,
                gallery: guide.gallery,
                guidedId: guide.userId,
              ),
            );
          }

          return const SizedBox.shrink();
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
