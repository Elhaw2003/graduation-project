import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_guide/core/shared_widgets/custom_sliver_appbar_widget.dart';
import 'package:smart_guide/core/shared_widgets/custom_spacing_widget.dart';
import 'package:smart_guide/core/utils/app_colors.dart';
import 'package:smart_guide/core/utils/app_text_style.dart';
import 'package:smart_guide/feature/book_now/presentation/view/widget/step_header_widget.dart';
import 'package:smart_guide/feature/book_now/presentation/view/widget/steps_list_widget.dart';
import 'package:smart_guide/generated/locale_keys.g.dart';

class BookNowScreen extends StatelessWidget {
  const BookNowScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: CustomScrollView(
          slivers: [
            CustomSliverAppbarWidget(title: LocaleKeys.bookYourExperience.tr()),
            SliverToBoxAdapter(
              child: Center(
                child: Text(
                  LocaleKeys.bookYourExperienceDescription.tr(),
                  style: AppTextStyle.primaryTextW400S16.copyWith(
                    color: AppColors.grey300Color,
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(child: CustomHeightSpacingWidget(height: 16)),
            const SliverToBoxAdapter(child: StepHeaderWidget()),
            SliverToBoxAdapter(child: CustomHeightSpacingWidget(height: 16)),
            SliverToBoxAdapter(
              child: Text(
                LocaleKeys.whatKindOfTour.tr(),
                textAlign: TextAlign.center,
                style: AppTextStyle.black1F2937W500S20,
              ),
            ),
            SliverToBoxAdapter(child: CustomHeightSpacingWidget(height: 16)),
            StepsListWidget(),
            SliverToBoxAdapter(child: CustomHeightSpacingWidget(height: 16)),
          ],
        ),
      ),
    );
  }
}
