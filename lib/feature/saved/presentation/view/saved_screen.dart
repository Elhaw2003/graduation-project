import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_guide/core/shared_widgets/custom_sliver_appbar_widget.dart';
import 'package:smart_guide/core/utils/app_colors.dart';
import 'package:smart_guide/core/utils/app_text_style.dart';
import 'package:smart_guide/core/methods/save_place_feedback.dart';
import 'package:smart_guide/feature/saved/presentation/cubit/saved_places_cubit.dart';
import 'package:smart_guide/feature/saved/presentation/cubit/saved_places_states.dart';
import 'package:smart_guide/feature/saved/presentation/view/widget/save_placed_card_list.dart';
import 'package:smart_guide/feature/saved/data/model/save_placed_card_model.dart';
import 'package:smart_guide/generated/locale_keys.g.dart';

class SavedScreen extends StatefulWidget {
  const SavedScreen({super.key});

  @override
  State<SavedScreen> createState() => _SavedScreenState();
}

class _SavedScreenState extends State<SavedScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // floatingActionButton: FabNewPlaceWidget(isFabVisible: _isFabVisible),
      body: BlocListener<SavedPlacesCubit, SavedPlacesState>(
        listener: (context, state) {
          if (state is RemovePlaceSuccess) {
            SaveFeedback.removed(context);
          }
        },
        child: BlocBuilder<SavedPlacesCubit, SavedPlacesState>(
          builder: (context, state) {
            if (state is SavedPlacesLoading) {
              return Scaffold(
                backgroundColor: AppColors.backgroundColor,
                body: Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primaryColor,
                  ),
                ),
              );
            }

            List<SavedPlaceedCardModel> places = [];
            if (state is SavedPlacesSuccess) {
              places = state.places
                  .map((p) => SavedPlaceedCardModel.fromPlaceModel(p))
                  .toList();
            }

            return CustomScrollView(
              slivers: [
                CustomSliverAppbarWidget(title: LocaleKeys.savedForLater.tr()),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(30.w, 12.h, 30.w, 20.h),
                    child: Text(
                      LocaleKeys.savedDescription.tr(),
                      textAlign: TextAlign.center,
                      style: AppTextStyle.primaryTextW400S16.copyWith(
                        color: AppColors.grey300Color,
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
                ),
                SavePlacedCardList(places: places),
              ],
            );
          },
        ),
      ),
    );
  }
}
