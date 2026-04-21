import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_guide/core/shared_widgets/custom_spacing_widget.dart';
import 'package:smart_guide/feature/profile/presentation/view/widget/prfile_details.dart';

class ProfileBody extends StatelessWidget {
  const ProfileBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 17.h),
        child: Column(
          children: [
            CustomHeightSpacingWidget(height: 20),
            PrfileDetails(),
            CustomHeightSpacingWidget(height: 30),
          ],
        ),
      ),
    );
  }
}
