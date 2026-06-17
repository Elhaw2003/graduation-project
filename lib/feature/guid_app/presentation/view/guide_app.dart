import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_guide/core/network/dio_consumer.dart';
import 'package:smart_guide/core/routing/app_routes.dart';
import 'package:smart_guide/core/utils/app_colors.dart';
import 'package:smart_guide/core/utils/image_url_extension.dart';
import 'package:smart_guide/feature/chat/data/repo/chat_repo_impl.dart';
import 'package:smart_guide/feature/chat/presentation/cubit/chat_inbox/chat_inbox_cubit.dart';
import 'package:smart_guide/feature/chat/presentation/view/screens/chat_inbox_screen.dart';
import 'package:smart_guide/feature/guid_app/presentation/cubit/guide_session/guide_session_cubit.dart';
import 'package:smart_guide/feature/guid_app/presentation/cubit/guide_session/guide_session_states.dart';
import 'package:smart_guide/feature/guid_app/presentation/view/edit_tour_screen.dart';
import 'package:smart_guide/feature/guid_app/presentation/view/widget/guide_bookings_live_feed.dart';
import 'package:smart_guide/feature/home/presentation/widget/custom_home_app_bar.dart';

class GuideApp extends StatefulWidget {
  const GuideApp({super.key});

  @override
  State<GuideApp> createState() => _GuideAppState();
}

class _GuideAppState extends State<GuideApp> {
  int _selectedTab = 0;

  static const List tours = [];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GuideSessionCubit, GuideSessionState>(
      builder: (context, sessionState) {
        final session = sessionState is GuideSessionLoaded
            ? sessionState
            : const GuideSessionLoaded(
                userName: '',
                profilePic: null,
                userId: '',
              );

        return Scaffold(
          backgroundColor: const Color(0xffF5F6FF),
          body: IndexedStack(
            index: _selectedTab,
            children: [
              _BookingsTab(session: session, tours: tours),
              BlocProvider(
                create: (_) => ChatInboxCubit(
                  chatRepo: ChatRepoImpl(
                    apiConsumer: DioConsumer(dio: Dio()),
                  ),
                )..loadInbox(),
                child: const ChatInboxScreen(),
              ),
            ],
          ),
          bottomNavigationBar: _GuideBottomNav(
            currentIndex: _selectedTab,
            onTap: (i) => setState(() => _selectedTab = i),
          ),
        );
      },
    );
  }
}

class _GuideBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _GuideBottomNav({required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 4.h),
          child: Row(
            children: [
              _NavItem(
                icon: Icons.calendar_today_rounded,
                activeIcon: Icons.calendar_today_rounded,
                label: 'Bookings',
                isActive: currentIndex == 0,
                onTap: () => onTap(0),
              ),
              _NavItem(
                icon: Icons.chat_bubble_outline_rounded,
                activeIcon: Icons.chat_bubble_rounded,
                label: 'Chats',
                isActive: currentIndex == 1,
                onTap: () => onTap(1),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: isActive
                    ? AppColors.primaryColor.withOpacity(0.12)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Icon(
                isActive ? activeIcon : icon,
                color: isActive ? AppColors.primaryColor : AppColors.grey400Color,
                size: 22.sp,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              label,
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                color: isActive ? AppColors.primaryColor : AppColors.grey400Color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BookingsTab extends StatelessWidget {
  final GuideSessionLoaded session;
  final List tours;

  const _BookingsTab({required this.session, required this.tours});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.h),
              CustomHomeAppBar(
                key: ValueKey(
                  '${session.userId}_${session.profilePic ?? session.userName}',
                ),
                title: 'Welcome',
                subTitle:
                    session.userName.isNotEmpty ? session.userName : 'Guide',
                imageUrl: session.profilePic?.toHttps(),
                onTap: () async {
                  if (session.userId.isEmpty) return;
                  await context.pushNamed(
                    AppRoutes.tourGuideProfileScreen,
                    pathParameters: {'userId': session.userId},
                  );
                  if (context.mounted) {
                    context.read<GuideSessionCubit>().loadFromCache();
                  }
                },
              ),
              SizedBox(height: 25.h),
              const GuideBookingsLiveFeed(),
              SizedBox(height: 25.h),
              if (tours.isNotEmpty) ...[
                _buildActiveToursHeader(),
                SizedBox(height: 10.h),
                _buildTourCard(
                  context: context,
                  image: 'assets/images/png/pyramids.jpg',
                  title: 'Giza Pyramids & Sphinx Tour',
                ),
                SizedBox(height: 20.h),
                _buildTourCard(
                  context: context,
                  image: 'assets/images/png/pyramids.jpg',
                  title: 'Luxor Hot Air Balloon Adventure',
                ),
              ],
              SizedBox(height: 30.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActiveToursHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Active Tours',
              style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4.h),
            Text(
              'Tours currently live for booking',
              style: TextStyle(color: Colors.grey, fontSize: 14.sp),
            ),
          ],
        ),
        TextButton(
          onPressed: () {},
          child: Text(
            'Show All',
            style: TextStyle(
              color: AppColors.primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const EditTourScreen(),
                          ),
                        );
                      },
                      child: _smallActionButton(title: "Edit", color: Colors.orange),
                    ),
                    SizedBox(width: 6.w),
                    GestureDetector(
                      onTap: () {},
                      child: _smallActionButton(title: "Delete", color: Colors.red),
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
                    Icon(Icons.price_change_outlined,
                        color: Colors.green, size: 18.sp),
                    SizedBox(width: 6.w),
                    Text("Price : ",
                        style: TextStyle(fontWeight: FontWeight.w600)),
                    Text("1500 EGP",
                        style: TextStyle(
                            color: Colors.green, fontWeight: FontWeight.bold)),
                    const Spacer(),
                    Icon(Icons.timer_outlined, color: Colors.blue, size: 18.sp),
                    SizedBox(width: 6.w),
                    Text("Duration : ",
                        style: TextStyle(fontWeight: FontWeight.w600)),
                    Text("4 Hours",
                        style: TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.bold)),
                  ],
                ),
                SizedBox(height: 16.h),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r)),
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
            color: Colors.white, fontSize: 12.sp, fontWeight: FontWeight.bold),
      ),
    );
  }
}
