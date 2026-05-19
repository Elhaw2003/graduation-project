import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_guide/core/shared_widgets/custom_spacing_widget.dart';
import 'package:smart_guide/core/utils/app_colors.dart';
import 'package:smart_guide/core/utils/app_text_style.dart';
import 'package:smart_guide/feature/book_now/data/booknow/booknow_cubit.dart';
import 'package:smart_guide/feature/book_now/data/booknow/booknow_state.dart';
import 'package:smart_guide/feature/book_now/data/model/item_booked_model.dart';
import 'package:smart_guide/feature/book_now/presentation/view/widget/item_booked_widget.dart';

class StepsListWidget extends StatelessWidget {
  const StepsListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookNowCubit, BookNowStates>(
      builder: (context, state) {
        final cubit = context.watch<BookNowCubit>();

        /// ERROR
        if (state is BookNowFailure) {
          return SliverToBoxAdapter(
            child: Center(
              child: Text(state.errorMessage),
            ),
          );
        }

        /// LOADING FIRST TIME ONLY
        if (state is BookNowLoading && cubit.tours.isEmpty) {
          return const SliverToBoxAdapter(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        final tours = cubit.tours;

        if (tours.isEmpty) {
          return const SliverToBoxAdapter(
            child: Center(
              child: Text('No Tours Found'),
            ),
          );
        }

        return SliverList.separated(
          itemCount: tours.length,

          separatorBuilder: (_, _) =>
              CustomHeightSpacingWidget(height: 16),

          itemBuilder: (context, index) {
            final tour = tours[index];

            final isSelected =
                cubit.selectedTourId == tour.id;

            return Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [
                /// TOUR CARD
                ItemBookedWidget(
                  onTap: () {
                    context
                        .read<BookNowCubit>()
                        .getTourDetails(
                          tourId: tour.id,
                        );
                  },

                  itemBookedModel: ItemBookedModel(
                    title: tour.title,

                    subtitle:
                        'Duration: ${tour.durationHours} hours',

                    price: '\$${tour.price}',

                    image: tour.primaryImage,
                  ),
                ),

                /// DETAILS
                if (isSelected &&
                    cubit.selectedTour != null)
                  Container(
                    width: double.infinity,

                    margin: EdgeInsets.only(
                      top: 10.h,
                    ),

                    padding: EdgeInsets.all(12.sp),

                    decoration: BoxDecoration(
                      color: Colors.white,

                      borderRadius:
                          BorderRadius.circular(12.r),

                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),

                          blurRadius: 8.r,
                        ),
                      ],
                    ),

                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,

                      children: [
                        /// PRICE
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.w,
                            vertical: 6.h,
                          ),

                          decoration: BoxDecoration(
                            color: AppColors.primaryColor,

                            borderRadius:
                                BorderRadius.circular(8.r),
                          ),

                          child: Text(
                            'Duration: ${cubit.selectedTour!.durationHours} hours | Cost: \$${cubit.selectedTour!.price}',

                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),

                        SizedBox(height: 16.h),

                        /// PROGRAM
                        Text(
                          'Program :',

                          style:
                              AppTextStyle.primaryTextW500S17,
                        ),

                        SizedBox(height: 8.h),

                        ...cubit.selectedTour!.stops.map(
                          (stop) => Padding(
                            padding:
                                EdgeInsets.only(bottom: 6.h),

                            child: Text(
                              '${stop.orderIndex + 1}. ${stop.title} - ${stop.description}',
                            ),
                          ),
                        ),

                        SizedBox(height: 16.h),

                        /// INCLUDES
                        Text(
                          'Includes :',

                          style:
                              AppTextStyle.primaryTextW500S17,
                        ),

                        SizedBox(height: 8.h),

                        ...cubit.selectedTour!.inclusions.map(
                          (e) => Padding(
                            padding:
                                EdgeInsets.only(bottom: 6.h),

                            child: Text(
                              '• ${e.description}',
                            ),
                          ),
                        ),

                        SizedBox(height: 20.h),

                        /// NEXT BUTTON
                        SizedBox(
                          width: double.infinity,

                          child: ElevatedButton(
                            onPressed: () {
                              context
                                  .read<BookNowCubit>()
                                  .goToScheduleStep();
                            },

                            child: const Text('Next'),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            );
          },
        );
      },
    );
  }
}