import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_guide/core/shared_widgets/custom_spacing_widget.dart';
import 'package:smart_guide/core/utils/app_colors.dart';
import 'package:smart_guide/core/utils/app_text_style.dart';
import 'package:smart_guide/feature/details/presentation/view/widget/details_top_button_widget.dart';
import 'package:smart_guide/feature/saved/presentation/cubit/saved_places_cubit.dart';
import 'package:smart_guide/feature/saved/presentation/cubit/saved_places_states.dart';
import 'package:smart_guide/generated/assets.dart';

class DetailsTourAppbarWidget extends StatelessWidget {
  const DetailsTourAppbarWidget({
    super.key,
    required this.headerAnimationController,
    required this.scrollOffset,
    this.imageUrl,
    this.title,
    this.rating,
    this.placeId,
  });

  final AnimationController headerAnimationController;
  final double scrollOffset;
  final String? imageUrl;
  final String? title;
  final num? rating;
  final int? placeId;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SavedPlacesCubit, SavedPlacesState>(
      builder: (context, state) {
        final isSaved =
            placeId != null &&
            (state is SavedPlacesSuccess) &&
            state.savedIds.contains(placeId);

        return SliverAppBar(
          toolbarHeight: 60.h,
          expandedHeight: 280.h,
          pinned: true,
          stretch: true,
          elevation: 0,
          automaticallyImplyLeading: false,
          backgroundColor: AppColors.backgroundColor,
          surfaceTintColor: Colors.transparent,

          leading: DetailsTopButtonWidget(
            icon: Icons.arrow_back,
            onTap: () => Navigator.pop(context),
          ),

          actions: [
            if (placeId != null)
              DetailsTopButtonWidget(
                icon: isSaved
                    ? Icons.bookmark_rounded
                    : Icons.bookmark_border_rounded,
                color: isSaved ? AppColors.primaryColor : Colors.white,
                onTap: () {
                  if (isSaved) {
                    context.read<SavedPlacesCubit>().removePlace(
                      placeId: placeId!,
                    );
                  } else {
                    context.read<SavedPlacesCubit>().savePlace(
                      placeId: placeId!,
                    );
                  }
                },
              ),

            SizedBox(width: 8.w),
          ],

          flexibleSpace: FlexibleSpaceBar(
            stretchModes: const [StretchMode.zoomBackground],
            background: Stack(
              fit: StackFit.expand,
              children: [
                imageUrl != null && imageUrl!.isNotEmpty
                    ? Image.network(
                        imageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset(
                            Assets.imagesPngFirstSplashScreen,
                            fit: BoxFit.cover,
                          );
                        },
                      )
                    : Image.asset(
                        Assets.imagesPngFirstSplashScreen,
                        fit: BoxFit.cover,
                      ),

                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.2),
                        Colors.transparent,
                        Colors.black.withOpacity(0.7),
                      ],
                    ),
                  ),
                ),

                Positioned(
                  bottom: 20.h,
                  left: 20.w,
                  right: 20.w,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title ?? "Unknown Place",
                        textAlign: TextAlign.center,
                        style: AppTextStyle.whitePoppinsW500S24.copyWith(
                          fontSize: 20.sp,
                        ),
                      ),

                      CustomHeightSpacingWidget(height: 10),

                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.star, color: Colors.yellow, size: 16.sp),

                          SizedBox(width: 4.w),

                          Text(
                            rating != null && rating! > 0
                                ? rating!.toStringAsFixed(1)
                                : "New",
                            style: AppTextStyle.whitePoppinsW400S16.copyWith(
                              fontSize: 14.sp,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
