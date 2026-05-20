import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_guide/core/routing/app_routes.dart';
import 'package:smart_guide/core/services/cache/secure_storage_helper.dart';
import 'package:smart_guide/core/utils/app_colors.dart';
import 'package:smart_guide/core/utils/image_url_extension.dart';
import 'package:smart_guide/feature/guid_app/presentation/view/edit_tour_screen.dart';
import 'package:smart_guide/feature/home/presentation/widget/custom_home_app_bar.dart';

class GuideApp extends StatefulWidget {
  const GuideApp({super.key});

  @override
  State<GuideApp> createState() => _GuideAppState();
}

class _GuideAppState extends State<GuideApp> {
  String _userName = '';
  String? _profilePic;

  /// API DATA
  final List tours = [];

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final userName = await SecureStorageHelper.instance.getUserName();

    final profilePic = await SecureStorageHelper.instance.getProfilePic();

    if (!mounted) return;

    setState(() {
      _userName = userName ?? '';
      _profilePic = profilePic;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F6FF),

      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),

          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                SizedBox(height: 20.h),

                // =========================
                // Header
                // =========================
                CustomHomeAppBar(
                  title: "Welcome",
                  subTitle: _userName.isNotEmpty ? _userName : "Guide",
                  imageUrl: _profilePic?.toHttps(),
                ),

                SizedBox(height: 25.h),

                // =========================
                // Total Earnings
                // =========================
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 18.h),

                  decoration: BoxDecoration(
                    color: Colors.white,

                    borderRadius: BorderRadius.circular(18.r),

                    border: Border.all(color: AppColors.primaryColor, width: 2),

                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),

                  child: Column(
                    children: [
                      Icon(
                        Icons.account_balance_wallet_outlined,
                        color: Colors.green,
                        size: 24.sp,
                      ),

                      SizedBox(height: 8.h),

                      Text(
                        "Total Earnings",
                        style: TextStyle(
                          fontSize: 22.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      SizedBox(height: 5.h),

                      Text(
                        "0 EGP",
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 18.h),

                // =========================
                // Stats Cards
                // =========================
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        title: "Active Tours",
                        value: "${tours.length} Tours",
                        icon: Icons.menu_book_outlined,
                        valueColor: Colors.orange,
                      ),
                    ),

                    SizedBox(width: 10.w),

                    Expanded(
                      child: _buildStatCard(
                        title: "Total Tourists",
                        value: "0 Tourist",
                        icon: Icons.groups_2_outlined,
                        valueColor: Colors.blue,
                      ),
                    ),

                    SizedBox(width: 10.w),

                    Expanded(
                      child: _buildStatCard(
                        title: "Inactive Tours",
                        value: "0 Tours",
                        icon: Icons.disabled_by_default,
                        valueColor: Colors.red,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 25.h),

                // =========================
                // Empty State / Tours
                // =========================
                if (tours.isEmpty) ...[
                  _buildEmptyToursState(),
                ] else ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,

                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          Text(
                            "Active Tours",
                            style: TextStyle(
                              fontSize: 22.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          SizedBox(height: 4.h),

                          Text(
                            "Tours currently live for booking",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14.sp,
                            ),
                          ),
                        ],
                      ),

                      TextButton(
                        onPressed: () {},

                        child: Text(
                          "Show All",
                          style: TextStyle(
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 10.h),

                  _buildTourCard(
                    context: context,
                    image: 'assets/images/png/pyramids.jpg',
                    title: "Giza Pyramids & Sphinx Tour",
                  ),

                  SizedBox(height: 20.h),

                  _buildTourCard(
                    context: context,
                    image: 'assets/images/png/pyramids.jpg',
                    title: "Luxor Hot Air Balloon Adventure",
                  ),
                ],

                SizedBox(height: 30.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // =========================
  // Empty State
  // =========================

  Widget _buildEmptyToursState() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 50.h),

      child: Column(
        children: [
          Icon(
            Icons.inventory_2_outlined,
            size: 120.sp,
            color: Colors.grey.shade300,
          ),

          SizedBox(height: 20.h),

          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EditTourScreen()),
              );
            },

            child: Container(
              width: 65.w,
              height: 65.h,

              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.primaryColor, width: 2),
              ),

              child: Icon(
                Icons.add,
                color: AppColors.primaryColor,
                size: 35.sp,
              ),
            ),
          ),

          SizedBox(height: 20.h),

          Text(
            "Create New Tour",
            style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold),
          ),

          SizedBox(height: 10.h),

          Text(
            "Add a new adventure to your list",
            style: TextStyle(color: Colors.grey, fontSize: 16.sp),
          ),

          SizedBox(height: 30.h),

          SizedBox(
            width: 220.w,
            height: 52.h,

            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14.r),
                ),
              ),

              onPressed: () {
                context.pushNamed(AppRoutes.editTourScreen);
              },

              child: Text(
                "Create Tour",
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =========================
  // Stats Card
  // =========================

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color valueColor,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 14.h),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(16.r),

        border: Border.all(color: AppColors.primaryColor),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Column(
        children: [
          Icon(icon, color: valueColor, size: 20.sp),

          SizedBox(height: 8.h),

          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
          ),

          SizedBox(height: 6.h),

          Text(
            value,
            style: TextStyle(
              color: valueColor,
              fontWeight: FontWeight.bold,
              fontSize: 14.sp,
            ),
          ),
        ],
      ),
    );
  }

  // =========================
  // Tour Card
  // =========================

  Widget _buildTourCard({
    required BuildContext context,
    required String image,
    required String title,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Column(
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(18.r)),

                child: Image.asset(
                  image,
                  width: double.infinity,
                  height: 180.h,
                  fit: BoxFit.cover,
                ),
              ),

              Positioned(
                top: 10.h,
                right: 10.w,

                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        context.pushNamed(AppRoutes.editTourScreen);
                      },

                      child: _smallActionButton(
                        title: "Edit",
                        color: Colors.orange,
                      ),
                    ),

                    SizedBox(width: 6.w),

                    GestureDetector(
                      onTap: () {},

                      child: _smallActionButton(
                        title: "Delete",
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ),

              Positioned.fill(
                child: Container(
                  alignment: Alignment.center,

                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),

                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          Padding(
            padding: EdgeInsets.all(14.sp),

            child: Column(
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.price_change_outlined,
                      color: Colors.green,
                      size: 18.sp,
                    ),

                    SizedBox(width: 6.w),

                    Text(
                      "Price : ",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),

                    Text(
                      "1500 EGP",
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const Spacer(),

                    Icon(Icons.timer_outlined, color: Colors.blue, size: 18.sp),

                    SizedBox(width: 6.w),

                    Text(
                      "Duration : ",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),

                    Text(
                      "4 Hours",
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 12.h),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: [
                    Icon(
                      Icons.groups_outlined,
                      color: Colors.orange,
                      size: 18.sp,
                    ),

                    SizedBox(width: 6.w),

                    Text(
                      "Max Capacity : ",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),

                    Text(
                      "12 People",
                      style: TextStyle(
                        color: Colors.orange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 16.h),

                SizedBox(
                  width: double.infinity,

                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),

                    onPressed: () {},

                    child: const Text("View Details"),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // =========================
  // Small Action Button
  // =========================

  Widget _smallActionButton({required String title, required Color color}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),

      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8.r),
      ),

      child: Text(
        title,
        style: TextStyle(
          color: Colors.white,
          fontSize: 12.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
