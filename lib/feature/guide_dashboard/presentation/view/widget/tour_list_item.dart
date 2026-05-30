import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_guide/core/utils/app_colors.dart';
import 'package:smart_guide/feature/guide_dashboard/data/model/guide_tour_summary_model.dart';

class TourListItem extends StatefulWidget {
  const TourListItem({
    required this.tour,
    required this.onTap,
    required this.onDelete,
    required this.onEdit,
  });

  final GuideTourSummaryModel tour;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  @override
  State<TourListItem> createState() => _TourListItemState();
}

class _TourListItemState extends State<TourListItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleExpand() {
    if (_isExpanded) {
      _controller.reverse();
    } else {
      _controller.forward();
    }
    setState(() => _isExpanded = !_isExpanded);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(12.r),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: AppColors.grey300Color.withOpacity(0.2),
              ),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(12.w),
                  child: Row(
                    children: [
                      Container(
                        width: 60.r,
                        height: 60.r,
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.tour,
                            color: AppColors.primaryColor,
                            size: 28.sp,
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.tour.title.isEmpty
                                  ? 'Tour Title'
                                  : widget.tour.title,
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primaryTextColor,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 4.h),
                            Row(
                              children: [
                                Icon(
                                  Icons.access_time,
                                  size: 12.sp,
                                  color: AppColors.grey400Color,
                                ),
                                SizedBox(width: 4.w),
                                Text(
                                  '${widget.tour.durationHours}h',
                                  style: TextStyle(
                                    fontSize: 11.sp,
                                    color: AppColors.grey400Color,
                                  ),
                                ),
                                SizedBox(width: 12.w),
                                Icon(
                                  Icons.people_outline,
                                  size: 12.sp,
                                  color: AppColors.grey400Color,
                                ),
                                SizedBox(width: 4.w),
                                Text(
                                  '${widget.tour.maxGroupSize} max',
                                  style: TextStyle(
                                    fontSize: 11.sp,
                                    color: AppColors.grey400Color,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '\$${(widget.tour.price == 0 ? 0 : widget.tour.price).toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColors.greenColor,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          GestureDetector(
                            onTap: _toggleExpand,
                            child: Icon(
                              _isExpanded
                                  ? Icons.expand_less
                                  : Icons.expand_more,
                              size: 20.sp,
                              color: AppColors.primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                AnimatedSize(
                  duration: const Duration(milliseconds: 300),
                  child: _isExpanded
                      ? Container(
                          width: double.infinity,
                          padding: EdgeInsets.fromLTRB(12.w, 0, 12.w, 12.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Divider(
                                color: AppColors.grey300Color.withOpacity(0.2),
                              ),
                              SizedBox(height: 12.h),
                              Text(
                                'Tour Details',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryTextColor,
                                ),
                              ),
                              SizedBox(height: 8.h),
                              _DetailRow(
                                label: 'Duration',
                                value: '${widget.tour.durationHours} hours',
                              ),
                              _DetailRow(
                                label: 'Max Group Size',
                                value: '${widget.tour.maxGroupSize} people',
                              ),
                              _DetailRow(
                                label: 'Price per Person',
                                value:
                                    '\$${(widget.tour.price == 0 ? 0 : widget.tour.price).toStringAsFixed(2)}',
                              ),
                              SizedBox(height: 12.h),
                              Row(
                                children: [
                                  Expanded(
                                    child: _ActionButton(
                                      label: 'Edit',
                                      icon: Icons.edit_outlined,
                                      onTap: widget.onEdit,
                                      isPrimary: true,
                                    ),
                                  ),
                                  SizedBox(width: 8.w),
                                  Expanded(
                                    child: _ActionButton(
                                      label: 'Delete',
                                      icon: Icons.delete_outline,
                                      onTap: widget.onDelete,
                                      isPrimary: false,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 11.sp,
              color: AppColors.grey400Color,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryTextColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.label,
    required this.icon,
    required this.onTap,
    required this.isPrimary,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool isPrimary;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        decoration: BoxDecoration(
          color: isPrimary
              ? AppColors.primaryColor.withOpacity(0.1)
              : AppColors.redAppColor.withOpacity(0.1),
          border: Border.all(
            color: (isPrimary ? AppColors.primaryColor : AppColors.redAppColor)
                .withOpacity(0.3),
          ),
          borderRadius: BorderRadius.circular(6.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 14.sp,
              color: isPrimary ? AppColors.primaryColor : AppColors.redAppColor,
            ),
            SizedBox(width: 4.w),
            Text(
              label,
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w600,
                color:
                    isPrimary ? AppColors.primaryColor : AppColors.redAppColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
