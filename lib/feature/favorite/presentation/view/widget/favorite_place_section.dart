import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_guide/core/shared_widgets/custom_spacing_widget.dart';
import 'package:smart_guide/core/utils/app_colors.dart';
import 'package:smart_guide/core/utils/app_text_style.dart';
import 'package:smart_guide/feature/favorite/data/model/favorite_place_model.dart';
import 'package:smart_guide/feature/favorite/presentation/view/widget/favorite_place_card.dart';

class FavoritePlaceSection extends StatelessWidget {
  const FavoritePlaceSection({super.key, required this.section});

  final FavoritePlaceModel section;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(5.r),
        border: Border.all(color: AppColors.grey100Color),
        boxShadow: [
          BoxShadow(
            color: AppColors.blackColor.withValues(alpha: 0.06),
            blurRadius: 5.r,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(12.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              section.title,
              style: AppTextStyle.primaryTextW600S22.copyWith(fontSize: 18.sp),
            ),
            CustomHeightSpacingWidget(height: 4),
            Text(
              section.description,
              style: AppTextStyle.primaryTextW400S14.copyWith(
                color: AppColors.grey400Color,
              ),
            ),
            CustomHeightSpacingWidget(height: 12),
            SizedBox(
              height: 110.h,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: section.places.length,
                separatorBuilder: (_, _) => CustomWidthSpacingWidget(width: 12),
                itemBuilder: (context, index) {
                  return FavoritePlaceCard(
                    place: section.places[index],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
