import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_guide/feature/settings/presentation/view/widget/settings_appbar.dart';
import 'package:smart_guide/feature/settings/presentation/view/widget/settings_body.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: CustomScrollView(slivers: [SettingsAppbar(), SettingsBody()]),
      ),
    );
  }
}
