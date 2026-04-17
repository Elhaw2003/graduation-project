import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:smart_guide/core/shared_widgets/custom_grid_view.dart';
import 'package:smart_guide/core/shared_widgets/custom_spacing_widget.dart';
import 'package:smart_guide/feature/home/presentation/widget/custom_container_for_search.dart';
import 'package:smart_guide/feature/home/presentation/widget/custom_home_app_bar.dart';
import 'package:smart_guide/feature/home/presentation/widget/custom_section_title_with_action.dart';
import 'package:smart_guide/generated/locale_keys.g.dart';

class HomeBody extends StatelessWidget {
  const HomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(right: 16.0),
        child: Column(
          children: [
            CustomHeightSpacingWidget(height: 30),
            CustomHomeAppBar(
              title: LocaleKeys.hello.tr(),
              subTitle: LocaleKeys.cairoEgypt.tr(),
            ),
            CustomHeightSpacingWidget(height: 29),
            CustomContainerForSearch(),
            CustomHeightSpacingWidget(height: 15),
            CustomSectionTitleWithAction(),
            CustomHeightSpacingWidget(height: 8),
            CustomGridView(),
          ],
        ),
      ),
    );
  }
}
