import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_guide/core/shared_widgets/custom_spacing_widget.dart';
import 'package:smart_guide/core/shared_widgets/custom_text_field_widget.dart';
import 'package:smart_guide/core/utils/app_colors.dart';
import 'package:smart_guide/core/utils/app_text_style.dart';
import 'package:smart_guide/feature/guides/data/tour_guides/tour_guides_cubit.dart';
import 'package:smart_guide/feature/guides/data/tour_guides/tour_guides_state.dart';
import 'package:smart_guide/feature/human_guide/custom_container_info_guides.dart';

import 'package:smart_guide/feature/guides/presentation/view/widgets/text_section_in_choose_guide.dart';
import 'package:smart_guide/generated/locale_keys.g.dart';

class ChooseHumenGuidesScreenBody extends StatelessWidget {
  const ChooseHumenGuidesScreenBody({super.key, required this.itemCount});

  final int itemCount;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TourGuidesCubit, TourGuidesState>(
      builder: (context, state) {
        if (state is TourGuidesLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is TourGuidesError) {
          return Center(child: Text(state.message));
        }

        if (state is TourGuidesSuccess) {
          final guides = state.guides;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomHeightSpacingWidget(height: 86),

              Center(
                child: TextSectionInChooseGuids(
                  title: LocaleKeys.verifiedLocalGuides.tr(),
                  subTitle: LocaleKeys
                      .exploreEgyptThroughTheEyesOfExpertsWhoKnowEveryStory
                      .tr(),
                ),
              ),

              CustomHeightSpacingWidget(height: 24),

              /// ================= SEARCH =================
              Row(
                children: [
                  CustomTextFieldWidget(
                    width: MediaQuery.of(context).size.width - 86,
                    hintTextStyle: AppTextStyle.primaryW400S15.copyWith(
                      color: AppColors.secondaryTextColor,
                    ),
                    hintText: LocaleKeys.searchDestinationsAndGuides.tr(),
                    prefixIcon: Icons.search,
                    prefixColor: AppColors.secondaryTextColor,
                  ),
                  CustomWidthSpacingWidget(width: 4),
                  Container(
                    height: 45,
                    width: 50,
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: const Icon(
                      Icons.filter_alt_outlined,
                      color: AppColors.whiteColor,
                    ),
                  ),
                ],
              ),

              CustomHeightSpacingWidget(height: 32),

              /// ================= LIST =================
              ListView.separated(
                itemCount: guides.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final guide = guides[index];

                  return CustomContainerInfoGuides(
                    userID: guide.userId,
                    firstName: guide.firstName,
                    lastName: guide.lastName,
                    // if the guide doesn't have a profile picture, use a default image
                    imageUrl:
                        guide.profilePicture ??
                        "https://via.placeholder.com/100",
                    rating: guide.rating,
                    price: 0,
                  );
                },
                separatorBuilder: (context, index) {
                  return CustomHeightSpacingWidget(height: 16);
                },
              ),
            ],
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
