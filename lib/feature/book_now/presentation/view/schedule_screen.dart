import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_guide/core/shared_widgets/custom_spacing_widget.dart';
import 'package:smart_guide/core/utils/app_colors.dart';
import 'package:smart_guide/core/utils/app_text_style.dart';
import 'package:smart_guide/feature/book_now/data/booknow/booknow_cubit.dart';
import 'package:smart_guide/feature/booking_payment/data/model/tour_slot_model.dart';
import 'package:smart_guide/feature/booking_payment/presentation/cubit/booking_payment_cubit.dart';
import 'package:smart_guide/feature/booking_payment/presentation/cubit/booking_payment_states.dart';
import 'package:smart_guide/generated/locale_keys.g.dart';

class ScheduleStepWidget extends StatefulWidget {
  const ScheduleStepWidget({super.key});

  @override
  State<ScheduleStepWidget> createState() => _ScheduleStepWidgetState();
}

class _ScheduleStepWidgetState extends State<ScheduleStepWidget>
    with SingleTickerProviderStateMixin {
  DateTime? selectedDate;
  TourSlotModel? selectedSlot;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onDatePicked() async {
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primaryColor,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: AppColors.primaryTextColor,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
        selectedSlot = null;
      });

      final bookNowCubit = context.read<BookNowCubit>();
      final tourId = bookNowCubit.selectedTourId;

      if (tourId != null && tourId.isNotEmpty) {
        final formattedDate =
            '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
        context.read<BookingAndPaymentCubit>().fetchAvailableTourSlots(
          tourId: tourId,
          date: formattedDate,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Container(
          padding: EdgeInsets.all(20.sp),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryColor.withValues(alpha: 0.08),
                blurRadius: 20.r,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Center(
                child: Text(
                  LocaleKeys.chooseSchedule.tr(),
                  style: AppTextStyle.black1F2937W500S20,
                ),
              ),

              CustomHeightSpacingWidget(height: 24),

              // Date Picker
              Text(
                LocaleKeys.tourDate.tr(),
                style: AppTextStyle.primaryTextW500S17,
              ),
              CustomHeightSpacingWidget(height: 10),

              GestureDetector(
                onTap: _onDatePicked,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 16.h,
                  ),
                  decoration: BoxDecoration(
                    color: selectedDate != null
                        ? AppColors.primaryColor.withValues(alpha: 0.04)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(14.r),
                    border: Border.all(
                      color: selectedDate != null
                          ? AppColors.primaryColor
                          : Colors.grey.shade300,
                      width: selectedDate != null ? 1.5 : 1,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        selectedDate == null
                            ? LocaleKeys.tourDate.tr()
                            : '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}',
                        style: selectedDate == null
                            ? AppTextStyle.grey300W400S16
                            : AppTextStyle.primaryTextW500S17,
                      ),
                      Container(
                        padding: EdgeInsets.all(8.r),
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Icon(
                          Icons.calendar_month_rounded,
                          color: AppColors.primaryColor,
                          size: 20.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              CustomHeightSpacingWidget(height: 24),

              // Available Slots
              Text(
                LocaleKeys.availableSlots.tr(),
                style: AppTextStyle.primaryTextW500S17,
              ),
              CustomHeightSpacingWidget(height: 12),

              BlocBuilder<BookingAndPaymentCubit, BookingPaymentState>(
                builder: (context, state) {
                  if (selectedDate == null) {
                    return _buildEmptySlotPlaceholder(
                      icon: Icons.calendar_today_outlined,
                      message: LocaleKeys.selectSlot.tr(),
                    );
                  }

                  if (state is TourSlotsLoading) {
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 30.h),
                        child: CircularProgressIndicator(
                          color: AppColors.primaryColor,
                          strokeWidth: 2.5,
                        ),
                      ),
                    );
                  }

                  if (state is TourSlotsFailure) {
                    return _buildEmptySlotPlaceholder(
                      icon: Icons.error_outline_rounded,
                      message: state.errorMessage,
                    );
                  }

                  if (state is TourSlotsSuccess && state.slots.isEmpty) {
                    return _buildEmptySlotPlaceholder(
                      icon: Icons.event_busy_rounded,
                      message: LocaleKeys.noSlotsAvailable.tr(),
                    );
                  }

                  final slots = state is TourSlotsSuccess
                      ? state.slots
                      : context.read<BookingAndPaymentCubit>().availableSlots;

                  if (slots.isEmpty) {
                    return _buildEmptySlotPlaceholder(
                      icon: Icons.event_busy_rounded,
                      message: LocaleKeys.noSlotsAvailable.tr(),
                    );
                  }

                  return Wrap(
                    spacing: 10.w,
                    runSpacing: 10.h,
                    children: slots.map((slot) {
                      final isSelected = selectedSlot?.id == slot.id;
                      return GestureDetector(
                        onTap: () {
                          setState(() => selectedSlot = slot);
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 10.h,
                          ),
                          decoration: BoxDecoration(
                            gradient: isSelected
                                ? LinearGradient(
                                    colors: [
                                      AppColors.primaryColor,
                                      AppColors.primaryColor.withValues(
                                        alpha: 0.8,
                                      ),
                                    ],
                                  )
                                : null,
                            color: isSelected ? null : Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.primaryColor
                                  : Colors.grey.shade300,
                              width: isSelected ? 1.5 : 1,
                            ),
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color: AppColors.primaryColor.withValues(
                                        alpha: 0.3,
                                      ),
                                      blurRadius: 8.r,
                                      offset: const Offset(0, 3),
                                    ),
                                  ]
                                : null,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.access_time_rounded,
                                size: 16.sp,
                                color: isSelected
                                    ? Colors.white
                                    : AppColors.primaryColor,
                              ),
                              CustomWidthSpacingWidget(width: 6),
                              Text(
                                slot.displayTime,
                                style: TextStyle(
                                  color: isSelected
                                      ? Colors.white
                                      : AppColors.primaryTextColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),

              CustomHeightSpacingWidget(height: 32),

              // Next Button
              SizedBox(
                width: double.infinity,
                height: 52.h,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                    elevation: 3,
                    shadowColor: AppColors.primaryColor.withValues(alpha: 0.4),
                  ),
                  onPressed: () {
                    if (selectedDate == null || selectedSlot == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(LocaleKeys.selectSlot.tr()),
                          backgroundColor: AppColors.redAppColor,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                        ),
                      );
                      return;
                    }

                    context.read<BookingAndPaymentCubit>().selectSlot(
                      selectedSlot!,
                    );

                    context.read<BookNowCubit>().goToPaymentStep(
                      selectedDate!,
                      selectedSlot!.displayTime,
                    );
                  },
                  child: Text(
                    LocaleKeys.next.tr(),
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptySlotPlaceholder({
    required IconData icon,
    required String message,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 30.h),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Icon(icon, size: 36.sp, color: Colors.grey.shade400),
          CustomHeightSpacingWidget(height: 10),
          Text(
            message,
            style: AppTextStyle.grey300W400S16,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
