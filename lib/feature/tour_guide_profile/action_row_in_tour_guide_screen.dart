import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_guide/core/shared_widgets/custom_arrow_back_button.dart';
import 'package:smart_guide/core/shared_widgets/custom_spacing_widget.dart';
import 'package:smart_guide/core/utils/app_colors.dart';
import 'package:smart_guide/feature/tour_guide_profile/presentation/cubit/save_guides/save_guides_cubit.dart';
import 'package:smart_guide/feature/tour_guide_profile/presentation/cubit/save_guides/save_guides_states.dart'
    show
        SavedGuidesState,
        RemoveGuideSuccess,
        SaveGuideSuccess; // عدل اسم الملف حسب مشروعك لو فيه s

class ActionRowInTourGuideScreen extends StatelessWidget {
  const ActionRowInTourGuideScreen({super.key, required this.guideId});
  final String guideId;

  @override
  Widget build(BuildContext context) {
    return BlocListener<SavedGuidesCubit, SavedGuidesState>(
      listener: (context, state) {
        if (state is SaveGuideSuccess && state.savedIds.contains(guideId)) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.greenColor,
              duration: const Duration(milliseconds: 1500),
            ),
          );
        } else if (state is RemoveGuideSuccess &&
            !state.savedIds.contains(guideId)) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.redAccent,
              duration: const Duration(milliseconds: 1500),
            ),
          );
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomHeightSpacingWidget(height: 84),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment
                  .spaceBetween, // هيرمي الأزرار في أقصى الأطراف تماماً
              children: [
                // 1. الزر الأيسر (السهم)
                const CustomArrowBackButton(iconColor: Colors.white),

                // 2. الزر الأيمن (الـ Bookmark)
                BlocBuilder<SavedGuidesCubit, SavedGuidesState>(
                  builder: (context, state) {
                    final Set<String> savedIds = state.getSavedIds();
                    final bool isSaved = savedIds.contains(guideId);

                    return IconButton(
                      onPressed: () {
                        if (isSaved) {
                          context.read<SavedGuidesCubit>().removeGuide(
                            guideId: guideId,
                          );
                        } else {
                          context.read<SavedGuidesCubit>().saveGuide(
                            guideId: guideId,
                          );
                        }
                      },
                      icon: Icon(
                        isSaved ? Icons.bookmark : Icons.bookmark_outline_sharp,
                        color: isSaved ? AppColors.primaryColor : Colors.white,
                        size: 28.sp,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
