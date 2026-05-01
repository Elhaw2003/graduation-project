import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smart_guide/core/shared_widgets/custom_spacing_widget.dart';
import 'package:smart_guide/core/utils/app_colors.dart';
import 'package:smart_guide/core/utils/app_text_style.dart';
import 'package:smart_guide/feature/saved/data/model/save_placed_card_model.dart';
import 'package:smart_guide/feature/saved/presentation/view/widget/save_placed_card.dart';
import 'package:smart_guide/generated/assets.dart';
import 'package:smart_guide/generated/locale_keys.g.dart';

class SavePlacedCardList extends StatelessWidget {
  const SavePlacedCardList({super.key, required this.places});
  final List<SavedPlaceedCardModel> places;
  @override
  Widget build(BuildContext context) {
    return places.isEmpty
        ? SliverFillRemaining(hasScrollBody: false, child: emptySavedWidget())
        : SliverPadding(
            padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 10.h),
            sliver: SliverList.builder(
              itemCount: places.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 20.h),
                  child: SavePlacedCard(savedPlaceedCardModel: places[index]),
                );
              },
            ),
          );
  }
}

Widget emptySavedWidget() => Center(
  child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      SvgPicture.asset(
        Assets.imagesSvgBucketListEmpty,
        width: 225.w,
        height: 225.h,
      ),
      CustomHeightSpacingWidget(height: 20),
      Text(
        LocaleKeys.bucketListEmpty.tr(),
        style: AppTextStyle.secondaryColorW400S13.copyWith(fontSize: 19.sp),
        textAlign: TextAlign.center,
      ),
      CustomHeightSpacingWidget(height: 20),
      Text(
        LocaleKeys.bucketListEmptyDescription.tr(),
        style: AppTextStyle.primaryTextW400S16.copyWith(
          color: AppColors.grey300Color,
          fontSize: 14.sp,
        ),
        textAlign: TextAlign.center,
      ),
    ],
  ),
);
