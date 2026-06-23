import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:readmore/readmore.dart';
import 'package:smart_guide/core/utils/app_colors.dart';
import 'package:smart_guide/core/utils/app_text_style.dart';
import 'package:smart_guide/feature/details/presentation/view/widget/details_tour_appbar_widget.dart';
import 'package:smart_guide/feature/details/presentation/view/widget/details_tour_must_see_widget.dart';
import 'package:smart_guide/feature/home/data/model/place_model.dart';
import 'package:smart_guide/feature/home/presentation/cubit/get_place_details/get_place_details_cubit.dart';
import 'package:smart_guide/feature/home/presentation/cubit/get_place_details/get_place_details_state.dart';

class TouristPlaceDetailsScreen extends StatefulWidget {
  const TouristPlaceDetailsScreen({super.key});

  @override
  State<TouristPlaceDetailsScreen> createState() =>
      _TouristPlaceDetailsScreenState();
}

class _TouristPlaceDetailsScreenState extends State<TouristPlaceDetailsScreen>
    with TickerProviderStateMixin {
  late ScrollController _scrollController;
  late AnimationController _contentAnimationController;
  late AnimationController _headerAnimationController;

  late List<Animation<Offset>> _sectionSlideAnimations;
  late List<Animation<double>> _sectionFadeAnimations;

  double _scrollOffset = 0;

  String? _currentPlaceId;
  bool _ratingPromptShown = false;

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);

    _contentAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _headerAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _sectionSlideAnimations = [];
    _sectionFadeAnimations = [];

    for (int i = 0; i < 8; i++) {
      double start = (0.08 * i).clamp(0.0, 1.0);
      double end = (start + 0.5).clamp(0.0, 1.0);

      _sectionSlideAnimations.add(
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _contentAnimationController,
            curve: Interval(start, end, curve: Curves.easeOutCubic),
          ),
        ),
      );

      _sectionFadeAnimations.add(
        Tween<double>(begin: 0, end: 1).animate(
          CurvedAnimation(
            parent: _contentAnimationController,
            curve: Interval(start, end, curve: Curves.easeIn),
          ),
        ),
      );
    }

    _headerAnimationController.forward();
    _contentAnimationController.forward();
  }

  void _onScroll() {
    if (mounted) {
      setState(() {
        _scrollOffset = _scrollController.offset;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _contentAnimationController.dispose();
    _headerAnimationController.dispose();
    super.dispose();
  }

  void _showRatingSheet(BuildContext ctx, PlaceModel place) {
    showModalBottomSheet(
      context: ctx,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: ctx.read<GetPlaceDetailsCubit>(),
        child: _RatingBottomSheet(place: place),
      ),
    );
  }

  void _showRatingPromptDialog(BuildContext ctx, PlaceModel place) {
    showDialog(
      context: ctx,
      barrierDismissible: true,
      builder: (dialogCtx) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.r),
        ),
        backgroundColor: Colors.white,
        child: Padding(
          padding: EdgeInsets.all(24.r),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon
              Container(
                width: 64.r,
                height: 64.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1E3A8A), Color(0xFF3B82F6)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Icon(
                  Icons.rate_review_rounded,
                  color: Colors.white,
                  size: 30.sp,
                ),
              ),
              SizedBox(height: 18.h),
              Text(
                "Enjoying ${place.name}?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF1E3A8A),
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                "Share your experience and help other travellers discover this place.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13.sp,
                  color: Colors.grey.shade500,
                  height: 1.5,
                ),
              ),
              SizedBox(height: 24.h),
              // Rate Now button
              GestureDetector(
                onTap: () {
                  Navigator.of(dialogCtx).pop();
                  _showRatingSheet(ctx, place);
                },
                child: Container(
                  width: double.infinity,
                  height: 48.h,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF1E3A8A), Color(0xFF3B82F6)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(14.r),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryColor.withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.star_rounded,
                          color: Colors.amber,
                          size: 18.sp,
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          "Rate & Review",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10.h),
              // Cancel
              TextButton(
                onPressed: () => Navigator.of(dialogCtx).pop(),
                child: Text(
                  "Maybe Later",
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GetPlaceDetailsCubit, GetPlaceDetailsState>(
      listener: (context, state) {
        if (state is GetPlaceDetailsSuccess && !_ratingPromptShown) {
          _ratingPromptShown = true;
          final alreadyRated =
              state.place.myRating != null && state.place.myRating! > 0;
          if (!alreadyRated) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) _showRatingPromptDialog(context, state.place);
            });
          }
        }
        if (state is RatePlaceSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
          );
          // Refresh details to show updated rating & reviews
          if (_currentPlaceId != null) {
            context.read<GetPlaceDetailsCubit>().getPlaceDetails(
              placeId: _currentPlaceId!,
            );
          }
        }
        if (state is RatePlaceFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage),
              backgroundColor: AppColors.redAppColor,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is GetPlaceDetailsLoading) {
          return Scaffold(
            backgroundColor: AppColors.backgroundColor,
            body: Center(
              child: CircularProgressIndicator(color: AppColors.primaryColor),
            ),
          );
        }

        if (state is GetPlaceDetailsFailure) {
          return Scaffold(
            backgroundColor: AppColors.backgroundColor,
            body: Center(
              child: Text(
                state.errorMessage,
                style: TextStyle(color: Colors.red, fontSize: 16.sp),
              ),
            ),
          );
        }

        if (state is GetPlaceDetailsSuccess ||
            state is RatePlaceLoading ||
            state is RatePlaceSuccess ||
            state is RatePlaceFailure) {
          final cubit = context.read<GetPlaceDetailsCubit>();
          if (state is GetPlaceDetailsSuccess) {
            _currentPlaceId = state.place.id.toString();
          }
          final place = cubit.lastPlace;

          if (place == null) {
            return Scaffold(
              backgroundColor: AppColors.backgroundColor,
              body: Center(
                child: CircularProgressIndicator(color: AppColors.primaryColor),
              ),
            );
          }

          return Scaffold(
            backgroundColor: AppColors.backgroundColor,
            body: CustomScrollView(
              controller: _scrollController,
              physics: const BouncingScrollPhysics(),
              slivers: [
                DetailsTourAppbarWidget(
                  headerAnimationController: _headerAnimationController,
                  scrollOffset: _scrollOffset,
                  title: place.name,
                  rating: place.averageRating,
                  placeId: place.id,
                  imageUrl: place.imageUrl,
                ),

                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 30.h),

                        _buildAboutSection(place),
                        SizedBox(height: 24.h),

                        DetailsTourMustSeeWidget(
                          place: place,
                          sectionFadeAnimations: _sectionFadeAnimations,
                          sectionSlideAnimations: _sectionSlideAnimations,
                        ),
                        SizedBox(height: 24.h),

                        _buildRatingSummarySection(place),
                        SizedBox(height: 24.h),

                        _buildPlaceInfoSection(place),
                        SizedBox(height: 24.h),

                        _buildLocationSection(place),
                        SizedBox(height: 24.h),

                        _buildQuickFactsSection(place),
                        SizedBox(height: 24.h),

                        if (place.reviews.isNotEmpty) ...[
                          _buildReviewsSection(place),
                          SizedBox(height: 24.h),
                        ],

                        if (place.myRating == null || place.myRating! <= 0)
                          _buildRateButton(context, place),
                        SizedBox(height: 40.h),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        return Scaffold(
          backgroundColor: AppColors.backgroundColor,
          body: Center(
            child: Text("No data available", style: TextStyle(fontSize: 16.sp)),
          ),
        );
      },
    );
  }

  // ─── About ───────────────────────────────────────────────────────────────────

  Widget _buildAboutSection(PlaceModel place) {
    return SlideTransition(
      position: _sectionSlideAnimations[0],
      child: FadeTransition(
        opacity: _sectionFadeAnimations[0],
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18.r),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "About ${place.name}",
                style: AppTextStyle.thirdTextW900S20.copyWith(fontSize: 17.sp),
              ),
              SizedBox(height: 14.h),
              ReadMoreText(
                place.description.isNotEmpty
                    ? place.description
                    : "No description available",
                trimLines: 4,
                colorClickableText: AppColors.primaryColor,
                trimMode: TrimMode.Line,
                trimCollapsedText: ' Read More',
                trimExpandedText: ' Read Less',
                style: TextStyle(
                  fontSize: 13.sp,
                  color: Colors.grey.shade700,
                  height: 1.7,
                ),
                moreStyle: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryColor,
                ),
                lessStyle: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryColor,
                ),
              ),
              if (place.historicalBackground.isNotEmpty) ...[
                SizedBox(height: 22.h),
                Text(
                  "Historical Background",
                  style: AppTextStyle.thirdTextW900S20.copyWith(
                    fontSize: 15.sp,
                  ),
                ),
                SizedBox(height: 10.h),
                ReadMoreText(
                  place.historicalBackground,
                  trimLines: 3,
                  trimMode: TrimMode.Line,
                  trimCollapsedText: ' Read More',
                  trimExpandedText: ' Read Less',
                  colorClickableText: AppColors.primaryColor,
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: Colors.grey.shade700,
                    height: 1.7,
                  ),
                ),
              ],
              if (place.period.isNotEmpty) ...[
                SizedBox(height: 18.h),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 10.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor.withOpacity(.08),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.history_edu_rounded,
                        size: 18.sp,
                        color: AppColors.primaryColor,
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: Text(
                          place.period,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  // ─── Rating Summary ──────────────────────────────────────────────────────────

  Widget _buildRatingSummarySection(PlaceModel place) {
    final avg = place.averageRating.toDouble();
    final count = place.ratingsCount;
    final myRating = place.myRating;

    return SlideTransition(
      position: _sectionSlideAnimations[2],
      child: FadeTransition(
        opacity: _sectionFadeAnimations[2],
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFF1E3A8A).withOpacity(0.05),
                AppColors.primaryColor.withOpacity(0.08),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(18.r),
            border: Border.all(color: AppColors.primaryColor.withOpacity(0.15)),
          ),
          child: Row(
            children: [
              // Big average number
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    avg > 0 ? avg.toStringAsFixed(1) : '—',
                    style: TextStyle(
                      fontSize: 44.sp,
                      fontWeight: FontWeight.w900,
                      color: AppColors.primaryColor,
                      height: 1,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  _StarRow(rating: avg, size: 16.sp),
                  SizedBox(height: 4.h),
                  Text(
                    '$count ${count == 1 ? 'rating' : 'ratings'}',
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),

              SizedBox(width: 20.w),

              // Divider
              Container(
                width: 1,
                height: 80.h,
                color: AppColors.primaryColor.withOpacity(0.15),
              ),

              SizedBox(width: 20.w),

              // My rating info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Your Rating",
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.grey.shade500,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    if (myRating != null && myRating > 0) ...[
                      _StarRow(rating: myRating.toDouble(), size: 20.sp),
                      SizedBox(height: 4.h),
                      Text(
                        "${myRating.toStringAsFixed(0)} / 5",
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ] else ...[
                      Text(
                        "You haven't rated yet",
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.grey.shade400,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Place Info ──────────────────────────────────────────────────────────────

  Widget _buildPlaceInfoSection(PlaceModel place) {
    return SlideTransition(
      position: _sectionSlideAnimations[3],
      child: FadeTransition(
        opacity: _sectionFadeAnimations[3],
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18.r),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Place Information",
                style: AppTextStyle.thirdTextW900S20.copyWith(fontSize: 17.sp),
              ),
              SizedBox(height: 18.h),
              _buildInfoRow(Icons.category_outlined, "Type", place.type),
              SizedBox(height: 14.h),
              _buildInfoRow(Icons.location_city_outlined, "City", place.city),
              SizedBox(height: 14.h),
              _buildInfoRow(
                Icons.map_outlined,
                "Governorate",
                place.governorate,
              ),
              SizedBox(height: 14.h),
              _buildInfoRow(
                Icons.person_outline_rounded,
                "Created By",
                place.createdBy.isNotEmpty ? place.createdBy : "Unknown",
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Location ────────────────────────────────────────────────────────────────

  Widget _buildLocationSection(PlaceModel place) {
    return SlideTransition(
      position: _sectionSlideAnimations[4],
      child: FadeTransition(
        opacity: _sectionFadeAnimations[4],
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18.r),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Location",
                style: AppTextStyle.thirdTextW900S20.copyWith(fontSize: 17.sp),
              ),
              SizedBox(height: 16.h),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(14.r),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withOpacity(.06),
                  borderRadius: BorderRadius.circular(14.r),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.location_on_rounded,
                      color: AppColors.primaryColor,
                      size: 22.sp,
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Text(
                        place.location.isNotEmpty
                            ? place.location
                            : "Unknown location",
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: Colors.grey.shade700,
                          height: 1.6,
                          fontWeight: FontWeight.w500,
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
  }

  // ─── Quick Facts ─────────────────────────────────────────────────────────────

  Widget _buildQuickFactsSection(PlaceModel place) {
    return SlideTransition(
      position: _sectionSlideAnimations[5],
      child: FadeTransition(
        opacity: _sectionFadeAnimations[5],
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18.r),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Quick Facts",
                style: AppTextStyle.thirdTextW900S20.copyWith(fontSize: 17.sp),
              ),
              SizedBox(height: 18.h),
              Row(
                children: [
                  Expanded(
                    child: _buildFactCard(
                      icon: Icons.star_rounded,
                      title: "Avg Rating",
                      value: place.averageRating > 0
                          ? place.averageRating.toStringAsFixed(1)
                          : "No ratings",
                      iconColor: Colors.amber,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: _buildFactCard(
                      icon: Icons.people_outline_rounded,
                      title: "Reviews",
                      value: place.ratingsCount.toString(),
                      iconColor: AppColors.primaryColor,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  // Expanded(
                  //   child: _buildFactCard(
                  //     icon: Icons.calendar_month_rounded,
                  //     title: "Start Year",
                  //     value: place.startYear?.toString() ?? "Unknown",
                  //     iconColor: const Color(0xFF059669),
                  //   ),
                  // ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Reviews List ────────────────────────────────────────────────────────────

  Widget _buildReviewsSection(PlaceModel place) {
    return SlideTransition(
      position: _sectionSlideAnimations[6],
      child: FadeTransition(
        opacity: _sectionFadeAnimations[6],
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18.r),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    "Visitor Reviews",
                    style: AppTextStyle.thirdTextW900S20.copyWith(
                      fontSize: 17.sp,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Text(
                      "${place.reviews.length}",
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              ...place.reviews.take(5).map((r) => _ReviewItem(review: r)),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Rate button ─────────────────────────────────────────────────────────────

  Widget _buildRateButton(BuildContext ctx, PlaceModel place) {
    return SlideTransition(
      position: _sectionSlideAnimations[7],
      child: FadeTransition(
        opacity: _sectionFadeAnimations[7],
        child: GestureDetector(
          onTap: () => _showRatingSheet(ctx, place),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 18.h),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1E3A8A), Color(0xFF3B82F6)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(18.r),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryColor.withOpacity(0.35),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.rate_review_rounded,
                  color: Colors.white,
                  size: 20.sp,
                ),
                SizedBox(width: 10.w),
                Text(
                  place.myRating != null && place.myRating! > 0
                      ? "Update Your Review"
                      : "Rate & Review",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ─── Shared helpers ──────────────────────────────────────────────────────────

  Widget _buildFactCard({
    required IconData icon,
    required String title,
    required String value,
    Color? iconColor,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: AppColors.primaryColor.withOpacity(.06),
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Column(
        children: [
          Icon(icon, color: iconColor ?? AppColors.primaryColor, size: 22.sp),
          SizedBox(height: 10.h),
          Text(
            title,
            style: TextStyle(fontSize: 11.sp, color: Colors.grey.shade600),
          ),
          SizedBox(height: 6.h),
          Text(
            value,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(8.r),
          decoration: BoxDecoration(
            color: AppColors.primaryColor.withOpacity(.08),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Icon(icon, size: 18.sp, color: AppColors.primaryColor),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 5.h),
              Text(
                value.isNotEmpty ? value : "Unknown",
                style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ─── Star Row ──────────────────────────────────────────────────────────────────

class _StarRow extends StatelessWidget {
  final double rating;
  final double size;

  const _StarRow({required this.rating, required this.size});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (i) {
        final filled = i < rating.floor();
        final half = !filled && i < rating;
        return Icon(
          filled
              ? Icons.star_rounded
              : half
              ? Icons.star_half_rounded
              : Icons.star_outline_rounded,
          color: Colors.amber,
          size: size,
        );
      }),
    );
  }
}

// ─── Review Item ───────────────────────────────────────────────────────────────

class _ReviewItem extends StatelessWidget {
  final PlaceReviewModel review;
  const _ReviewItem({required this.review});

  String _formatDate(String raw) {
    try {
      final dt = DateTime.parse(raw);
      return "${dt.day}/${dt.month}/${dt.year}";
    } catch (_) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _StarRow(rating: review.rating.toDouble(), size: 14.sp),
              const Spacer(),
              Text(
                _formatDate(review.createdAtUtc),
                style: TextStyle(fontSize: 11.sp, color: Colors.grey.shade400),
              ),
            ],
          ),
          if (review.review.isNotEmpty) ...[
            SizedBox(height: 8.h),
            Text(
              review.review,
              style: TextStyle(
                fontSize: 13.sp,
                color: Colors.grey.shade700,
                height: 1.5,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ─── Rating Bottom Sheet ───────────────────────────────────────────────────────

class _RatingBottomSheet extends StatefulWidget {
  final PlaceModel place;
  const _RatingBottomSheet({required this.place});

  @override
  State<_RatingBottomSheet> createState() => _RatingBottomSheetState();
}

class _RatingBottomSheetState extends State<_RatingBottomSheet> {
  int _selectedRating = 0;
  final _reviewController = TextEditingController();
  final List<String> _ratingLabels = [
    '',
    'Terrible',
    'Poor',
    'Average',
    'Good',
    'Excellent',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.place.myRating != null && widget.place.myRating! > 0) {
      _selectedRating = widget.place.myRating!.toInt();
    }
    _reviewController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  bool get _canSubmit =>
      _selectedRating > 0 || _reviewController.text.trim().isNotEmpty;

  void _submit() {
    if (!_canSubmit) return;
    context.read<GetPlaceDetailsCubit>().ratePlace(
      placeId: widget.place.id.toString(),
      rating: _selectedRating,
      review: _reviewController.text.trim(),
    );
    // Keep sheet open — BlocConsumer below closes it on success/failure
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GetPlaceDetailsCubit, GetPlaceDetailsState>(
      listener: (context, state) {
        if (state is RatePlaceSuccess || state is RatePlaceFailure) {
          Navigator.of(context).pop();
        }
      },
      builder: (context, state) {
        final isLoading = state is RatePlaceLoading;
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
          ),
          padding: EdgeInsets.fromLTRB(
            24.w,
            20.h,
            24.w,
            MediaQuery.of(context).viewInsets.bottom + 24.h,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle
              Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              SizedBox(height: 20.h),

              // Title
              Text(
                "Rate ${widget.place.name}",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primaryColor,
                ),
              ),
              SizedBox(height: 6.h),
              Text(
                "Share your experience with other travellers",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12.sp, color: Colors.grey.shade500),
              ),
              SizedBox(height: 24.h),

              // Stars
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (i) {
                  final star = i + 1;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedRating = star),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      padding: EdgeInsets.all(4.r),
                      child: Icon(
                        _selectedRating >= star
                            ? Icons.star_rounded
                            : Icons.star_outline_rounded,
                        color: _selectedRating >= star
                            ? Colors.amber
                            : Colors.grey.shade300,
                        size: 40.sp,
                      ),
                    ),
                  );
                }),
              ),
              SizedBox(height: 8.h),

              // Label
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: Text(
                  _selectedRating > 0 ? _ratingLabels[_selectedRating] : ' ',
                  key: ValueKey(_selectedRating),
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: _selectedRating >= 4
                        ? const Color(0xFF059669)
                        : _selectedRating >= 3
                        ? Colors.orange
                        : _selectedRating > 0
                        ? AppColors.redAppColor
                        : Colors.transparent,
                  ),
                ),
              ),
              SizedBox(height: 20.h),

              // Review text field
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: TextField(
                  controller: _reviewController,
                  maxLines: 4,
                  minLines: 2,
                  maxLength: 300,
                  style: TextStyle(fontSize: 13.sp),
                  decoration: InputDecoration(
                    hintText: "Write your review (optional)...",
                    hintStyle: TextStyle(
                      color: Colors.grey.shade400,
                      fontSize: 13.sp,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(14.r),
                    counterStyle: TextStyle(
                      fontSize: 11.sp,
                      color: Colors.grey.shade400,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20.h),

              // Submit button — active only when rating or review is filled
              GestureDetector(
                onTap: (isLoading || !_canSubmit) ? null : _submit,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: double.infinity,
                  height: 54.h,
                  decoration: BoxDecoration(
                    gradient: (_canSubmit && !isLoading)
                        ? const LinearGradient(
                            colors: [Color(0xFF1E3A8A), Color(0xFF3B82F6)],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          )
                        : null,
                    color: (!_canSubmit || isLoading)
                        ? Colors.grey.shade300
                        : null,
                    borderRadius: BorderRadius.circular(16.r),
                    boxShadow: (_canSubmit && !isLoading)
                        ? [
                            BoxShadow(
                              color: AppColors.primaryColor.withOpacity(0.3),
                              blurRadius: 12,
                              offset: const Offset(0, 5),
                            ),
                          ]
                        : null,
                  ),
                  child: Center(
                    child: isLoading
                        ? SizedBox(
                            width: 22.r,
                            height: 22.r,
                            child: const CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.5,
                            ),
                          )
                        : Text(
                            "Submit Review",
                            style: TextStyle(
                              color: _canSubmit
                                  ? Colors.white
                                  : Colors.grey.shade500,
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
