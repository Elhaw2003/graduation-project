import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_guide/core/shared_widgets/custom_arrow_back_button.dart';
import 'package:smart_guide/core/utils/app_colors.dart';
import 'package:smart_guide/feature/guides/presentation/view/widgets/text_section_in_choose_guide.dart';
import 'package:smart_guide/generated/locale_keys.g.dart';

class AllGuidesAppbar extends StatelessWidget {
  const AllGuidesAppbar({
    super.key,
    required this.fadeAnimations,
    required this.slideAnimations,
  });

  final List<Animation<double>> fadeAnimations;
  final List<Animation<Offset>> slideAnimations;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      expandedHeight: 200.h,
      collapsedHeight: 200.h,
      toolbarHeight: 60.h,
      automaticallyImplyLeading: false,
      leading: CustomArrowBackButton(iconColor: AppColors.arrowBackColor),
      backgroundColor: AppColors.backgroundColor,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.primaryColor.withOpacity(0.15),
                    AppColors.backgroundColor,
                  ],
                ),
              ),
            ),
            SafeArea(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FadeTransition(
                      opacity: fadeAnimations.isNotEmpty
                          ? fadeAnimations[0]
                          : const AlwaysStoppedAnimation(1.0),
                      child: SlideTransition(
                        position: slideAnimations.isNotEmpty
                            ? slideAnimations[0]
                            : const AlwaysStoppedAnimation(Offset.zero),
                        child: TextSectionInChooseGuids(
                          title: LocaleKeys.verifiedLocalGuides.tr(),
                          subTitle: LocaleKeys
                              .exploreEgyptThroughTheEyesOfExpertsWhoKnowEveryStory
                              .tr(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}