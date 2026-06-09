import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_guide/core/utils/app_colors.dart';
import 'package:smart_guide/feature/guide_dashboard/data/model/guide_tour_detail_model.dart';
import 'package:smart_guide/feature/guide_dashboard/presentation/cubit/guide_dashboard_cubit.dart';
import 'package:smart_guide/feature/guide_dashboard/presentation/cubit/guide_dashboard_states.dart';

class TourDetailScreen extends StatefulWidget {
  final String tourId;

  const TourDetailScreen({super.key, required this.tourId});

  @override
  State<TourDetailScreen> createState() => _TourDetailScreenState();
}

class _TourDetailScreenState extends State<TourDetailScreen> {
  @override
  void initState() {
    super.initState();
    context.read<GuideDashboardCubit>().fetchTourDetails(id: widget.tourId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.secondaryColor,
        elevation: 0,
        leading: const BackButton(color: Colors.white),
      ),
      body: BlocBuilder<GuideDashboardCubit, GuideDashboardState>(
        builder: (context, state) {
          if (state is GetTourDetailsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is GetTourDetailsFailure) {
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
                    onPressed: () => context
                        .read<GuideDashboardCubit>()
                        .fetchTourDetails(id: widget.tourId),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is GetTourDetailsSuccess) {
            final tour = state.tourDetailModel;
            return _TourDetailContent(tour: tour);
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _TourDetailContent extends StatelessWidget {
  const _TourDetailContent({required this.tour});

  final GuideTourDetailModel tour;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: _TourImageGallery(images: tour.images)),
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tour.title.isEmpty ? 'Tour Title' : tour.title,
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryTextColor,
                  ),
                ),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 16.sp,
                      color: AppColors.grey400Color,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      '${tour.durationHours} hours',
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: AppColors.grey400Color,
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Icon(
                      Icons.attach_money,
                      size: 16.sp,
                      color: AppColors.greenColor,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      '\$${tour.price.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: AppColors.greenColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        if (tour.description.isNotEmpty)
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryTextColor,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    tour.description,
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: AppColors.secondaryTextColor,
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: 20.h),
                ],
              ),
            ),
          ),
        if (tour.stops.isNotEmpty)
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tour Stops',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryTextColor,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  ...tour.stops.asMap().entries.map((entry) {
                    final index = entry.key;
                    final stop = entry.value;
                    return _TourStopItem(
                      stopNumber: index + 1,
                      stopName: stop.stopName,
                      durationMinutes: stop.durationMinutes,
                    );
                  }),
                  SizedBox(height: 20.h),
                ],
              ),
            ),
          ),
        if (tour.inclusions.isNotEmpty)
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'What\'s Included',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryTextColor,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  ...tour.inclusions.map((inclusion) {
                    return _InclusionItem(item: inclusion.item);
                  }),
                  SizedBox(height: 20.h),
                ],
              ),
            ),
          ),
        if (tour.addOns.isNotEmpty)
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Add-ons',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryTextColor,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  ...tour.addOns.map((addOn) {
                    return _AddOnItem(title: addOn.title, price: addOn.price);
                  }),
                  SizedBox(height: 20.h),
                ],
              ),
            ),
          ),
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.edit),
                    label: const Text('Edit'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      _showDeleteConfirmationInDetails(context, tour.id);
                    },
                    icon: const Icon(Icons.delete_outline),
                    label: const Text('Delete'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.redAppColor,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(child: SizedBox(height: 20.h)),
      ],
    );
  }
}

void _showDeleteConfirmationInDetails(BuildContext context, String tourId) {
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

class _TourImageGallery extends StatefulWidget {
  const _TourImageGallery({required this.images});

  final List<String> images;

  @override
  State<_TourImageGallery> createState() => _TourImageGalleryState();
}

class _TourImageGalleryState extends State<_TourImageGallery> {
  late PageController _pageController;
  int _currentImageIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.images.isEmpty) {
      return Container(
        height: 250.h,
        color: AppColors.grey300Color.withOpacity(0.3),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.image_not_supported,
                size: 48.sp,
                color: AppColors.grey400Color,
              ),
              SizedBox(height: 8.h),
              Text(
                'No images available',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.grey400Color,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return SizedBox(
      height: 250.h,
      child: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() => _currentImageIndex = index);
            },
            itemCount: widget.images.length,
            itemBuilder: (context, index) {
              return CachedNetworkImage(
                imageUrl: widget.images[index],
                fit: BoxFit.contain,
                width: double.infinity,
                height: 250.h,
                placeholder: (context, url) => Container(
                  color: AppColors.grey300Color.withOpacity(0.2),
                  child: const Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.primaryColor,
                      ),
                    ),
                  ),
                ),
                // لو اللينك باظ أو السيرفر وقع بيعرض أيقونة صلبة بدون كراش
                errorWidget: (context, url, error) => Container(
                  color: AppColors.grey300Color.withOpacity(0.3),
                  child: Center(
                    child: Icon(
                      Icons.broken_image_rounded,
                      size: 48.sp,
                      color: AppColors.grey400Color,
                    ),
                  ),
                ),
              );
            },
          ),
          Positioned(
            bottom: 16.h,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  '${_currentImageIndex + 1}/${widget.images.length}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TourStopItem extends StatelessWidget {
  const _TourStopItem({
    required this.stopNumber,
    required this.stopName,
    required this.durationMinutes,
  });

  final int stopNumber;
  final String stopName;
  final int durationMinutes;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32.r,
            height: 32.r,
            decoration: BoxDecoration(
              color: AppColors.primaryColor,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Center(
              child: Text(
                '$stopNumber',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12.sp,
                ),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  stopName.isEmpty ? 'Stop' : stopName,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryTextColor,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  '${durationMinutes} minutes',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.grey400Color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InclusionItem extends StatelessWidget {
  const _InclusionItem({required this.item});

  final String item;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        children: [
          Icon(Icons.check_circle, size: 20.sp, color: AppColors.greenColor),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              item.isEmpty ? 'Inclusion' : item,
              style: TextStyle(
                fontSize: 13.sp,
                color: AppColors.primaryTextColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AddOnItem extends StatelessWidget {
  const _AddOnItem({required this.title, required this.price});

  final String title;
  final double price;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.primaryColor.withOpacity(0.2)),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                title.isEmpty ? 'Add-on' : title,
                style: TextStyle(
                  fontSize: 13.sp,
                  color: AppColors.primaryTextColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Text(
              '+\$${price.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 13.sp,
                color: AppColors.greenColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
