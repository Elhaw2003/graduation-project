import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_guide/core/shared_widgets/custom_spacing_widget.dart';
import 'package:smart_guide/core/utils/image_url_extension.dart';
import 'package:smart_guide/feature/tour_guide_profile/custom_container_about_the_guide.dart';
import 'package:smart_guide/feature/tour_guide_profile/custom_container_expertise_and_skills.dart';
import 'package:smart_guide/feature/tour_guide_profile/tour_guide_gallery_widget.dart';
import 'package:smart_guide/feature/tour_guide_profile/tour_guide_profile_image.dart';
import 'package:smart_guide/feature/tour_guide_profile/tour_guide_info.dart';
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
    required this.whatsAppNumber,
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
  final String whatsAppNumber;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            SizedBox(
              height: 260.h,
              width: double.infinity,
              child: Stack(
                // fit: StackFit.,
                children: [
                  if (imageUrl.isNotEmpty)
                    CachedNetworkImage(
                      imageUrl: imageUrl.toHttps(),
                      width: double.infinity,
                      fit: BoxFit.cover,
                      placeholder: (_, __) => Image.asset(
                        Assets.imagesPngPyramids,
                        fit: BoxFit.cover,
                      ),
                      errorWidget: (_, __, ___) => Image.asset(
                        Assets.imagesPngPyramids,
                        fit: BoxFit.cover,
                      ),
                    )
                  else
                    Image.asset(Assets.imagesPngPyramids, fit: BoxFit.cover),
                  // Container(
                  //   decoration: BoxDecoration(
                  //     gradient: LinearGradient(
                  //       begin: Alignment.topCenter,
                  //       end: Alignment.bottomCenter,
                  //       colors: [
                  //         Colors.black.withValues(alpha: 0.15),
                  //         Colors.black.withValues(alpha: 0.55),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                ],
              ),
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
              CustomContainerAboutTheGuide(
                name: name,
                aboutGuide: aboutGuide,
                guideId: guidedId,
                whatsAppNumber: whatsAppNumber,
              ),
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
