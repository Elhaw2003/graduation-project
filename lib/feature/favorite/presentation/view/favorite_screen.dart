import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_guide/core/shared_widgets/custom_spacing_widget.dart';
import 'package:smart_guide/core/utils/app_colors.dart';
import 'package:smart_guide/core/utils/app_text_style.dart';
import 'package:smart_guide/feature/favorite/data/model/favorite_place_model.dart';
import 'package:smart_guide/feature/favorite/presentation/view/widget/favorite_places_appbar.dart';
import 'package:smart_guide/feature/favorite/presentation/view/widget/favorite_place_section.dart';
import 'package:smart_guide/generated/locale_keys.g.dart';

class FavoritePlacesScreen extends StatelessWidget {
  const FavoritePlacesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const FavoriteSliverAppBar(),
          SliverToBoxAdapter(
            child: Center(
              child: Text(
                LocaleKeys.favoritePlacesDescription.tr(),
                textAlign: TextAlign.center,
                style: AppTextStyle.primaryTextW400S16.copyWith(
                  color: AppColors.grey200Color,
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 32.h),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                for (final section in favoriteDemoSections) ...[
                  FavoritePlaceSection(section: section),
                  const CustomHeightSpacingWidget(height: 20),
                ],
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
