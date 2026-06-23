import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_guide/core/shared_widgets/custom_spacing_widget.dart';
import 'package:smart_guide/core/shared_widgets/custom_text_field_widget.dart';
import 'package:smart_guide/core/utils/app_colors.dart';
import 'package:smart_guide/feature/home/presentation/search_screen.dart';
import 'package:smart_guide/feature/popular_places/presentation/view/widget/filter_bottom_sheet.dart';
import 'package:smart_guide/generated/locale_keys.g.dart';

class PopularPlacesSearchFilter extends StatelessWidget {
  const PopularPlacesSearchFilter({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SearchPlacesScreen()),
                );
              },
              child: AbsorbPointer(
                child: CustomTextFieldWidget(
                  hintText: LocaleKeys.searchDestinationsAndGuides.tr(),
                  prefixIcon: Icons.search,
                  prefixColor: AppColors.grey400Color,
                ),
              ),
            ),
          ),

          CustomWidthSpacingWidget(width: 8.w),

          // Container(
          //   decoration: BoxDecoration(
          //     border: Border.all(color: AppColors.grey200Color),
          //     borderRadius: BorderRadius.circular(8.r),
          //   ),
          //   child: IconButton(
          //     onPressed: () {
          //       showModalBottomSheet(
          //         context: context,
          //         backgroundColor: AppColors.whiteColor,
          //         isScrollControlled: true,
          //         useSafeArea: true,
          //         shape: RoundedRectangleBorder(
          //           borderRadius: BorderRadius.vertical(
          //             top: Radius.circular(20.r),
          //           ),
          //         ),
          //         builder: (context) => const FilterBottomSheet(),
          //       );
          //     },
          //     icon: Icon(
          //       Icons.tune,
          //       color: AppColors.primaryColor,
          //       size: 24.sp,
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
