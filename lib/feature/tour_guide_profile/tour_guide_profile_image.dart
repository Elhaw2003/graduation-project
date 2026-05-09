import 'package:flutter/material.dart';
import 'package:smart_guide/core/utils/app_colors.dart';
import 'package:smart_guide/feature/human_guide/custom_container_info_guides.dart';

class TourGuideProfileImage extends StatelessWidget {
  const TourGuideProfileImage({super.key, required this.imageUrl});
  final String imageUrl ;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      width: 120,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.primaryColor, width: 3),
      ),
      child: Padding(
        padding: const EdgeInsets.all(3),
        child: ClipOval(
          child: Image.network(imageUrl.toHttps(), fit: BoxFit.fill),
        ),
      ),
    );
  }
}
