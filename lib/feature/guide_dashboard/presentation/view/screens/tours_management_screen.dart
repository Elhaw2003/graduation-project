import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_guide/core/routing/app_routes.dart';
import 'package:smart_guide/core/utils/app_colors.dart';
import 'package:smart_guide/core/utils/app_text_style.dart';
import 'package:smart_guide/feature/guide_dashboard/presentation/cubit/guide_dashboard_cubit.dart';
import 'package:smart_guide/feature/guide_dashboard/presentation/cubit/guide_dashboard_states.dart';
import 'package:smart_guide/feature/guide_dashboard/presentation/view/widget/tour_list_item.dart';
import 'package:smart_guide/feature/guid_app/presentation/view/edit_tour_screen.dart';

void _showGradientSnack(
  BuildContext context,
  String msg, {
  bool isSuccess = true,
  bool isDelete = false,
}) {
  final List<Color> colors = isDelete
      ? [const Color(0xFFEF4444), const Color(0xFFF59E0B)]
      : isSuccess
          ? [const Color(0xFF1E4DB7), const Color(0xFF10B981)]
          : [const Color(0xFFDC2626), const Color(0xFFEA580C)];
  final icon = isDelete
      ? Icons.delete_sweep_rounded
      : isSuccess
          ? Icons.check_circle_rounded
          : Icons.error_rounded;

  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      padding: EdgeInsets.zero,
      duration: const Duration(seconds: 3),
      content: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 13.h),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: colors,
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(14.r),
          boxShadow: [
            BoxShadow(
              color: colors.first.withOpacity(0.35),
              blurRadius: 14,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 20.sp),
            SizedBox(width: 10.w),
            Expanded(
              child: Text(
                msg,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class ToursManagementScreen extends StatefulWidget {
  const ToursManagementScreen({super.key});

  @override
  State<ToursManagementScreen> createState() => _ToursManagementScreenState();
}

class _ToursManagementScreenState extends State<ToursManagementScreen> {
  @override
  void initState() {
    super.initState();
    context.read<GuideDashboardCubit>().fetchMyTours();
  }

  void _openCreateTour() {
    final cubit = context.read<GuideDashboardCubit>();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: cubit,
          child: const EditTourScreen(),
        ),
      ),
    ).then((_) {
      if (mounted) cubit.fetchMyTours();
    });
  }

  void _openEditTour(String tourId) {
    final cubit = context.read<GuideDashboardCubit>();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: cubit,
          child: EditTourScreen(tourId: tourId),
        ),
      ),
    ).then((_) {
      if (mounted) cubit.fetchMyTours();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.secondaryColor,
        elevation: 0,
        leading: const BackButton(color: Colors.white),
        title: Text('My Tours', style: AppTextStyle.whitePoppinsW500S20),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16.w),
            child: GestureDetector(
              onTap: _openCreateTour,
              child: Icon(Icons.add_circle_outline, size: 24.sp, color: Colors.white),
            ),
          ),
        ],
      ),
      body: BlocConsumer<GuideDashboardCubit, GuideDashboardState>(
        listener: (context, state) {
          if (state is DeleteTourSuccess) {
            _showGradientSnack(context, 'Tour deleted successfully', isDelete: true);
            context.read<GuideDashboardCubit>().fetchMyTours();
          } else if (state is DeleteTourFailure) {
            _showGradientSnack(context, state.errorMessage, isSuccess: false);
          }
        },
        builder: (context, state) {
          if (state is GetMyToursLoading || state is DeleteTourLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is GetMyToursFailure) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.error_outline, size: 48.sp, color: AppColors.redAppColor),
                  SizedBox(height: 16.h),
                  Text(state.errorMessage),
                  SizedBox(height: 24.h),
                  ElevatedButton.icon(
                    onPressed: () =>
                        context.read<GuideDashboardCubit>().fetchMyTours(),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is GetMyToursSuccess) {
            final tours = state.myToursList;

            if (tours.isEmpty) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.tour_outlined, size: 64.sp, color: AppColors.grey300Color),
                    SizedBox(height: 16.h),
                    Text(
                      'No tours yet',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.grey400Color,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Create your first tour to get started',
                      style: TextStyle(fontSize: 14.sp, color: AppColors.grey400Color),
                    ),
                    SizedBox(height: 24.h),
                    ElevatedButton.icon(
                      onPressed: _openCreateTour,
                      icon: const Icon(Icons.add),
                      label: const Text('Create Tour'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                          horizontal: 24.w,
                          vertical: 12.h,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: EdgeInsets.all(16.w),
              itemCount: tours.length,
              itemBuilder: (context, index) {
                final tour = tours[index];
                return TourListItem(
                  tour: tour,
                  onTap: () async {
                    await context.pushNamed(
                      AppRoutes.tourDetailScreen,
                      pathParameters: {'tourId': tour.id},
                    );
                    if (mounted) {
                      context.read<GuideDashboardCubit>().fetchMyTours();
                    }
                  },
                  onDelete: () => _showDeleteConfirmation(context, tour.id),
                  onEdit: () => _openEditTour(tour.id),
                );
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, String tourId) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Tour'),
        content: const Text(
          'Are you sure you want to delete this tour? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<GuideDashboardCubit>().removeTour(id: tourId);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
