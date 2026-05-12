import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_guide/core/routing/app_routes.dart';
import 'package:smart_guide/core/shared_widgets/custom_button_widget.dart';
import 'package:smart_guide/core/utils/app_colors.dart';
import 'package:smart_guide/core/utils/app_text_style.dart';
import 'package:smart_guide/generated/locale_keys.g.dart';

class CustomContainerInfoGuides extends StatefulWidget {
  const CustomContainerInfoGuides({
    super.key,
    required this.firstName,
    required this.lastName,
    required this.imageUrl,
    required this.rating,
    required this.price,
    required this.userID,
  });

  final String firstName;
  final String lastName;
  final String imageUrl;
  final double rating;
  final int? price;
  final String userID;

  @override
  State<CustomContainerInfoGuides> createState() =>
      _CustomContainerInfoGuidesState();
}

class _CustomContainerInfoGuidesState extends State<CustomContainerInfoGuides>
    with SingleTickerProviderStateMixin {
  late AnimationController _hoverController;
  late Animation<double> _hoverAnimation;

  @override
  void initState() {
    super.initState();
    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _hoverAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_hoverController);
  }

  @override
  void dispose() {
    _hoverController.dispose();
    super.dispose();
  }

  void _onHover(bool isHovering) {
    if (isHovering) {
      _hoverController.forward();
    } else {
      _hoverController.reverse();
    }
  }

  void _showImagePreview(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierColor: Colors.black.withOpacity(0.4),
        barrierDismissible: true,
        transitionDuration: const Duration(milliseconds: 350),
        reverseTransitionDuration: const Duration(milliseconds: 350),
        pageBuilder: (context, animation, secondaryAnimation) {
          return Stack(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(color: Colors.black.withOpacity(0.4)),
              ),
              Center(
                child: Hero(
                  tag: 'profile_image_${widget.userID}',
                  child: Material(
                    color: Colors.transparent,
                    child: ClipRRect(
                      child: Image.network(
                        widget.imageUrl.toHttps(),
                        width: 250.w,
                        height: 250.h,
                        fit: BoxFit.fill,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 320.w,
                            height: 320.w,
                            color: AppColors.whiteColor,
                            child: Icon(
                              Icons.person,
                              size: 150.sp,
                              color: AppColors.primaryColor,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _onHover(true),
      onExit: (_) => _onHover(false),
      child: AnimatedBuilder(
        animation: _hoverAnimation,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, -_hoverAnimation.value * 4),
            child: Container(
              height: 200.h,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryColor.withOpacity(
                      0.1 + (_hoverAnimation.value * 0.1),
                    ),
                    blurRadius: 16.r + (_hoverAnimation.value * 8),
                    offset: Offset(0, 4.h + (_hoverAnimation.value * 4)),
                    spreadRadius: _hoverAnimation.value * 2,
                  ),
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.05),
                    blurRadius: 8.r,
                    offset: const Offset(0, 2),
                  ),
                ],
                border: Border.all(
                  color: AppColors.primaryColor.withOpacity(
                    0.05 + (_hoverAnimation.value * 0.05),
                  ),
                  width: 1,
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                child: Row(
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        GestureDetector(
                          onTap: () => _showImagePreview(context),
                          child: Hero(
                            tag: 'profile_image_${widget.userID}',
                            placeholderBuilder: (context, heroSize, child) {
                              return child;
                            },
                            child: SizedBox(
                              height: 90.r,
                              width: 90.r,
                              child: ClipOval(
                                child: Image.network(
                                  widget.imageUrl.toHttps(),
                                  fit: BoxFit.fill,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      height: 90.r,
                                      width: 90.r,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        gradient: LinearGradient(
                                          colors: [
                                            AppColors.primaryColor.withOpacity(
                                              0.3,
                                            ),
                                            AppColors.primaryColor.withOpacity(
                                              0.1,
                                            ),
                                          ],
                                        ),
                                      ),
                                      child: Icon(
                                        Icons.person,
                                        size: 50.sp,
                                        color: AppColors.primaryColor,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "${widget.firstName} ${widget.lastName}",
                            style: AppTextStyle.primaryTextW600S22.copyWith(
                              fontSize: 16.sp,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Row(
                            children: [
                              Text(
                                widget.rating.toStringAsFixed(1),
                                style: AppTextStyle.primaryTextW500S17.copyWith(
                                  color: AppColors.starColore,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14.sp,
                                ),
                              ),
                              SizedBox(width: 4.w),
                              Row(
                                children: List.generate(5, (index) {
                                  final rating = widget.rating;
                                  final isFilled =
                                      index < rating.floor() ||
                                      (index == rating.floor() &&
                                          (rating - rating.floor()) >= 0.5);
                                  return Padding(
                                    padding: EdgeInsets.only(right: 1.w),
                                    child: Icon(
                                      isFilled ? Icons.star : Icons.star_border,
                                      color: AppColors.starColore,
                                      size: 12.sp,
                                    ),
                                  );
                                }),
                              ),
                            ],
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8.w,
                              vertical: 2.h,
                            ),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  AppColors.primaryColor.withOpacity(0.1),
                                  AppColors.primaryColor.withOpacity(0.05),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(6.r),
                              border: Border.all(
                                color: AppColors.primaryColor.withOpacity(0.2),
                              ),
                            ),
                            child: Text(
                              "\$${widget.price ?? 0} / Day",
                              style: AppTextStyle.primaryW500S16.copyWith(
                                fontWeight: FontWeight.w600,
                                fontSize: 12.sp,
                              ),
                            ),
                          ),
                          Transform.scale(
                            scale: 0.95 + (_hoverAnimation.value * 0.05),
                            child: CustomButtonWidget(
                              onPressed: () {
                                GoRouter.of(context).pushNamed(
                                  AppRoutes.tourGuideProfileScreen,
                                  pathParameters: {'userId': widget.userID},
                                );
                              },
                              borderRadiusButton: 8.r,
                              buttonHeight: 25.h,
                              buttonWidth: 99.w,
                              title: LocaleKeys.viewProfile.tr(),
                              titleStyle: AppTextStyle.whiteW600S20.copyWith(
                                fontSize: 12.sp,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

extension ImageUrlFix on String {
  String toHttps() {
    if (startsWith('http://')) {
      return replaceFirst('http://', 'https://');
    }
    return this;
  }
}
