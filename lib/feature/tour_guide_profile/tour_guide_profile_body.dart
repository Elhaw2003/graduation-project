import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_guide/core/shared_widgets/custom_spacing_widget.dart';
import 'package:smart_guide/feature/tour_guide_profile/action_row_in_tour_guide_screen.dart';
import 'package:smart_guide/feature/tour_guide_profile/tour_guide_gallery_widget.dart';
import 'package:smart_guide/feature/tour_guide_profile/tour_guide_profile_image.dart';
import 'package:smart_guide/feature/tour_guide_profile/tour_guide_info.dart';
import 'package:smart_guide/feature/tour_guide_profile/custom_container_about_the_guide.dart';
import 'package:smart_guide/feature/tour_guide_profile/custom_container_expertise_and_skills.dart';
import 'package:smart_guide/generated/assets.dart';

class TourGuideProfileBody extends StatelessWidget {
  const TourGuideProfileBody({
    super.key,
    required this.name,
    required this.aboutGuide,
    required this.imageUrl,
    required this.lastName,
    required this.rating,
    required this.price,
    required this.cities,
    required this.languages,
    required this.gallery,
    required this.guidedId,
  });

  final String name;
  final String lastName;
  final String aboutGuide;
  final String imageUrl;
  final String rating;
  final String price;
  final List<String> cities;
  final List<String> languages;
  final List<String> gallery;
  final String guidedId;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          clipBehavior: Clip.none,
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
              child: ActionRowInTourGuideScreen(guideId: guidedId),
            ),
            Positioned(
              bottom: -45.h,
              left: 16.w,
              right: 0,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TourGuideProfileImage(imageUrl: imageUrl),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 8.h, right: 16.w),
                      child: TourGuideInfoDetiles(
                        firstName: name,
                        lastName: lastName,
                        rating: rating,
                        price: price,
                        cities: cities,
                        number: '',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        CustomHeightSpacingWidget(height: 65.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomContainerAboutTheGuide(name: name, aboutGuide: aboutGuide),
              CustomHeightSpacingWidget(height: 16.h),
              CustomContainerExpertiseAndSkills(languages: languages),
              if (gallery.isNotEmpty) ...[
                CustomHeightSpacingWidget(height: 16.h),
                TourGuideGalleryWidget(galleryUrls: gallery),
              ],
              CustomHeightSpacingWidget(height: 20.h),
            ],
          ),
        ),
      ],
    );
  }
}
