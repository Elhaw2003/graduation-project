import 'package:flutter/material.dart';
import 'package:smart_guide/core/shared_widgets/custom_spacing_widget.dart';
import 'package:smart_guide/feature/home/presentation/widget/custom_home_app_bar.dart';

class HomeBody extends StatelessWidget {
  const HomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(right: 16.0),
        child: Column(
          children: [CustomHeightSpacingWidget(height: 30), CustomHomeAppBar()],
        ),
      ),
    );
  }
}
