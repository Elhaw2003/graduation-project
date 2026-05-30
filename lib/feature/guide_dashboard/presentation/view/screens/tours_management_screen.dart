import 'package:easy_localization/easy_localization.dart';
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
import 'package:smart_guide/generated/locale_keys.g.dart';

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
            child: Center(
              child: GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Create Tour feature coming soon'),
                    ),
                  );
                },
                child: Icon(
                  Icons.add_circle_outline,
                  size: 24.sp,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
      body: BlocBuilder<GuideDashboardCubit, GuideDashboardState>(
        builder: (context, state) {
          if (state is GetMyToursLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is GetMyToursFailure) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 48.sp,
                    color: AppColors.redAppColor,
                  ),
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
                    Icon(
                      Icons.tour_outlined,
                      size: 64.sp,
                      color: AppColors.grey300Color,
                    ),
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
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppColors.grey400Color,
                      ),
                    ),
                    SizedBox(height: 24.h),
                    ElevatedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Create Tour feature coming soon'),
                          ),
                        );
                      },
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
                  onTap: () {
                    context.pushNamed(
                      AppRoutes.tourDetailScreen,
                      pathParameters: {'tourId': tour.id},
                    );
                  },
                  onDelete: () => _showDeleteConfirmation(context, tour.id),
                  onEdit: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Edit Tour feature coming soon'),
                      ),
                    );
                  },
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
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Tour deleted successfully'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
