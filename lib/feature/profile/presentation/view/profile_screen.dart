import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_guide/core/shared_widgets/custom_spacing_widget.dart';
import 'package:smart_guide/feature/profile/data/model/dash_board_model.dart';
import 'package:smart_guide/feature/profile/presentation/view/widget/dash_board_card.dart';
import 'package:smart_guide/feature/profile/presentation/view/widget/profile_appbar.dart';
import 'package:smart_guide/feature/profile/presentation/view/widget/profile_body.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          ProfileAppbar(),
          ProfileBody(),
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 17.w),
            sliver: SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16.h,
                crossAxisSpacing: 16.w,
                childAspectRatio: 0.8, // ضبط النسبة عشان التصميم ميبقاش مضغوط
              ),
              delegate: SliverChildBuilderDelegate((context, index) {
                return DashboardCard(item: dashboards(context)[index]);
              }, childCount: dashboards(context).length),
            ),
          ),
          SliverToBoxAdapter(child: CustomHeightSpacingWidget(height: 20.h)),
        ],
      ),
    );
  }
}
