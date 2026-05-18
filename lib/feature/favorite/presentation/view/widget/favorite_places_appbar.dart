import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:smart_guide/core/shared_widgets/custom_sliver_appbar_widget.dart';

class FavoriteSliverAppBar extends StatelessWidget {
  const FavoriteSliverAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomSliverAppbarWidget(title: "Guides Saved".tr());
  }
}
