import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_guide/core/shared_widgets/custom_sliver_appbar_widget.dart';
import 'package:smart_guide/core/shared_widgets/custom_spacing_widget.dart';
import 'package:smart_guide/core/utils/app_colors.dart';
import 'package:smart_guide/core/utils/app_text_style.dart';
import 'package:smart_guide/feature/book_now/data/booknow/booknow_cubit.dart';
import 'package:smart_guide/feature/book_now/data/booknow/booknow_state.dart';
import 'package:smart_guide/feature/book_now/presentation/view/schedule_screen.dart';
import 'package:smart_guide/feature/book_now/presentation/view/widget/payment_step_widget.dart';
import 'package:smart_guide/feature/book_now/presentation/view/widget/step_header_widget.dart';
import 'package:smart_guide/feature/book_now/presentation/view/widget/steps_list_widget.dart';
import 'package:smart_guide/generated/locale_keys.g.dart';

class BookNowScreen extends StatefulWidget {
  const BookNowScreen({super.key, required this.guideId});

  final String guideId;

  @override
  State<BookNowScreen> createState() => _BookNowScreenState();
}

class _BookNowScreenState extends State<BookNowScreen> {
  @override
  void initState() {
    super.initState();

    context.read<BookNowCubit>().getGuideTours(guideId: widget.guideId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,

      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),

        child: CustomScrollView(
          slivers: [
            /// APP BAR
            CustomSliverAppbarWidget(title: LocaleKeys.bookYourExperience.tr()),

            /// DESCRIPTION
            SliverToBoxAdapter(
              child: Center(
                child: Text(
                  LocaleKeys.bookYourExperienceDescription.tr(),

                  textAlign: TextAlign.center,

                  style: AppTextStyle.primaryTextW400S16.copyWith(
                    color: AppColors.grey300Color,
                  ),
                ),
              ),
            ),

            SliverToBoxAdapter(child: CustomHeightSpacingWidget(height: 16)),

            /// HEADER
            SliverToBoxAdapter(
              child: StepHeaderWidget(
                currentStep: context.watch<BookNowCubit>().currentStep,
              ),
            ),

            SliverToBoxAdapter(child: CustomHeightSpacingWidget(height: 16)),

            /// TITLE
            SliverToBoxAdapter(
              child: Text(
                context.watch<BookNowCubit>().currentStep == 1
                    ? LocaleKeys.whatKindOfTour.tr()
                    : context.watch<BookNowCubit>().currentStep == 2
                    ? 'Choose Schedule'
                    : 'Payment',

                textAlign: TextAlign.center,

                style: AppTextStyle.black1F2937W500S20,
              ),
            ),

            SliverToBoxAdapter(child: CustomHeightSpacingWidget(height: 16)),

            /// BODY
            BlocBuilder<BookNowCubit, BookNowStates>(
              builder: (context, state) {
                final cubit = context.watch<BookNowCubit>();

                /// STEP 1
                if (cubit.currentStep == 1) {
                  return const StepsListWidget();
                }

                /// STEP 2
                if (cubit.currentStep == 2) {
                  return const ScheduleStepWidget();
                }

                /// STEP 3
                return PaymentStepWidget(
                  tourId: cubit.selectedTour!.title,

                  selectedDate: cubit.selectedDate!,

                  bookingTime: cubit.bookingTime!,
                );
              },
            ),

            SliverToBoxAdapter(child: CustomHeightSpacingWidget(height: 30)),
          ],
        ),
      ),
    );
  }
}
